import SwiftUI
import CoreLocation

struct LocationView: View {

    @StateObject private var vm = LocationViewModel()
    @StateObject private var locationManager = LocationManager()

    @State private var selectGender: String = "ALL"

    var body: some View {
        NavigationStack {
            Picker("성별", selection: $selectGender) {
                Text("전체").tag("ALL")
                Text("여자").tag("FEMALE")
                Text("남자").tag("MALE")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            VStack(spacing: 0) {
                if locationManager.isLocationEnabled {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(0..<1000) { i in
                                NavigationLink {
                                    ProfileView(memberId: 1)
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
                                                Text("닉네임")
                                                    .font(.headline.bold())
                                                    .foregroundColor(i % 2 == 0 ? .blue : .pink)

                                                Spacer()

                                                Text("방금 전")
                                                    .font(.caption)
                                                    .foregroundColor(Color(.systemGray))
                                            }

                                            Text("자기소개")
                                                .lineLimit(1)
                                                .font(.subheadline)
                                                .foregroundColor(Color(.systemGray))

                                            HStack {
                                                HStack {
                                                    Text("남자")
                                                    Text("·")
                                                    Text("20살")
                                                    Text("·")
                                                    Text("♥ 100")
                                                }
                                                .font(.footnote)
                                                .foregroundColor(Color(.systemGray))

                                                Spacer()

                                                Text("12.3km")
                                                    .font(.caption)
                                                    .foregroundColor(Color(.systemGray))
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .refreshable {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                    }
                    .onChange(of: locationManager.currentLocation) { _, newLocation in
                        guard let location = newLocation else {
                            return
                        }

                        Task {
                            await vm.updateLocation(
                                longitude: location.coordinate.longitude,
                                latitude: location.coordinate.latitude
                            )
                        }
                    }
                } else {
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
                    .task {
                        await vm.updateLocation(
                            longitude: nil,
                            latitude: nil
                        )
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

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
