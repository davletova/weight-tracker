import Foundation
import XCTest
@testable import WeightTracker

class WeightDataMutatorMock: WeightDataMutator {
    var addedRecord: WeightRecord?
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
        var viewModel = EditWeightRecordViewModel(tableUpdater: WeightDataMutatorMock(), unit: UnitMass.kilograms)
        
        var delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = ""
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.invalidInput.rawValue)
    }
    
    func testWeightValueInKg() {
        var weightDataMutator = WeightDataMutatorMock()
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.weightValue, Decimal(34.87))
    }
    
    func testWeightValueInLb() {
        var weightDataMutator = WeightDataMutatorMock()
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        viewModel.weightInput = "4,7"
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.weightValue, Decimal(2.1318824))
    }
    
    func testWeightRecordDate() {
        var weightDataMutator = WeightDataMutatorMock()
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        viewModel.weightInput = "4,7"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewModel.date = dateFormatter.date(from: "27/12/2023")!
        
        viewModel.addRecord()
        
        XCTAssertEqual(weightDataMutator.addedRecord?.date, dateFormatter.date(from: "27/12/2023")!)
    }
    
    func testDismiss() {
        var weightDataMutator = WeightDataMutatorMock()
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.pounds)
        
        var delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "4,7"
        viewModel.addRecord()
        
        XCTAssertTrue(delegate.dismissHappened)
    }
    
    func testErrorUnexpectedMultipleResult() {
        var weightDataMutator = WeightDataMutatorMock()
        weightDataMutator.error = WeightsStoreError.unexpectedMultipleResult
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        var delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.duplicateData.rawValue)
    }
    
    func testInternalError() {
        var weightDataMutator = WeightDataMutatorMock()
        weightDataMutator.error = WeightsStoreError.internalError
        var viewModel = EditWeightRecordViewModel(tableUpdater: weightDataMutator, unit: UnitMass.kilograms)
        
        var delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "34,87"
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.alertTitle, EditWeightRecordErrorTitle.internalError.rawValue)
    }
}
