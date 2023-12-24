import Foundation

let MassUnitKey = "massUnit"

enum MassUnitServiceError: Error {
    case convertError, valueNotFound
}

protocol MassUnitsServiceProtocol {
    func setMassUnit(unit: UnitMass)
    func getMassUnit() throws -> UnitMass 
}

class MassUnitsService: MassUnitsServiceProtocol {
    func setMassUnit(unit: UnitMass) {
        UserDefaults.standard.setValue(unit.symbol, forKey: MassUnitKey)
    }
    
    func getMassUnit() throws -> UnitMass {
        guard let unit = UserDefaults.standard.string(forKey: MassUnitKey) else {
            throw MassUnitServiceError.valueNotFound
        }
        
        switch unit {
        case "kg":
            return UnitMass.kilograms
        case "lb":
            return UnitMass.pounds
        default:
            throw MassUnitServiceError.convertError
        }
    }
}
