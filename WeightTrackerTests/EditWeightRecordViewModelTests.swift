import Foundation
import XCTest
@testable import WeightTracker

class WeightDataMutatorMock: WeightDataMutator {
    var addedRecord: WeightRecord?
    var updatedRecord: WeightRecord?
    var error: Error?
    
    func addRecord(record: WeightRecord) throws {
        if let error {
            throw error
        }
        addedRecord = record
    }
    
    func updateRecord(updateRecord: WeightRecord) throws {
        if let error {
            throw error
        }
        updatedRecord = updateRecord
    }
}

class EditWeightRecordViewModelDelegateMock: EditWeightRecordViewViewModelDelegate {
    
    var errorTitle = ""
    var alertTitle = ""
    var dismissHappened = false
    
    func reloadData() {}
    func reloadRow(indexPathes: [IndexPath]) {}
    func dismiss() { dismissHappened = true }
    func showError(message: String) { errorTitle = message }
    func showAlert(alert: AlertModel) { alertTitle = alert.title }
}

class AddRecordTests: XCTestCase {
    func testInvalidInput() {
        let viewModel = EditWeightRecordViewModel(tableUpdater: WeightDataMutatorMock(), unit: UnitMass.kilograms)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = ""
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.invalidInput.rawValue)
    }
    
    func testWeightValueInKg() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.weightValue, Decimal(34.87))
    }
    
    func testWeightValueInLb() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        viewModel.weightInput = "4,7"
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.weightValue, Decimal(2.1318824))
    }
    
    func testWeightRecordDate() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        viewModel.weightInput = "4,7"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewModel.date = dateFormatter.date(from: "27/12/2023")!
        
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.date, dateFormatter.date(from: "27/12/2023")!)
    }
    
    func testDismiss() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "4,7"
        viewModel.addRecord()
        
        XCTAssertTrue(delegate.dismissHappened)
    }
    
    func testErrorUnexpectedMultipleResult() {
        let weightDataMutator = WeightDataMutatorMock()
        weightDataMutator.error = WeightsStoreError.unexpectedMultipleResult
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.duplicateData.rawValue)
    }
    
    func testInternalError() {
        let weightDataMutator = WeightDataMutatorMock()
        weightDataMutator.error = WeightsStoreError.internalError
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.alertTitle, EditWeightRecordErrorTitle.internalError.rawValue)
    }
}

class UpdaterecordTests: XCTestCase {
    func testErrorInvalidInput() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let id = UUID()
        viewModel.updateWeight = WeightRecord(id: id, weightValue: 34.87, date: dateFormatter.date(from: "27/12/2023")!)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "foo"
        
        viewModel.updateRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.invalidInput.rawValue)
    }
    
    func testWeightValueInKg() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let id = UUID()
        viewModel.updateWeight = WeightRecord(id: id, weightValue: 34.87, date: dateFormatter.date(from: "27/12/2023")!)
        viewModel.weightInput = "35,6"
        
        viewModel.updateRecord()
        
        XCTAssertEqual(weightDataMutator.updatedRecord?.weightValue, Decimal(35.6))
    }
    
    func testWeightValueInLb() {
        let weightDataMutator = WeightDataMutatorMock()
        let viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        let delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let id = UUID()
        viewModel.updateWeight = WeightRecord(id: id, weightValue: 34.87, date: dateFormatter.date(from: "27/12/2023")!)
        viewModel.weightInput = "4,7"
        
        viewModel.updateRecord()
        
        XCTAssertEqual(weightDataMutator.updatedRecord?.weightValue, Decimal(2.1318824))
    }
}
