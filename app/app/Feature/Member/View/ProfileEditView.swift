import SwiftUI
import PhotosUI
import ValidatedPropertyKit

struct PhotoReorderSheet: View {
    let title: String
    @Binding var images: [UIImage]
    @Binding var items: [PhotosPickerItem]
    let badgeLabel: String?
    let badgeColor: Color
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("\(title) 순서 변경")
                .font(.headline)
                .padding(.vertical)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        HStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            HStack {
                                if index == 0, let label = badgeLabel {
                                    Text(label)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(badgeColor)
                                        .clipShape(Capsule())
                                }
                            }

                            Spacer()

                            HStack {
                                Button {
                                    moveUp(index: index)
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .font(.title3)
                                        .foregroundStyle(index == 0 ? Color(.systemGray4) : .blue)
                                        .frame(width: 30, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .disabled(index == 0)

                                Button {
                                    moveDown(index: index)
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .font(.title3)
                                        .foregroundStyle(index == images.count - 1 ? Color(.systemGray4) : .blue)
                                        .frame(width: 30, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .disabled(index == images.count - 1)
                            }
                        }
                    }
                }
                .padding()

                Button {
                    onDismiss()
                } label: {
                    Text("닫기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .glassEffect(.regular.tint(.blue).interactive())
                        .padding()
                }
            }
        }
    }

    private func moveUp(index: Int) {
        guard index > 0 else { return }

        images.swapAt(index, index - 1)
        if index < items.count && index - 1 < items.count {
            items.swapAt(index, index - 1)
        }
    }

    private func moveDown(index: Int) {
        guard index < images.count - 1 else { return }

        images.swapAt(index, index + 1)
        if index < items.count && index + 1 < items.count {
            items.swapAt(index, index + 1)
        }
    }
}

struct ProfileEditView: View {

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    @State private var selectedSecretItems: [PhotosPickerItem] = []
    @State private var selectedSecretImages: [UIImage] = []

    @Validated(!.isEmpty)
    private var nickname = String()

    @Validated(.regularExpression("^[0-9]{4}$"))
    private var birthYear = String()

    @State private var bio: String = ""

    // 시트 상태
    @State private var showReorderSheet = false
    @State private var reorderSheetTarget: PhotoTarget? = nil
    @State private var tappedImageIndex: Int = 0

    private let maxPhotoCount = 5

    private var isSubmit: Bool {
        !nickname.isEmpty && !birthYear.isEmpty
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
                        TextField("닉네임을 입력해주세요", text: $nickname)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                        TextField("출생연도를 입력해주세요", text: $birthYear)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .keyboardType(.numberPad)
                            .onChange(of: birthYear) { _, newValue in
                                if newValue.count > 4 {
                                    birthYear = String(newValue.prefix(4))
                                } else {
                                    birthYear = newValue
                                }
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
            .navigationTitle("프로필 편집")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: selectedItems) { _, newItems in
            Task { await loadImages(from: newItems, target: .profile) }
        }
        .onChange(of: selectedSecretItems) { _, newItems in
            Task { await loadImages(from: newItems, target: .secret) }
        }
        .sheet(item: $reorderSheetTarget) { target in
            let isProfile = target == .profile

            PhotoReorderSheet(
                title: isProfile ? "프로필 사진" : "비밀 사진",
                images: isProfile ? $selectedImages : $selectedSecretImages,
                items: isProfile ? $selectedItems : $selectedSecretItems,
                badgeLabel: isProfile ? "대표" : nil,
                badgeColor: isProfile ? .blue : .clear,
                onDismiss: {
                    reorderSheetTarget = nil
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - 프로필 사진 섹션
    private var photoSection: some View {
        photoSectionView(
            title: "프로필 사진",
            images: selectedImages,
            items: $selectedItems,
            badgeLabel: "대표",
            badgeColor: .blue,
            target: .profile,
            onDelete: { index in
                selectedImages.remove(at: index)
                if index < selectedItems.count {
                    selectedItems.remove(at: index)
                }
            }
        )
    }

    // MARK: - 비밀 사진 섹션
    private var secretPhotoSection: some View {
        photoSectionView(
            title: "비밀 사진",
            images: selectedSecretImages,
            items: $selectedSecretItems,
            badgeLabel: nil,
            badgeColor: .clear,
            target: .secret,
            onDelete: { index in
                selectedSecretImages.remove(at: index)
                if index < selectedSecretItems.count {
                    selectedSecretItems.remove(at: index)
                }
            }
        )
    }

    // MARK: - 공통 사진 섹션 뷰
    private func photoSectionView(
        title: String,
        images: [UIImage],
        items: Binding<[PhotosPickerItem]>,
        badgeLabel: String?,
        badgeColor: Color,
        target: PhotoTarget,
        onDelete: @escaping (Int) -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text("\(images.count)/\(maxPhotoCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        photoCellView(
                            image: image,
                            index: index,
                            badgeLabel: badgeLabel,
                            badgeColor: badgeColor,
                            onDelete: onDelete,
                            onTap: {
                                tappedImageIndex = index
                                reorderSheetTarget = target
                            }
                        )
                    }

                    if images.count < maxPhotoCount {
                        addPhotoButtonView(items: items)
                    }
                }
            }

            Text("영역을 클릭하여 순서를 변경할 수 있습니다")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.vertical, 2)
        }
    }

    // MARK: - 공통 사진 셀
    private func photoCellView(
        image: UIImage,
        index: Int,
        badgeLabel: String?,
        badgeColor: Color,
        onDelete: @escaping (Int) -> Void,
        onTap: @escaping () -> Void
    ) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    onTap()
                }

            Button {
                onDelete(index)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white, Color.red.opacity(0.8))
            }
            .padding(6)

            if index == 0, let label = badgeLabel {
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

    // MARK: - 공통 사진 추가 버튼
    private func addPhotoButtonView(items: Binding<[PhotosPickerItem]>) -> some View {
        PhotosPicker(
            selection: items,
            maxSelectionCount: maxPhotoCount,
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

    // MARK: - 이미지 로드
    @MainActor
    private func loadImages(from items: [PhotosPickerItem], target: PhotoTarget) async {
        var loaded: [UIImage] = []
        for item in items.prefix(maxPhotoCount) {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                loaded.append(image)
            }
        }
        switch target {
        case .profile: selectedImages = loaded
        case .secret:  selectedSecretImages = loaded
        }
    }
}

#Preview {
    ProfileEditView()
}
