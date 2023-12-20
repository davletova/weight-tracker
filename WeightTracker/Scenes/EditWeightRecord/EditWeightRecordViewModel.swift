//
//  EditWeightRecordViewModel.swift
//  WeightTracker
//
//  Created by Алия Давлетова on 20.12.2023.
//

import Foundation

protocol EditWeightRecordViewViewModelDelegate: AnyObject {
    func reloadData()
    func reloadRow(indexPathes: [IndexPath])
}

class EditWeightRecordViewModel: WeightInputCollectionCellDelegate {
    private var store: WeightsStore
    
    weak var delegate: EditWeightRecordViewViewModelDelegate?
    
    var records: [WeightRecord] = []
    var isDatePickerOpen = false
    var date = Date()
    var weight: String = ""
    
    init(store: WeightsStore) {
        self.store = store
    }
    

    
    func hideDatePicker() {
        if isDatePickerOpen {
            isDatePickerOpen = false
            delegate?.reloadData()
        }
    }
    
    func addRecord() {
        do {
            try store.add(record: WeightRecord(value: Double(weight)!, date: date))
        } catch {
            print("save weight failed")
        }
        print("save weight succes")
    }
}

extension EditWeightRecordViewModel: DateHeaderCollectionCellDelegate {
    func showDatePicker() {
        isDatePickerOpen = true
        delegate?.reloadData()
    }
}

extension EditWeightRecordViewModel: DatePickerCollectionCellDelegate {
    func setDate(date: Date) {
        self.date = date
        delegate?.reloadRow(indexPathes: [IndexPath(row: 0, section: 0)])
    }
}
