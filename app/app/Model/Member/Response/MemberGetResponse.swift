struct MemberGetResponse: Codable, Identifiable {

    let memberId: Int64
    let nickname: String
    let gender: String
    let age: Int
    var likes: Int64
    let distance: Double?
    let bio: String?
    let updatedAt: String
    var isLike: Bool
    let isPrivatePhoto: Bool
    var isOpenPrivatePhoto: Bool
    var isBlock: Bool

    var id: Int64 { memberId }
}
