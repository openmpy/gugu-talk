import Alamofire

final class AuthService {

    static let shared = AuthService()

    let session = Session(interceptor: AuthInterceptor())

    func sendVerificationCode(
        phone: String
    ) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/send-verification-code?phone=\(phone)"

        return try await AF.request(
            url,
            method: .post
        )
        .validateWithErrorHandling()
    }

    func signup(
        uuid: String,
        verificationCode: String,
        phone: String,
        password: String,
        gender: String
    ) async throws -> MemberSignupResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/signup"
        let request = MemberSignupRequest(
            uuid: uuid,
            verificationCode: verificationCode,
            phone: phone,
            password: password,
            gender: gender
        )

        return try await AF.request(
            url,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .decodingWithErrorHandling(MemberSignupResponse.self)
    }
}
