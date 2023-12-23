import UIKit
import Foundation

protocol WeightMonitorViewModelDelegate: AnyObject {
    func updateCurrentWeight()
    func showAlert(alert: AlertModel)
}

class WeightMonitorViewModel {
    typealias DiffableDatasource = UITableViewDiffableDataSource<Int, WeightRecord.ID>
    typealias DiffableDatasourceSnapshot = NSDiffableDataSourceSnapshot<Int, WeightRecord.ID>

    private let store: WeightsStoreProtocol
    weak var delegate: WeightMonitorViewModelDelegate?

    private var dataSource: DiffableDatasource?

    var currentWeight: Decimal = 0
    var currentDiff: Decimal = 0
    var records: [WeightRecord] = []
    
    init(store: WeightsStoreProtocol) {
        self.store = store
    }
    
    func loadData(tableView: UITableView, cellProvider: @escaping DiffableDatasource.CellProvider) {
        records.removeAll(keepingCapacity: true)

        do {
            records = try store.listRecords(withSort: [NSSortDescriptor(key: "date", ascending: false)]).map({
                WeightRecord(id: $0.recordId!, weightValue: $0.weightValue! as Decimal, date: $0.date!)
            })

            updateCurrentWeight()
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось загрузить записи",
                actions: ["Попробовать еще": { self.loadData(tableView: tableView, cellProvider: cellProvider) }]
            )
            delegate?.showAlert(alert: alertModel)
            return
        }

        let dataSource = DiffableDatasource(tableView: tableView, cellProvider: cellProvider)
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(records.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: false)

        self.dataSource = dataSource
    }

    func updateCurrentWeight() {
        currentWeight = records.first?.weightValue ?? 0
        currentDiff = records.count > 1 ? (currentWeight - records[1].weightValue) : 0

        delegate?.updateCurrentWeight()
    }
    
    func deleteRecord(at index: Int) {
        guard let dataSource = self.dataSource else {
            assertionFailure("using deleteRecord() before initDatasource()")
            return
        }

        let deleteRecord = records[index]
        do {
            try store.deleteRecord(by: deleteRecord.id)
            records.remove(at: index)

            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([deleteRecord.id])
            if index > 0 {
                snapshot.reconfigureItems([records[index - 1].id])
            }
            dataSource.apply(snapshot, animatingDifferences: true)

            updateCurrentWeight()
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось удалить запись"
            )
            delegate?.showAlert(alert: alertModel)
        }
    }
}

extension WeightMonitorViewModel: WeightDataMutator {
    func updateRecord(updateRecord: WeightRecord) throws {
        guard let dataSource = self.dataSource else {
            assertionFailure("using deleteRecord() before initDatasource()")
            return
        }

        guard let updateIndex = records.firstIndex(where: { $0.id == updateRecord.id }) else {
            assertionFailure("should be never happens")
            return
        }

        let _ = try store.updateRecord(updateRecord)
        records[updateIndex] = updateRecord

        let reconfigureItems = updateIndex > 0
            ? [updateRecord.id, records[updateIndex - 1].id]
            : [updateRecord.id]

        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(reconfigureItems)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        updateCurrentWeight()
    }
    
    func addRecord(record: WeightRecord) throws {
        guard let dataSource = self.dataSource else {
            assertionFailure("using deleteRecord() before initDatasource()")
            return
        }

        try store.addRecord(record: record)

        let insertIndex = records.firstIndex(where: { $0.date < record.date }) ?? records.endIndex
        records.insert(record, at: insertIndex)

        var snapshot = dataSource.snapshot()
        if insertIndex == records.count - 1 {
            snapshot.appendItems([record.id])
        } else {
            snapshot.insertItems([record.id], beforeItem: records[insertIndex+1].id)
        }

        if insertIndex != 0 {
            snapshot.reconfigureItems([records[insertIndex-1].id])
        }
        dataSource.apply(snapshot, animatingDifferences: true)

        updateCurrentWeight()
    }
}
