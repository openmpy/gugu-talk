import SwiftUI
import ValidatedPropertyKit

struct SignupView: View {

    @StateObject private var vm = SignupViewModel()

    @State private var showAlert: Bool = false
    @State private var goProfileSetup: Bool = false
    @State private var selectedGender: String = "male"
    @State private var sendVerificationCode = false
    @State private var timeRemaining = 300
    @State private var timer: Timer?

    @Validated(.regularExpression("^010[0-9]{8}$"))
    private var phone = String()

    @Validated(.regularExpression("^[0-9]{5}$"))
    private var verificationCode = String()

    @Validated(!.isEmpty)
    private var password = String()

    @Validated(!.isEmpty)
    private var password2 = String()

    private var isSubmit: Bool {
        !phone.isEmpty && !verificationCode.isEmpty && !password.isEmpty && !password2.isEmpty && sendVerificationCode
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    VStack {
                        HStack {
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

                            Button {
                                Task {
                                    if await vm.sendVerificationCode(phone: phone) {
                                        startTimer()
                                    }
                                }
                            } label: {
                                Text(sendVerificationCode ? "\(timeRemaining)" : "전송")
                                    .frame(height: 44)
                                    .frame(width: 100)
                                    .foregroundStyle(.white)
                                    .background(
                                        _phone.isInvalid || sendVerificationCode ? Color(.systemGray2) : Color.blue
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .disabled(_phone.isInvalid || sendVerificationCode)
                        }

                        TextField("인증 번호를 입력해주세요", text: $verificationCode)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .keyboardType(.numberPad)
                            .onChange(of: verificationCode) { _, newValue in
                                if newValue.count > 5 {
                                    verificationCode = String(newValue.prefix(5))
                                } else {
                                    verificationCode = newValue
                                }
                            }
                    }

                    HStack {
                        Button {
                            selectedGender = "male"
                        } label: {
                            Text("남자")
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(selectedGender == "male" ? Color(.blue) : Color(.systemGray3))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        Button {
                            selectedGender = "female"
                        } label: {
                            Text("여자")
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(selectedGender == "female" ? Color(.blue) : Color(.systemGray3))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }

                    VStack {
                        SecureField("비밀번호를 입력해주세요", text: $password)
                            .textContentType(.oneTimeCode)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        SecureField("비밀번호를 다시 입력해주세요", text: $password2)
                            .textContentType(.oneTimeCode)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onAppear {
                showAlert = true
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert("안내", isPresented: $showAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text("미성년자는 이용할 수 없습니다.\n적발 시 서비스 이용이 제한됩니다.")
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        if _phone.isInvalid {
                            ToastManager.shared.show("휴대폰 번호를 다시 한번 확인해주세요.", type: .error)
                        } else if _verificationCode.isInvalid {
                            ToastManager.shared.show("인증 번호를 다시 한번 확인해주세요.", type: .error)
                        } else if _password.isInvalid || _password2.isInvalid {
                            ToastManager.shared.show("비밀번호를 입력해주세요.", type: .error)
                        } else if _password.wrappedValue != _password2.wrappedValue {
                            ToastManager.shared.show("비밀번호가 일치하지 않습니다.", type: .error)
                        } else {
                            Task {
                                if await vm.signup(
                                    verificationCode: verificationCode,
                                    phone: phone,
                                    password: password,
                                    gender: selectedGender
                                ) {
                                    goProfileSetup = true
                                }
                            }
                        }
                    } label: {
                        Text("회원가입")
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
            .navigationDestination(isPresented: $goProfileSetup) {
                ProfileSetupView()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }

    func startTimer() {
        sendVerificationCode = true
        timeRemaining = 300
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                sendVerificationCode = false
                timer?.invalidate()
            }
        }
    }
}

#Preview {
    SignupView()
}
