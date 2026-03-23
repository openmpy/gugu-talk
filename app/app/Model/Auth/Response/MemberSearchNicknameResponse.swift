struct MemberSearchNicknameResponse: Codable, Identifiable {

    let memberId: Int64
    let thumbnail: String?
    let nickname: String
    let gender: String
    let age: Int
    let likes: Int64
    let updatedAt: String

    var id: Int64 { memberId }
}
