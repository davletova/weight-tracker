//
//  WeightMonitorViewModel.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 18.12.2023.
//

import Foundation

class WeightMonitorViewModel {
    private let store: WeightsStore
    
    init(store: WeightsStore) {
        self.store = store
    }
 
    func listRecords() throws -> [WeightRecord] {
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        return try store.list(withSort: [sort]).map { WeightRecord(value: $0.value, date: $0.date!) }
    }
    
    func addRecord(record: WeightRecord) throws {
        try store.add(record: record)
    }
}

