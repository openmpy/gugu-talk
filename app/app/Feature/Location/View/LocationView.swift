import SwiftUI
import CoreLocation

struct LocationView: View {

    @StateObject private var vm = LocationViewModel()
    @StateObject private var locationManager = LocationManager()

    @State private var selectGender: String = "ALL"

    var body: some View {
        NavigationStack {
            VStack {
                GenderPickerView(selectGender: $selectGender)

                Group {
                    if locationManager.isLocationEnabled {
                        locationListView
                    } else {
                        locationDisabledView
                    }
                }
            }
            .task {
                locationManager.requestPermission()
            }
            .navigationTitle("위치")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        MemberSearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }

    // MARK: - Subview

    private var locationListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(vm.locations) { it in
                    NavigationLink {
                        ProfileView(memberId: it.memberId)
                    } label: {
                        MemberRowView(
                            thumbnail: it.thumbnail,
                            nickname: it.nickname,
                            gender: it.gender,
                            updatedAt: it.updatedAt,
                            content: it.bio ?? "",
                            age: it.age,
                            likes: it.likes,
                            distance: it.distance
                        )
                    }
                    .onAppear {
                        if it.id == vm.locations.last?.id {
                            Task {
                                await vm.loadMoreLocations(gender: selectGender)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            Task {
                await updateLocation()
                await vm.fetchLocations(gender: selectGender)
            }
        }
        .onChange(of: selectGender) { _, newValue in
            Task {
                await vm.fetchLocations(gender: newValue)
            }
        }
        .task {
            await updateLocation()
            await vm.fetchLocations(gender: selectGender)
        }
    }

    private var locationDisabledView: some View {
        VStack {
            Spacer()

            VStack(spacing: 8) {
                Text("위치 접근 허용이 꺼져 있습니다")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("설정에서 위치 접근을 허용해주세요")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)

            Button {
                openSettings()
            } label: {
                Text("설정으로 이동")
                    .frame(height: 44)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Spacer()
        }
    }

    // MARK: - Function

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
