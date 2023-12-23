
import Foundation

extension Decimal {
    func formatWeight() -> String {
        let formatter = MassFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1        
        return formatter.string(fromValue: Double(truncating: self as NSNumber), unit: .kilogram)
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
        formatter.numberFormatter.maximumFractionDigits = 1
        return (self > 0 ? "+" : "") + formatter.string(fromValue: Double(truncating: self as NSNumber), unit: .kilogram)
    }
}
