import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileEditView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm = ProfileEditViewModel()

    @State private var publicImages: [EditableImage] = []
    @State private var privateImages: [EditableImage] = []

    @State private var selectedPublicItems: [PhotosPickerItem] = []
    @State private var selectedPrivateItems: [PhotosPickerItem] = []

    @State private var birthYearText: String = ""
    @State private var bio: String = ""

    @State private var reorderSheetTarget: PhotoTarget? = nil

    private let maxPhotoCount = 5

    private var isSubmit: Bool {
        !vm.member.nickname.isEmpty && birthYearText.count == 4
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    VStack(spacing: 10) {
                        photoSection
                        secretPhotoSection
                    }

                    VStack {
                        TextField("닉네임을 입력해주세요", text: $vm.member.nickname)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        TextField("출생연도를 입력해주세요", text: $birthYearText)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .keyboardType(.numberPad)
                            .onChange(of: birthYearText) { _, newValue in
                                let trimmed = newValue.count > 4 ? String(newValue.prefix(4)) : newValue
                                birthYearText = trimmed
                                vm.member.birthYear = Int(trimmed) ?? 0
                            }

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $bio)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 8)
                                .frame(height: 150)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .scrollContentBackground(.hidden)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .onChange(of: bio) { _, newValue in
                                    vm.member.bio = newValue.isEmpty ? nil : newValue
                                }

                            if bio.isEmpty {
                                Text("자기소개를 입력해주세요")
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    Task {
                        let originalPublicIds = vm.member.publicImages.map(\.imageId)
                        let originalPrivateIds = vm.member.privateImages.map(\.imageId)

                        let success = await vm.uploadImages(
                            publicImages: publicImages,
                            privateImages: privateImages,
                            originalPublicIds: originalPublicIds,
                            originalPrivateIds: originalPrivateIds
                        )
                        if success {
                            ToastManager.shared.show("프로필이 편집되었습니다.")
                            dismiss()
                        }
                    }
                } label: {
                    Text("편집하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .glassEffect(
                            isSubmit
                            ? .regular.tint(.blue).interactive()
                            : .regular.tint(Color(.systemGray2)).interactive()
                        )
                }
                .disabled(!isSubmit)
                .padding()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .task {
                await vm.getMy()
                birthYearText = vm.member.birthYear == 0 ? "" : String(vm.member.birthYear)
                bio = vm.member.bio ?? ""
                await loadServerImages()
            }
            .navigationTitle("프로필 편집")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: selectedPublicItems) { _, newItems in
            Task { await appendPickedImages(from: newItems, target: .profile) }
        }
        .onChange(of: selectedPrivateItems) { _, newItems in
            Task { await appendPickedImages(from: newItems, target: .secret) }
        }
        .sheet(item: $reorderSheetTarget) { target in
            let isProfile = target == .profile
            PhotoReorderSheet(
                title: isProfile ? "프로필 사진" : "비밀 사진",
                images: isProfile ? $publicImages : $privateImages,
                badgeLabel: isProfile ? "대표" : nil,
                badgeColor: isProfile ? .blue : .clear,
                onDismiss: { reorderSheetTarget = nil }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - 프로필 사진 섹션
    private var photoSection: some View {
        photoSectionView(
            title: "프로필 사진",
            images: $publicImages,
            items: $selectedPublicItems,
            badgeLabel: "대표",
            badgeColor: .blue,
            target: .profile
        )
    }

    // MARK: - 비밀 사진 섹션
    private var secretPhotoSection: some View {
        photoSectionView(
            title: "비밀 사진",
            images: $privateImages,
            items: $selectedPrivateItems,
            badgeLabel: nil,
            badgeColor: .clear,
            target: .secret
        )
    }

    // MARK: - 공통 사진 섹션 뷰
    private func photoSectionView(
        title: String,
        images: Binding<[EditableImage]>,
        items: Binding<[PhotosPickerItem]>,
        badgeLabel: String?,
        badgeColor: Color,
        target: PhotoTarget
    ) -> some View {
        let remaining = maxPhotoCount - images.wrappedValue.count

        return VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text("\(images.wrappedValue.count)/\(maxPhotoCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(images.wrappedValue.enumerated()), id: \.element.id) { index, editableImage in
                        photoCellView(
                            image: editableImage.uiImage,
                            showBadge: index == 0,
                            badgeLabel: badgeLabel,
                            badgeColor: badgeColor,
                            onDelete: {
                                images.wrappedValue.remove(at: index)
                            },
                            onTap: {
                                reorderSheetTarget = target
                            }
                        )
                    }

                    if remaining > 0 {
                        addPhotoButtonView(items: items, maxCount: remaining)
                    }
                }
            }

            Text("영역을 클릭하여 순서를 변경할 수 있습니다")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.vertical, 2)
        }
    }

    // MARK: - 통합 이미지 셀
    private func photoCellView(
        image: UIImage,
        showBadge: Bool,
        badgeLabel: String?,
        badgeColor: Color,
        onDelete: @escaping () -> Void,
        onTap: @escaping () -> Void
    ) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture { onTap() }

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white, Color.red.opacity(0.8))
            }
            .padding(6)

            if showBadge, let label = badgeLabel {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(badgeColor)
                    .clipShape(Capsule())
                    .padding(6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
        .frame(width: 100, height: 100)
    }

    // MARK: - 사진 추가 버튼
    private func addPhotoButtonView(items: Binding<[PhotosPickerItem]>, maxCount: Int) -> some View {
        PhotosPicker(
            selection: items,
            maxSelectionCount: maxCount,
            matching: .images
        ) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Color(.systemGray2))
                .frame(width: 100, height: 100)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                        .foregroundStyle(Color(.systemGray3))
                )
        }
    }

    // MARK: - 이미지 로드 타겟
    private enum PhotoTarget: Identifiable {
        case profile, secret
        var id: Self { self }
    }

    // MARK: - 서버 이미지 다운로드 (Kingfisher)
    @MainActor
    private func loadServerImages() async {
        publicImages = await downloadImages(from: vm.member.publicImages)
        privateImages = await downloadImages(from: vm.member.privateImages)
    }

    private func downloadImages(from responses: [MemberGetImageResponse]) async -> [EditableImage] {
        await withTaskGroup(of: (Int, EditableImage?).self) { group in
            for (index, response) in responses.enumerated() {
                group.addTask {
                    guard let url = URL(string: response.url) else { return (index, nil) }
                    return await withCheckedContinuation { continuation in
                        KingfisherManager.shared.retrieveImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                continuation.resume(returning: (index, EditableImage(uiImage: value.image, serverInfo: response)))
                            case .failure:
                                continuation.resume(returning: (index, nil))
                            }
                        }
                    }
                }
            }

            var results: [(Int, EditableImage)] = []
            for await (index, editableImage) in group {
                if let editableImage {
                    results.append((index, editableImage))
                }
            }
            return results.sorted { $0.0 < $1.0 }.map(\.1)
        }
    }

    // MARK: - 새 이미지 추가 (PhotosPicker)
    @MainActor
    private func appendPickedImages(from items: [PhotosPickerItem], target: PhotoTarget) async {
        var loaded: [EditableImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                loaded.append(EditableImage(uiImage: image))
            }
        }
        switch target {
        case .profile:
            let remaining = maxPhotoCount - publicImages.count
            publicImages.append(contentsOf: loaded.prefix(remaining))
            selectedPublicItems = []
        case .secret:
            let remaining = maxPhotoCount - privateImages.count
            privateImages.append(contentsOf: loaded.prefix(remaining))
            selectedPrivateItems = []
        }
    }
}

#Preview {
    ProfileEditView()
}
