// [START load_ad]
import Combine
import GoogleMobileAds

@MainActor
final class InterstitialViewModel: NSObject, ObservableObject, FullScreenContentDelegate {

    private var interstitialAd: InterstitialAd?
    private let service = PointService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func loadAd() async {
        isLoading = true
        defer { isLoading = false }

        do {
            interstitialAd = try await InterstitialAd.load(
                with: "ca-app-pub-3940256099942544/4411468910", request: Request())
            // [START set_the_delegate]
            interstitialAd?.fullScreenContentDelegate = self
            // [END set_the_delegate]
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    // [END load_ad]

    // [START show_ad]
    func showAd() {
        guard let interstitialAd = interstitialAd else {
            ToastManager.shared.show("광고를 준비중입니다. 잠시 후에 이용해주세요.", type: .error)
            return print("Ad wasn't ready.")
        }

        interstitialAd.present(from: nil)
    }
    // [END show_ad]

    // MARK: - GADFullScreenContentDelegate methods

    // [START ad_events]
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("\(#function) called")
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
        // Clear the interstitial ad.
        interstitialAd = nil

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                try await service.earnByAdReward()

                ToastManager.shared.show("광고 보상으로 포인트가 지급되었습니다.")
            } catch {
                errorMessage = error.localizedDescription
                ToastManager.shared.show(errorMessage ?? "", type: .error)
            }
        }
    }
    // [END ad_events]
}
