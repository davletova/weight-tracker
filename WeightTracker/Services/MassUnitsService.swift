import Foundation

let MassUnitKey = "massUnit"

enum MassUnitServiceError: Error {
    case convertError, valueNotFound
}

class MassUnitsService {
    func setMassUnit(unit: UnitMass) {
        UserDefaults.setValue(unit, forKey: MassUnitKey)
    }
    
    func getMassUnit() throws -> UnitMass {
        guard let unit = UserDefaults.standard.value(forKey: MassUnitKey) else {
            throw MassUnitServiceError.valueNotFound
        }
        
        if let massUnit = unit as? UnitMass {
            return massUnit
        }
        
        throw MassUnitServiceError.convertError
    }
}
