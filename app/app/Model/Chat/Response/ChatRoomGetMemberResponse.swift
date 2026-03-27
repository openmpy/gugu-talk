struct ChatRoomGetMemberResponse: Codable, Identifiable {

    let memberId: Int64
    let nickname: String
    let thumbnail: String?

    var id: Int64 { memberId }
}
