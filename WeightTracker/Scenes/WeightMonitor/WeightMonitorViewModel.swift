import Foundation
import UIKit

protocol WeightMonitorViewModelDelegate: AnyObject {
    func reloadData()
    func showAlert(alert: AlertModel)
}

class WeightMonitorViewModel {
    private let store: WeightsStore
    
    weak var delegate: WeightMonitorViewModelDelegate?
    
    var currentWeight: String = "0"
    var currentDiff: String = "0"
    var records: [WeightDisplayModel] = []
    
    init(store: WeightsStore) {
        self.store = store
    }
    
    func loadData() {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        var recordCoreDatas: [WeightCoreData] = []
        records = []
        
        do {
            recordCoreDatas = try store.list(withSort: [sort])
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось загрузить записи",
                actions: [
                    UIAlertAction(
                        title: "Попробовать еще",
                        style: .default
                    ) { [weak self] _ in
                        self?.loadData()
                    },
                    UIAlertAction(
                        title: "Закрыть",
                        style: .cancel
                    ) { _ in }
                ]
            )
            
            delegate?.showAlert(alert: alertModel)
            return
        }
        
        for i in 0..<recordCoreDatas.count {
            var record = WeightDisplayModel(
                weight: (recordCoreDatas[i].weightValue! as Decimal).formatWeight(),
                date: formatDate(date: recordCoreDatas[i].date!)
            )
            
            if i < recordCoreDatas.count - 1 {
                let diff = (recordCoreDatas[i].weightValue! as Decimal) - (recordCoreDatas[i+1].weightValue! as Decimal)
                record.diff = diff.formatWeightDiff()
            }
            
            records.append(record)
        }
        
        currentWeight = records.count > 0 ? records[0].weight : "0"
        currentDiff = records.count > 1 ? (records[0].diff ?? "") : ""
        
        delegate?.reloadData()
    }
    
    func formatDate(date: Date) -> String {
        if date < Date().startOfYear() {
            return date.formatShortFullDate()
        }
        return date.formatDayMonth()
    }
}

