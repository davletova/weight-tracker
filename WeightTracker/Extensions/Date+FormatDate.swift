import Foundation

extension Date {
    func formatDayMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLL"
//        dateFormatter.locale = Locale.init(identifier: "ru-RU")
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
    
    func formatShortFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter.string(from: self)
    }
    
    func formatFullDate() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.init(identifier: "ru-RU")
        dateFormatter.dateFormat = "dd LLL YYYY"
        return dateFormatter.string(from: self)
    }
    
    func startOfYear() -> Date {
            return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
        }
}
