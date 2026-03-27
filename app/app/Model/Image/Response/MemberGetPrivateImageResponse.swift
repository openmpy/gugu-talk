struct MemberGetPrivateImageResponse: Decodable {

    let images: [MemberPrivateImageResponse]
}

struct MemberPrivateImageResponse: Decodable, Hashable {
    
    let url: String
}
