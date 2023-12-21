import Foundation
import UIKit

protocol WeightMonitorViewModelDelegate: AnyObject {
    func reloadData()
    func showAlert(alert: AlertModel)
}

class WeightMonitorViewModel {
    private let store: WeightsStore
    
    weak var delegate: WeightMonitorViewModelDelegate?
    
    var records: [WeightDisplayModel] = []
    
    init(store: WeightsStore) {
        self.store = store
    }
    
    func listRecords() {
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
                        self?.listRecords()
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
        
        delegate?.reloadData()
    }
    
    func formatDate(date: Date) -> String {
        if date < Date().startOfYear() {
            return date.formatShortFullDate()
        }
        return date.formatDayMonth()
    }
}

