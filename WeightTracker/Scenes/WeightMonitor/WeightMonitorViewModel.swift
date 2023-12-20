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
    
    var records: [WeightRecord] = []
    
    init(store: WeightsStore) {
        self.store = store
        
        listRecords()
    }
 
    func listRecords() {
        let sort = NSSortDescriptor(key: "date", ascending: true)
        
        do {
            records = try store.list(withSort: [sort]).map { WeightRecord(value: $0.value, date: $0.date!) }
        } catch {
            print("failed to get list")
        }
        
        delegate?.reloadData()
    }
    
    func addRecord(record: WeightRecord) throws {
        try store.add(record: record)
    }
}

