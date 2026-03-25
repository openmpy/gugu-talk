import Foundation

extension String {

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

    var customFormattedTime: String {
        guard let date = toDate else { return "" }

        let now = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return String.timeFormatter.string(from: date)
        }

        if calendar.isDateInYesterday(date) {
            return "어제"
        }

        let nowYear = calendar.component(.year, from: now)
        let targetYear = calendar.component(.year, from: date)

        if nowYear == targetYear {
            return String.monthDayFormatter.string(from: date)
        }

        return String.fullFormatter.string(from: date)
    }

    var ampmTime: String {
        guard let date = toDate else { return "" }
        return String.timeFormatter.string(from: date)
    }

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

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "a hh:mm"
        return f
    }()

    private static let monthDayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "MM월 dd일"
        return f
    }()

    private static let fullFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy. MM. dd."
        return f
    }()
}
