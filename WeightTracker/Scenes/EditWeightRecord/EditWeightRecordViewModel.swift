import Foundation

protocol EditWeightRecordViewViewModelDelegate: AnyObject {
    func reloadData()
    func reloadRow(indexPathes: [IndexPath])
    func dismiss()
    func showError(message: String)
    func showAlert(alert: AlertModel)
}

protocol WeightsTableUpdater {
    func addRecord(record: WeightRecord)
    func updateRecord(updateRecord: WeightRecord, index: Int)
}

class EditWeightRecordViewModel: WeightInputCollectionCellDelegate {
    private var store: WeightsStore
    
    weak var delegate: EditWeightRecordViewViewModelDelegate?
    var tableUpdater: WeightsTableUpdater
    
    var isDatePickerOpen = false
    var updateWeight: WeightRecord?
    var updateWeightIndex: Int?
    var date = Date()
    var weightInput: String = ""
    
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
        guard let weightDecimal = Decimal(string: weightInput, locale: Locale.current)
        else {
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
                title: "Не удалось сохранить запись"
            )
            delegate?.showAlert(alert: alertModel)
            return
        }
    }
    
    func updateRecord() {
        guard let updateWeightIndex, let updateWeight else {
            // TODO: показать здесь алерт
            assertionFailure("updateWeightIndex is empty")
            return
        }
        
        guard let weightDecimal = Decimal(string: weightInput, locale: Locale.current) else {
            delegate?.showError(message: "Неверный формат данных")
            return
        }
        
        do {
            let newRecord = WeightRecord(id: updateWeight.id, weightValue: weightDecimal, date: date)
            try store.updateRecord(newRecord)
            tableUpdater.updateRecord(updateRecord: newRecord, index: updateWeightIndex)
            
            delegate?.dismiss()
        } catch {
            let alertModel = AlertModel(
                style: .alert,
                title: "Не удалось сохранить запись"
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
