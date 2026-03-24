import SwiftUI
import Combine

@MainActor
final class LocationViewModel: ObservableObject {

    private let queryService = MemberQueryService.shared
    private let commandService = MemberCommandService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var locations: [MemberGetLocationResponse] = []

    private var cursorId: Int64?

    func fetchLocations(gender: String) async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await queryService.getLocations(
                gender: gender,
                cursorId: nil,
                limit: 20
            )

            locations = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreLocations(gender: String) async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await queryService.getLocations(
                gender: gender,
                cursorId: cursorId,
                limit: 20
            )

            locations.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func updateLocation(
        longitude: Double?,
        latitude: Double?
    ) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await commandService.updateLocation(
                longitude: longitude,
                latitude: latitude
            )
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
