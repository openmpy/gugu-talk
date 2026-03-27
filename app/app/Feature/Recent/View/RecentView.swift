import SwiftUI
import CoreLocation

struct RecentView: View {

    @StateObject private var vm = RecentViewModel()
    @StateObject private var locationManager = LocationManager()

    @State private var selectGender: String = "ALL"
    @State private var writeCommentAlert: Bool = false
    @State private var comment: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                GenderPickerView(selectGender: $selectGender)

                commentListView
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
                        writeCommentAlert = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .alert("코멘트", isPresented: $writeCommentAlert) {
                TextField("내용 입력", text: $comment)

                Button("작성", role: .confirm) {
                    if comment.isEmpty {
                        ToastManager.shared.show("내용을 입력해주세요.", type: .error)
                        return
                    }

                    Task {
                        await vm.updateComment(comment: comment)
                    }
                }
                Button("취소", role: .cancel) { }
            }
        }
    }

    // MARK: - Subview
    
    private var commentListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(vm.comments) { it in
                    NavigationLink {
                        ProfileView(memberId: it.memberId)
                    } label: {
                        MemberRowView(
                            thumbnail: it.thumbnail,
                            nickname: it.nickname,
                            gender: it.gender,
                            updatedAt: it.updatedAt,
                            content: it.comment,
                            age: it.age,
                            likes: it.likes,
                            distance: it.distance
                        )
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
    }

    // MARK: - Function

    private func updateLocation() async {
        let location = locationManager.currentLocation

        await vm.updateLocation(
            longitude: location?.coordinate.longitude,
            latitude: location?.coordinate.latitude
        )
    }
}
