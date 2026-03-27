import UIKit
import SwiftUI
import Combine

final class ScreenCaptureManager: ObservableObject {

    // MARK: - Singleton
    static let shared = ScreenCaptureManager()

    // MARK: - Published
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var didTakeScreenshot: Bool = false

    // MARK: - Private
    private var screen: UIScreen?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        setupScreenshotObserver()
        setupRecordingObserver()
    }
}

struct ScreenProvider: UIViewRepresentable {

    var onResolve: (UIScreen) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        resolve(from: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        resolve(from: uiView)
    }

    private func resolve(from view: UIView) {
        DispatchQueue.main.async {
            if let screen = view.window?.windowScene?.screen {
                onResolve(screen)
            }
        }
    }
}

// MARK: - Public API
extension ScreenCaptureManager {

    func attachScreen(_ screen: UIScreen) {
        self.screen = screen

        if #available(iOS 26.0, *) {
            isRecording = screen.isCaptured
        } else {
            isRecording = UIScreen.main.isCaptured
        }
    }
}

// MARK: - Screenshot
private extension ScreenCaptureManager {

    func setupScreenshotObserver() {
        NotificationCenter.default.publisher(
            for: UIApplication.userDidTakeScreenshotNotification
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.didTakeScreenshot = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.didTakeScreenshot = false
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Recording
private extension ScreenCaptureManager {

    func setupRecordingObserver() {
        NotificationCenter.default.publisher(
            for: UIScreen.capturedDidChangeNotification
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            guard let self else { return }

            if #available(iOS 26.0, *) {
                self.isRecording = self.screen?.isCaptured ?? false
            } else {
                self.isRecording = UIScreen.main.isCaptured
            }
        }
        .store(in: &cancellables)
    }
}
