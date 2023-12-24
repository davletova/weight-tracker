
import Foundation

extension Decimal {
//    func formatWeight() -> String {
//        let formatter = MassFormatter()
//        formatter.numberFormatter.maximumFractionDigits = 1
//        return formatter.string(fromValue: Double(truncating: self as NSNumber), unit: .kilogram)
//    }
    
    func formatWeightWithoutUnit() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
    
    func formatWeightDiff() -> String {
        let formatter = MassFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        return (self > 0 ? "+" : "") + formatter.string(fromValue: Double(truncating: self as NSNumber), unit: .kilogram)
    }
    
    func formatWeight(in unit: UnitMass) -> String {
        let measurement = Measurement(value: Double(truncating: self as NSNumber), unit: UnitMass.kilograms)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.maximumFractionDigits = 1 // Опционально, устанавливает количество знаков после запятой

        let poundsMeasurement = measurement.converted(to: unit)

        return measurementFormatter.string(from: poundsMeasurement)
    }
    
    func formatWeightDiff(in unit: UnitMass) -> String {
        let measurement = Measurement(value: Double(truncating: self as NSNumber), unit: UnitMass.kilograms)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.maximumFractionDigits = 1 // Опционально, устанавливает количество знаков после запятой

        let poundsMeasurement = measurement.converted(to: unit)

        return (self > 0 ? "+" : "") + measurementFormatter.string(from: poundsMeasurement)
    }
}
