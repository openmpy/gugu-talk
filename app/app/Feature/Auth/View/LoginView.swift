import SwiftUI
import ValidatedPropertyKit

struct LoginView: View {

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @StateObject private var vm = LoginViewModel()

    @Validated(.regularExpression("^010[0-9]{8}$"))
    private var phone = String()

    @Validated(!.isEmpty)
    private var password = String()

    private var isSubmit: Bool {
        !phone.isEmpty && !password.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    TextField("휴대폰 번호를 입력해주세요", text: $phone)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .keyboardType(.phonePad)
                        .onChange(of: phone) { _, newValue in
                            if newValue.count > 11 {
                                phone = String(newValue.prefix(11))
                            } else {
                                phone = newValue
                            }
                        }

                    SecureField("비밀번호를 입력해주세요", text: $password)
                        .textContentType(.oneTimeCode)
                        .padding(.leading)
                        .padding(.trailing, 44)
                        .frame(height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.bottom)

                NavigationLink {
                    SignupView()
                } label: {
                    Text("회원가입")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        if _phone.isInvalid {
                            ToastManager.shared.show("휴대폰 번호를 다시 한번 확인해주세요.", type: .error)
                        } else if _password.isInvalid {
                            ToastManager.shared.show("비밀번호를 입력해주세요.", type: .error)
                        } else {
                            Task {
                                if await vm.login(phone: phone, password: password) {
                                    isLoggedIn = true
                                }
                            }
                        }
                    } label: {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .foregroundStyle(.white)
                            .glassEffect(
                                isSubmit
                                ? .regular.tint(.blue).interactive()
                                : .regular.tint(Color(.systemGray2)).interactive()
                            )
                    }
                    .disabled(!isSubmit)
                }
            }
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
