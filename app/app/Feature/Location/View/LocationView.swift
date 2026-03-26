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
                                
                                Text(it.bio ?? "")
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
