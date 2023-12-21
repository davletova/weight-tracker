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
    func dismiss()
    func showValidationError()
}

protocol WeightsTableReloader {
    func updateWeightTable()
}

class EditWeightRecordViewModel: WeightInputCollectionCellDelegate {
    private var store: WeightsStore
    
    weak var delegate: EditWeightRecordViewViewModelDelegate?
    var tableReloader: WeightsTableReloader
    
    var records: [WeightRecord] = []
    var isDatePickerOpen = false
    var date = Date()
    var weight: String = ""
    
    init(store: WeightsStore, tableReloader: WeightsTableReloader) {
        self.store = store
        self.tableReloader = tableReloader
    }
    
    func hideDatePicker() {
        if isDatePickerOpen {
            isDatePickerOpen = false
            delegate?.reloadData()
        }
    }
    
    func addRecord() {
        guard let weightDecimal = Decimal(string: weight, locale: Locale.current) else {
            delegate?.showValidationError()
            return
        }
        
        do {
            try store.add(record: WeightRecord(weightValue: weightDecimal, date: date))
        } catch {
            print("save weight failed")
        }
        
        tableReloader.updateWeightTable()
        delegate?.dismiss()
    }
    
    func formatDate(date: Date) -> String {
        if date >= Calendar.current.startOfDay(for: Date()) {
            return "Сегодня"
        }
        return date.formatFullDate()
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
