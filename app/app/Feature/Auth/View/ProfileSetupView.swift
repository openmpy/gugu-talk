import SwiftUI
import ValidatedPropertyKit

struct ProfileSetupView: View {

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @StateObject private var vm = ProfileSetupViewModel()

    @Validated(!.isEmpty)
    private var nickname = String()

    @Validated(.regularExpression("^[0-9]{4}$"))
    private var birthYear = String()

    @State private var bio: String = ""

    private var isSubmit: Bool {
        !nickname.isEmpty && !birthYear.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    TextField("닉네임을 입력해주세요", text: $nickname)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    TextField("출생연도를 입력해주세요", text: $birthYear)
                        .padding(.horizontal)
                        .frame(height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .keyboardType(.numberPad)
                        .onChange(of: birthYear) { _, newValue in
                            if newValue.count > 4 {
                                birthYear = String(newValue.prefix(4))
                            } else {
                                birthYear = newValue
                            }
                        }

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $bio)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 8)
                            .frame(height: 150)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .scrollContentBackground(.hidden)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        if bio.isEmpty {
                            Text("자기소개를 입력해주세요")
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 18)
                                .allowsHitTesting(false)
                        }
                    }
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    if _nickname.isInvalid {
                        ToastManager.shared.show("닉네임을 입력해주세요.", type: .error)
                    } else if _birthYear.isInvalid {
                        ToastManager.shared.show("출생연도를 다시 한번 확인해주세요.", type: .error)
                    } else {
                        Task {
                            if await vm.setup(
                                nickname: nickname,
                                birthYear: Int(birthYear) ?? 2000,
                                bio: bio
                            ) {
                                isLoggedIn = true
                            }
                        }
                    }
                } label: {
                    Text("들어가기")
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
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .interactiveDismissDisabled(true)
            .padding()
        }
    }
}

#Preview {
    ProfileSetupView()
}
