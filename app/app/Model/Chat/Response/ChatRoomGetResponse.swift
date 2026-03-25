struct ChatRoomGetResponse: Codable, Identifiable {

    let chatRoomId: Int64
    let memberId: Int64
    let thumbnail: String?
    let nickname: String
    var lastMessage: String
    var lastMessageAt: String

    var id: Int64 { chatRoomId }
}
