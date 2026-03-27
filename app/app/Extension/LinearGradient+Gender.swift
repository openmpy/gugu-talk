import SwiftUI

extension LinearGradient {

    static let male = LinearGradient(
        colors: [
            .blue,
            Color(hue: 0.58, saturation: 0.55, brightness: 0.95)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let female = LinearGradient(
        colors: [
            .pink,
            Color(hue: 0.92, saturation: 0.55, brightness: 0.95)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}
