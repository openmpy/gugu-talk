import Foundation
import Combine
import SwiftStomp

class StompManager: NSObject, ObservableObject, SwiftStompDelegate {

    static let shared = StompManager()

    var stomp: SwiftStomp!

    func connect(accessToken: String) {
        let url = URL(string: "\(NetworkConfig.webSocketURL)")!
        let headers: [String: String] = [
            "Authorization": "Bearer \(accessToken)"
        ]

        stomp = SwiftStomp(host: url, headers: headers)
        stomp.delegate = self
        stomp.connect()
    }

    func onConnect(swiftStomp : SwiftStomp, connectType : StompConnectType) {
        switch connectType {
        case .toSocketEndpoint:
            print("WebSocket 소켓 연결됨")
        case .toStomp:
            print("STOMP 연결 완료")
        }
    }

    func onDisconnect(swiftStomp : SwiftStomp, disconnectType : StompDisconnectType) {
        print("disconnected")
    }

    func onMessageReceived(
        swiftStomp: SwiftStomp,
        message: Any?,
        messageId: String,
        destination: String,
        headers : [String : String]
    ) {

    }

    func onReceipt(swiftStomp : SwiftStomp, receiptId : String) {

    }

    func onError(
        swiftStomp : SwiftStomp,
        briefDescription : String,
        fullDescription : String?,
        receiptId : String?,
        type : StompErrorType
    ) {

    }

    func send(
        body: String,
        to destination: String,
        receiptId: String? = nil,
        headers: [String: String] = [:]
    ) {
        stomp.send(
            body: body,
            to: destination,
            receiptId: receiptId,
            headers: headers
        )
    }
}
