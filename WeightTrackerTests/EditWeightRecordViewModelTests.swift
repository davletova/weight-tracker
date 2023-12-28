import Foundation
import XCTest
@testable import WeightTracker

class WeightDataMutatorMock: WeightDataMutator {
    func addRecord(record: WeightRecord) throws {
        
    }
    
    func updateRecord(updateRecord: WeightRecord) throws {
        
    }
}

class EditWeightRecordViewModelDelegateMock: EditWeightRecordViewViewModelDelegate {
    
    var errorTitle = ""
    var alertTitle = ""
    
    func reloadData() {}
    func reloadRow(indexPathes: [IndexPath]) {}
    func dismiss() {}
    func showError(message: String) { errorTitle = message }
    func showAlert(alert: AlertModel) { alertTitle = alert.title }
}

class AddRecordTests: XCTestCase {
    func testInvalidInput() {
        var viewModel = EditWeightRecordViewModel(tableUpdater: WeightDataMutatorMock(), unit: UnitMass.kilograms)
        
        var delegate = EditWeightRecordViewModelDelegateMock()
        viewModel.delegate = delegate
        viewModel.weightInput = "foo"
        
        viewModel.addRecord()
        
        XCTAssertEqual(delegate.errorTitle, EditWeightRecordErrorTitle.invalidInput.rawValue)
    }
}
