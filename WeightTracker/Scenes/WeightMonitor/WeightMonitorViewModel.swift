//
//  WeightMonitorViewModel.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 18.12.2023.
//

import Foundation

protocol WeightMonitorViewModelDelegate: AnyObject {
    func reloadData()
}

class WeightMonitorViewModel {
    private let store: WeightsStore
    
    weak var delegate: WeightMonitorViewModelDelegate?
    
    var records: [WeightDisplayModel] = []
    
    init(store: WeightsStore) {
        self.store = store
        
        listRecords()
    }
 
    func listRecords() {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        var recordCoreDatas: [WeightCoreData] = []
        records = []
        
        do {
            recordCoreDatas = try store.list(withSort: [sort])
        } catch {
            print("failed to get list")
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
    
    func addRecord(record: WeightRecord) throws {
        try store.add(record: record)
    }
    
    func formatDate(date: Date) -> String {
        if date < Date().startOfYear() {
            return date.formatShortFullDate()
        }
        return date.formatDayMonth()
    }
}

