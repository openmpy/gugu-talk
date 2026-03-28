import SwiftUI
import Combine

@MainActor
final class SettingViewModel: ObservableObject {
    
    private let service = PointService.shared
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func earnByAttendance() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await service.earnByAttendance()
            
            ToastManager.shared.show("출석 체크가 완료되었습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
