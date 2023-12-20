
import Foundation

extension Decimal {
    func formatWeight() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        return formatter.string(for: self) ?? ""
    }
}
