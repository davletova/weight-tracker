import Foundation

extension Date {
    func formatDayMonth(locale: Locale) -> String {
        // Месяцы март, май, июнь и июль в русском написании не имеют сокращенной формы
        // В swift сокращенные варианты этих месяцев совпадают с полными, но не имеют спряжений по падежам
        // поэтому эти 4 меясца для русской локали надо обрабатывать отдельно
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "LLL"
        monthDateFormatter.locale = locale
        let month = monthDateFormatter.string(from: self)
        
        let dateOfMonthDateFormatter = DateFormatter()
        dateOfMonthDateFormatter.dateFormat = "dd"
        dateOfMonthDateFormatter.locale = locale
        let dateOfMonth = dateOfMonthDateFormatter.string(from: self)
        
        switch month {
        case "март":
            return dateOfMonth + " марта"
        case "май":
            return dateOfMonth + " мая"
        case "июнь":
            return dateOfMonth + " июня"
        case "июль":
            return dateOfMonth + " июля"
        default:
            let defaultDateFormatter = DateFormatter()
            defaultDateFormatter.dateFormat = "dd LLL"
            defaultDateFormatter.locale = locale
            
            return defaultDateFormatter.string(from: self)
        }
    }
    
    func formatShortFullDate(locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter.string(from: self)
    }
    
    func formatFullDate(locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "dd LLL YYYY"
        return dateFormatter.string(from: self)
    }
    
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    private func customMonthName(month: String, dateOfMonth: String, withLocale locale: Locale) -> String {
        switch month {
        case "март":
            return dateOfMonth + " марта"
        case "май":
            return dateOfMonth + " мая"
        case "июнь":
            return dateOfMonth + " июня"
        case "июля":
            return dateOfMonth + " июля"
        default:
            return ""
        }
    }
}
