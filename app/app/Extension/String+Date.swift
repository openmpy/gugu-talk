import Foundation

extension String {

    private static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .full
        f.locale = Locale(identifier: "ko_KR")
        return f
    }()

    var toDate: Date? {
        String.isoFormatter.date(from: self)
    }

    var relativeTime: String {
        guard let date = toDate else { return "" }
        
        let seconds = Date().timeIntervalSince(date)
        if abs(seconds) < 60 {
            return "방금 전"
        }
        return String.relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
