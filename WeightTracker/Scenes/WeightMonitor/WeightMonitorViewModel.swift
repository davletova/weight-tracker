import Foundation

protocol WeightMonitorViewModelDelegate: AnyObject {
    func reloadData()
    func showAlert(alert: AlertModel)
    func deleteRow(indexPath: IndexPath, deleteRecord: WeightRecord)
    func addRow(index: Int)
    func reconfigureRow(record: WeightRecord, index: Int)
}

class WeightMonitorViewModel {
    private let store: WeightsStoreProtocol
    
    weak var delegate: WeightMonitorViewModelDelegate?
    
    var currentWeight: Decimal = 0
    var currentDiff: Decimal = 0
    var records: [WeightRecord] = []
    
    init(store: WeightsStoreProtocol) {
        self.store = store
    }
    
    func loadData() {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        var recordCoreDatas: [WeightCoreData] = []
        records = []
        
        do {
            recordCoreDatas = try store.listRecords(withSort: [sort])
            
            for i in 0..<recordCoreDatas.count {
                let record = WeightRecord(
                    id: recordCoreDatas[i].recordId!,
                    weightValue: recordCoreDatas[i].weightValue! as Decimal,
                    date: recordCoreDatas[i].date!
                )
                records.append(record)
            }
            
            currentWeight = records.count > 0 ? records[0].weightValue : 0
            currentDiff = records.count > 1 ? (records[0].weightValue - records[1].weightValue) : 0
            
            delegate?.reloadData()
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось загрузить записи",
                actions: ["Попробовать еще": { self.loadData() }]
            )
            delegate?.showAlert(alert: alertModel)
        }
    }
    
    func deleteRecord(at index: Int) {
        let deleteRecord = records[index]
        do {
            try store.deleteRecord(by: deleteRecord.id)
            records.remove(at: index)
            
            if index < 2 {
                currentDiff = records.count > 1 ? (records[0].weightValue - records[1].weightValue) : 0
                if index == 0 {
                    currentWeight = records.isEmpty ? 0 : records[0].weightValue
                }
            }
            delegate?.deleteRow(indexPath: IndexPath(row: index, section: 0), deleteRecord: deleteRecord)
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось удалить запись"
            )
            delegate?.showAlert(alert: alertModel)
        }
    }
}

extension WeightMonitorViewModel: WeightsTableUpdater {
    func updateRecord(updateRecord: WeightRecord, index: Int) {
        if index > records.count - 1 {
            assertionFailure("should never happen")
            return
        }
        
        records[index] = updateRecord
        
        if index < 2 {
            currentDiff = records.count > 1 ? (records[0].weightValue - records[1].weightValue) : 0
            if index == 0 {
                currentWeight = records[0].weightValue
            }
        }
        
        delegate?.reconfigureRow(record: updateRecord, index: index)
    }
    
    func addRecord(record: WeightRecord) {
        let index = addRecordToList(record: record)
        
        if index < 2 {
            currentDiff = records.count > 1 ? (records[0].weightValue - records[1].weightValue) : 0
            if index == 0 {
                currentWeight = records[0].weightValue
            }
        }
        
        delegate?.addRow(index: index)
    }
    
    func addRecordToList(record: WeightRecord) -> Int {
        guard let index = records.firstIndex(where: { $0.date < record.date }) else {
            records.append(record)
            return records.count - 1
        }
        
        records.insert(record, at: index)
        return index
    }
}
