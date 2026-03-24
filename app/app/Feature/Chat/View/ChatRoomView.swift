import SwiftUI

struct ChatRoomView: View {

    @Namespace var namespace

    @State private var message: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<10) { i in
                        VStack {
                            HStack(alignment: .bottom, spacing: 5) {
                                Text("메시지")
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))

                                Text("오전 1:23")
                                    .font(.caption2)
                                    .foregroundColor(.gray)

                                Spacer()
                            }
                            HStack(alignment: .bottom, spacing: 5) {
                                Text("메시지")
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))

                                Text("오전 1:23")
                                    .font(.caption2)
                                    .foregroundColor(.gray)

                                Spacer()
                            }

                            HStack(alignment: .bottom, spacing: 5) {
                                Spacer()

                                Text("오전 1:23")
                                    .font(.caption2)
                                    .foregroundColor(.gray)

                                Text("메시지")
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            HStack(alignment: .bottom, spacing: 5) {
                                Spacer()

                                Text("오전 1:23")
                                    .font(.caption2)
                                    .foregroundColor(.gray)

                                Text("메시지")
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        .rotationEffect(.degrees(180))
                    }
                }
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .top) {
                GlassEffectContainer(spacing: 5) {
                    HStack(alignment: .bottom) {
                        Image(systemName: "paperclip")
                            .font(.title3)
                            .frame(width: 44, height: 44)
                            .foregroundColor(.primary)
                            .clipShape(Circle())
                            .glassEffect(.regular.tint(Color(.clear)).interactive())

                        TextField("메시지 입력", text: $message, axis: .vertical)
                            .font(.system(size: 16))
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .lineLimit(5)
                            .padding(.leading)
                            .padding(.trailing, 50)
                            .padding(.vertical, 8)
                            .frame(minHeight: 44)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Button {
                                    } label: {
                                        Image(systemName: "paperplane.fill")
                                            .foregroundColor(.white)
                                            .frame(width: 36, height: 36)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                    }
                                    .padding(.trailing, 4)
                                    .padding(.bottom, 4)
                                }, alignment: .bottom
                            )
                            .glassEffect(
                                .regular.tint(.clear).interactive(),
                                in: .rect(cornerRadius: 20)
                            )
                    }
                }
                .rotationEffect(.degrees(180))
                .padding()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .rotationEffect(.degrees(180))
            .navigationTitle("홍길동")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileView(memberId: 1)
                    } label: {
                        Image(systemName: "person.fill")
                            .font(.caption2)
                            .frame(width: 27, height: 27)
                            .foregroundColor(Color(.systemGray6))
                            .background(Color(.systemGray4))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

#Preview {
    ChatRoomView()
}
