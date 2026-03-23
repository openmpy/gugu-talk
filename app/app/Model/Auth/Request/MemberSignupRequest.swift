struct MemberSignupRequest: Codable {

    let uuid: String
    let verificationCode: String
    let phone: String
    let password: String
    let gender: String
}
