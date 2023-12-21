
import Foundation

extension Decimal {
    func formatWeight() -> String {
//        let m = Measurement<UnitMass>(value: 42, unit: .kilograms)
//        let mf = MeasurementFormatter()
//        MassFormatter()
//        
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(fromKilograms: Double(truncating: self as NSNumber))
    }
    
    func formatWeightDiff() -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.numberFormatter.positivePrefix = "+"
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(fromKilograms: Double(truncating: self as NSNumber))
    }
    
    func formatWeight2() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        return formatter.string(for: self) ?? ""
    }
    
    func formatWeightDiff2() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        formatter.positivePrefix = "+"
        
        return formatter.string(for: self) ?? ""
    }
}
