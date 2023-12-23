
import Foundation

extension Decimal {
    func formatWeight() -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(fromKilograms: Double(truncating: self as NSNumber))
    }
    
    func formatWeight(in unit: UnitMass) -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(fromKilograms: Double(truncating: self as NSNumber))
    }
    
    func formatWeightWithoutUnit() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
    
    func formatWeightDiff() -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.numberFormatter.positivePrefix = "+"
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(fromKilograms: Double(truncating: self as NSNumber))
    }
}
