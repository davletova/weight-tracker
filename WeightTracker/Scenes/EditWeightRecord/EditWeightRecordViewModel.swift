import Foundation

protocol EditWeightRecordViewViewModelDelegate: AnyObject {
    func reloadData()
    func reloadRow(indexPathes: [IndexPath])
    func dismiss()
    func showError(message: String)
    func showAlert(alert: AlertModel)
}

protocol WeightDataMutator {
    func addRecord(record: WeightRecord) throws
    func updateRecord(updateRecord: WeightRecord) throws
}

class EditWeightRecordViewModel: WeightInputCollectionCellDelegate {
    weak var delegate: EditWeightRecordViewViewModelDelegate?
    var dataMutator: WeightDataMutator
    
    var unit: UnitMass
    var isDatePickerOpen = false
    var updateWeight: WeightRecord?
    var updateWeightIndex: Int?
    var date = Date()
    var weightInput: String = ""
    
    init(tableUpdater: WeightDataMutator, unit: UnitMass) {
        self.dataMutator = tableUpdater
        self.unit = unit
    }
    
    func hideDatePicker() {
        if isDatePickerOpen {
            isDatePickerOpen = false
            delegate?.reloadData()
        }
    }
    
    func addRecord() {
        guard
            let weightDecimal = Decimal(string: weightInput, locale: Locale.current),
            weightDecimal > 0
        else {
            delegate?.showError(message: "Неверный формат данных")
            return
        }
        
        do {
            let mass = Measurement(value: Double(truncating: weightDecimal as NSNumber), unit: unit)
            let massKg = mass.converted(to: .kilograms)
            try dataMutator.addRecord(record: WeightRecord(id: UUID(), weightValue: Decimal(massKg.value), date: date))
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
        guard var updateWeight else {
            assertionFailure("updateWeightIndex is empty")
            return
        }
        
        guard let weightDecimal = Decimal(string: weightInput, locale: Locale.current) else {
            delegate?.showError(message: "Неверный формат данных")
            return
        }
        
        do {
            let mass = Measurement(value: Double(truncating: weightDecimal as NSNumber), unit: unit)
            let massKg = mass.converted(to: .kilograms)
            updateWeight.weightValue = Decimal(massKg.value)
            updateWeight.date = date
            
            try dataMutator.updateRecord(updateRecord: updateWeight)
            
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
