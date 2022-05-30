import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee\nd.MM.yy"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self).capitalized
    }
}
