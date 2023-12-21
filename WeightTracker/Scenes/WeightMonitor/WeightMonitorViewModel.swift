import Foundation
import UIKit

protocol WeightMonitorViewModelDelegate: AnyObject {
    func reloadData()
    func reloadRows(indexPathes: [IndexPath])
    func showAlert(alert: AlertModel)
    func deleteRows(indexPathes: [IndexPath])
}

class WeightMonitorViewModel {
    private let store: WeightsStore
    
    weak var delegate: WeightMonitorViewModelDelegate?
    
    var currentWeight: Decimal = 0
    var currentDiff: Decimal = 0
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
                id: recordCoreDatas[i].recordId!,
                weight: recordCoreDatas[i].weightValue! as Decimal,
                date: recordCoreDatas[i].date!
            )
            
            if i < recordCoreDatas.count - 1 {
                let diff = (recordCoreDatas[i].weightValue! as Decimal) - (recordCoreDatas[i+1].weightValue! as Decimal)
                record.diff = diff
            }
            
            records.append(record)
        }
        
        currentWeight = records.count > 0 ? records[0].weight : 0
        currentDiff = records.count > 1 ? (records[0].diff ?? 0) : 0
        
        print(records)
        
        delegate?.reloadData()
    }
    
    func deleteRecord(id: UUID, indexPath: IndexPath) {
        do {
            try store.deleteRecord(by: id)
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось удалить запись",
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
        
        delegate?.deleteRows(indexPathes: [indexPath])
        
        if indexPath.row != 0 || indexPath.row < records.count - 1 {
            let diff = records[indexPath.row-1].weight - records[indexPath.row].weight
            records[indexPath.row-1].diff = diff
            print(indexPath)
            delegate?.reloadRows(indexPathes: [IndexPath(row: indexPath.row - 1, section: 0)])
        }
        
        delegate?.deleteRows(indexPathes: [indexPath])
    }
}

