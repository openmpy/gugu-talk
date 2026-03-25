import Foundation
import Combine
import SwiftStomp

class StompManager: NSObject, ObservableObject, SwiftStompDelegate {

    static let shared = StompManager()

    let chatMessageSubject = PassthroughSubject<(chatRoomId: Int64, data: Data), Never>()
    let chatRoomDeleteSubject = PassthroughSubject<Int64, Never>()
    let chatRoomUpdateSubject = PassthroughSubject<ChatRoomEvent, Never>()

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
        if connectType == .toStomp {
            print("connected")
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
        guard let text = message as? String,
              let data = text.data(using: .utf8) else { return }

        print("위치 \(destination) 메시지 \(text)")

        if destination.hasPrefix("/sub/chat-rooms/members") {
            if let event = try? JSONDecoder().decode(ChatRoomEvent.self, from: data) {
                switch event.type {
                case "CHAT_ROOM_DELETE":
                    chatRoomDeleteSubject.send(event.chatRoomId)
                case "CHAT_ROOM_UPDATE":
                    chatRoomUpdateSubject.send(event)
                default: break
                }
            }
        } else if destination.hasPrefix("/sub/chat-rooms") {
            let chatRoomIdText = String(destination.split(separator: "/").last ?? "")

            if let chatRoomId = Int64(chatRoomIdText) {
                chatMessageSubject.send((chatRoomId: chatRoomId, data: data))
            }
        }
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

    func subscribe(to destination: String, headers: [String: String] = [:]) {
        stomp.subscribe(to: destination, headers: headers)
        print("subscribe to \(destination)")
    }

    func unsubscribe(from destination: String, headers: [String: String] = [:]) {
        stomp.unsubscribe(from: destination, headers: headers)
        print("unsubscribe from \(destination)")
    }
}
