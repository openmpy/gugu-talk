import Foundation

struct NetworkConfig {

    private static func value(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as? String ?? ""
    }

    static var baseURL: String {
        value(for: "BASE_URL") + "/api"
    }

    static var webSocketURL: String {
        value(for: "WS_URL") + "/ws"
    }
}
