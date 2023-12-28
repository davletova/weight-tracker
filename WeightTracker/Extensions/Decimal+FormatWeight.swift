
import Foundation

extension Decimal {    
    func formatWeightWithoutUnit(locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
    
    func formatWeight(in unit: UnitMass, locale: Locale) -> String {
        let measurement = Measurement(value: Double(truncating: self as NSNumber), unit: UnitMass.kilograms)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = locale
        measurementFormatter.unitStyle = .short
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.maximumFractionDigits = 1

        let poundsMeasurement = measurement.converted(to: unit)

        return measurementFormatter.string(from: poundsMeasurement)
    }
    
    func formatWeightDiff(in unit: UnitMass, locale: Locale) -> String {
        let measurement = Measurement(value: Double(truncating: self as NSNumber), unit: UnitMass.kilograms)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = locale
        measurementFormatter.unitStyle = .short
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.maximumFractionDigits = 1

        let poundsMeasurement = measurement.converted(to: unit)

        return (self > 0 ? "+" : "") + measurementFormatter.string(from: poundsMeasurement)
    }
}
