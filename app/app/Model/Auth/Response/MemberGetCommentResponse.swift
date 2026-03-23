struct MemberGetCommentResponse: Codable, Identifiable {

    let memberId: Int64
    let thumbnail: String?
    let nickname: String
    let comment: String
    let gender: String
    let age: Int
    let likes: Int64
    let distance: Double?
    let createdAt: String

    var id: Int64 { memberId }
}
