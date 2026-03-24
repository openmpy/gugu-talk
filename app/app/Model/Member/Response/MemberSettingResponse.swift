struct MemberSettingResponse: Codable, Identifiable {

    let id: Int64
    let memberId: Int64
    let thumbnail: String?
    let nickname: String
    let gender: String
    let age: Int
}
