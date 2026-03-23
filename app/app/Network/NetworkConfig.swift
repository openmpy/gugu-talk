import Foundation

struct NetworkConfig {

    static let baseIP = ProcessInfo.processInfo.environment["BASE_IP"] ?? "127.0.0.1"
    static let basePort = ProcessInfo.processInfo.environment["BASE_PORT"] ?? "8080"
    
    static var baseURL: String {"http://\(baseIP):\(basePort)/api"}
    static var webSocketURL: String { "ws://\(baseIP):\(basePort)/ws" }
}
