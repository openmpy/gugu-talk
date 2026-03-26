import SwiftUI
import CoreLocation

struct RecentView: View {

    @StateObject private var vm = RecentViewModel()
    @StateObject private var locationManager = LocationManager()

    @State private var selectGender: String = "ALL"
    @State private var showAlert: Bool = false
    @State private var comment: String = ""

    var body: some View {
        NavigationStack {
            GenderPickerView(selectGender: $selectGender)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(vm.comments) { it in
                        NavigationLink {
                            ProfileView(memberId: it.memberId)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(it.nickname)
                                            .font(.headline.bold())
                                            .foregroundColor(it.gender == "MALE" ? .blue : .pink)

                                        Spacer()

                                        Text(it.updatedAt.relativeTime)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }

                                    Text(it.comment)
                                        .lineLimit(1)
                                        .font(.subheadline)
                                        .foregroundColor(Color(.systemGray))

                                    HStack {
                                        HStack {
                                            Text(it.gender == "MALE" ? "남자" : "여자")
                                            Text("·")
                                            Text("\(it.age)살")
                                            Text("·")
                                            Text("♥ \(it.likes)")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(Color(.systemGray))

                                        Spacer()

                                        if let distance = it.distance {
                                            Text(String(format: "%.1f", distance) + "km")
                                                .font(.caption)
                                                .foregroundColor(Color(.systemGray))
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                        .onAppear {
                            if it.id == vm.comments.last?.id {
                                Task {
                                    await vm.loadMoreComments(gender: selectGender)
                                }
                            }
                        }
                    }
                }
            }
            .refreshable {
                Task {
                    await updateLocation()
                    await vm.bumpComment()
                    await vm.fetchComments(gender: selectGender)
                }
            }
            .task {
                await updateLocation()
                await vm.fetchComments(gender: selectGender)
            }
            .onChange(of: selectGender) { _, newValue in
                Task {
                    await vm.fetchComments(gender: newValue)
                }
            }
            .navigationTitle("최근")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        MemberSearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("코멘트", isPresented: $showAlert) {
                TextField("내용 입력", text: $comment)

                Button("작성", role: .confirm) {
                    Task {
                        await vm.updateComment(comment: comment)
                    }
                }
                Button("취소", role: .cancel) { }
            }
        }
    }

    private func updateLocation() async {
        let location = locationManager.currentLocation

        await vm.updateLocation(
            longitude: location?.coordinate.longitude,
            latitude: location?.coordinate.latitude
        )
    }
}

#Preview {
    RecentView()
}
