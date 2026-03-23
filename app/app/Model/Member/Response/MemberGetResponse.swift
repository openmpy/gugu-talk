struct MemberGetResponse: Codable, Identifiable {

    let memberId: Int64
    let nickname: String
    let gender: String
    let age: Int
    let likes: Int64
    let distance: Double?
    let bio: String?
    let updatedAt: String
    let isLike: Bool
    let isPrivatePhoto: Bool
    let isOpenPrivatePhoto: Bool
    let isBlock: Bool

    var id: Int64 { memberId }
}
