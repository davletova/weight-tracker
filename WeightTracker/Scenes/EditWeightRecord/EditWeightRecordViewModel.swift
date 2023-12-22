import Foundation
import UIKit

protocol EditWeightRecordViewViewModelDelegate: AnyObject {
    func reloadData()
    func reloadRow(indexPathes: [IndexPath])
    func dismiss()
    func showError(message: String)
    func showAlert(alert: AlertModel)
}

protocol WeightsTableUpdater {
    func addRecord(record: WeightRecord)
}

class EditWeightRecordViewModel: WeightInputCollectionCellDelegate {
    private var store: WeightsStore
    
    weak var delegate: EditWeightRecordViewViewModelDelegate?
    var tableUpdater: WeightsTableUpdater
    
    var records: [WeightRecord] = []
    var isDatePickerOpen = false
    var date = Date()
    var weight: String = ""
    
    init(store: WeightsStore, tableUpdater: WeightsTableUpdater) {
        self.store = store
        self.tableUpdater = tableUpdater
    }
    
    func hideDatePicker() {
        if isDatePickerOpen {
            isDatePickerOpen = false
            delegate?.reloadData()
        }
    }
    
    func addRecord() {
        guard let weightDecimal = Decimal(string: weight, locale: Locale.current) else {
            delegate?.showError(message: "Неверный формат данных")
            return
        }
        
        do {
            let newRecord = WeightRecord(id: UUID(), weightValue: weightDecimal, date: date)
            try store.addRecord(record: newRecord)
            tableUpdater.addRecord(record: newRecord)
            delegate?.dismiss()
        } catch WeightsStoreError.unexpectedMultipleResult {
            delegate?.showError(message: "Запись в этот день уже существует")
            return
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось сохранить запись",
                actions: [
                    UIAlertAction(
                        title: "Закрыть",
                        style: .cancel
                    ) { _ in }
                ]
            )
            delegate?.showAlert(alert: alertModel)
            return
        }
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
