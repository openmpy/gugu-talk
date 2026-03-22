import SwiftUI
import ValidatedPropertyKit

struct SignupView: View {

    @State private var showAlert: Bool = false
    @State private var goProfileSetup: Bool = false

    @Validated(.regularExpression("^010[0-9]{8}$"))
    private var phone = String()

    @Validated(.regularExpression("^[0-9]{5}$"))
    private var verifyCode = String()

    @Validated(!.isEmpty)
    private var password = String()

    @Validated(!.isEmpty)
    private var password2 = String()

    private var isSubmit: Bool {
        !phone.isEmpty && !verifyCode.isEmpty && !password.isEmpty && !password2.isEmpty
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

                            } label: {
                                Text("전송")
                                    .frame(height: 44)
                                    .frame(width: 100)
                                    .foregroundStyle(.white)
                                    .background(
                                        _phone.isInvalid ? Color(.systemGray2) : Color.blue
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .disabled(_phone.isInvalid)
                        }

                        TextField("인증 번호를 입력해주세요", text: $verifyCode)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .keyboardType(.numberPad)
                            .onChange(of: verifyCode) { _, newValue in
                                if newValue.count > 5 {
                                    verifyCode = String(newValue.prefix(5))
                                } else {
                                    verifyCode = newValue
                                }
                            }
                    }

                    HStack {
                        Button {

                        } label: {
                            Text("남자")
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(Color(.blue))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }

                        Button {

                        } label: {
                            Text("여자")
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(Color(.systemGray3))
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
                            print("휴대폰 번호를 다시 한번 확인해주세요.")
                        } else if _verifyCode.isInvalid {
                            print("인증 번호를 다시 한번 확인해주세요.")
                        } else if _password.isInvalid || _password2.isInvalid {
                            print("비밀번호를 입력해주세요.")
                        } else if _password.wrappedValue != _password2.wrappedValue {
                            print("비밀번호가 일치하지 않습니다.")
                        } else {
                            goProfileSetup = true
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
}

#Preview {
    SignupView()
}
