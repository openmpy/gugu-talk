struct MemberGetMyResponse: Codable, Identifiable {

    let memberId: Int64
    var publicImages: [MemberGetImageResponse]
    var privateImages: [MemberGetImageResponse]
    var nickname: String
    var birthYear: Int
    var bio: String?

    var id: Int64 { memberId }
}

struct MemberGetImageResponse: Codable, Identifiable {

    let imageId: Int64
    let url: String
    let key: String
    let type: String
    let sortOrder: Int

    var id: Int64 { imageId }
}
