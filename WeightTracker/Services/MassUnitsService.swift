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
    let userDefaults = UserDefaults.standard

    func setMassUnit(unit: UnitMass) {
        userDefaults.setValue(unit.symbol, forKey: MassUnitKey)
    }
    
    func getMassUnit() throws -> UnitMass {
        guard let unit = userDefaults.string(forKey: MassUnitKey) else {
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
