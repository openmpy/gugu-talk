import SwiftUI
import PhotosUI

enum ReportType: String, CaseIterable, Identifiable, Codable {

    case abuse
    case spam
    case minor
    case sexual
    case fake
    case etc

    var id: Self { self }

    var title: String {
        switch self {
        case .abuse: return "욕설 / 비방"
        case .spam: return "스팸 / 광고"
        case .minor: return "미성년자"
        case .sexual: return "음란물"
        case .fake: return "도용"
        case .etc: return "기타"
        }
    }
}

struct ReportView: View {

    let memberId: Int64

    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm = ReportViewModel()

    @State private var selectType: ReportType? = nil
    @State private var reason: String = ""
    @State private var attachedImages: [UIImage] = []
    @State private var selectedAttachItems: [PhotosPickerItem] = []

    private let maxPhotoCount = 5

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    reportReasponSelector

                    attachmentSection

                    reportReasonInput
                }
                .padding()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    Task {
                        guard let type = selectType else { return }

                        await vm.submit(
                            reportedId: memberId,
                            type: type,
                            images: attachedImages,
                            reason: reason
                        )
                    }
                } label: {
                    Text("접수하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .glassEffect(
                            selectType != nil
                            ? .regular.tint(.red).interactive()
                            : .regular.tint(Color(.systemGray2)).interactive()
                        )
                }
                .disabled(selectType == nil || vm.isLoading)
                .onChange(of: vm.isSubmitted) { _, submitted in
                    if submitted {
                        dismiss()
                    }
                }
                .padding()
            }
            .navigationTitle("신고하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Subview

    private var reportReasponSelector: some View {
        VStack(alignment: .leading) {
            ForEach(ReportType.allCases) { type in
                Button {
                    selectType = type
                } label: {
                    HStack {
                        Text(type.title)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: selectType == type ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectType == type ? .red : .gray)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(20)
                }
            }
        }
    }

    private var attachmentSection: some View {
        let remaining = maxPhotoCount - attachedImages.count

        return VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("첨부 자료")
                    .font(.headline)

                Text("\(attachedImages.count)/\(maxPhotoCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(attachedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            Button {
                                attachedImages.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white, Color.red.opacity(0.8))
                                    .padding(10)
                                    .contentShape(Rectangle())
                            }
                        }
                        .frame(width: 100, height: 100)
                    }

                    if remaining > 0 {
                        PhotosPicker(
                            selection: $selectedAttachItems,
                            maxSelectionCount: remaining,
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
                }
            }
        }
        .onChange(of: selectedAttachItems) { _, newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        let remaining = maxPhotoCount - attachedImages.count
                        if remaining > 0 {
                            attachedImages.append(image)
                        }
                    }
                }
                selectedAttachItems = []
            }
        }
    }

    private var reportReasonInput: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("추가 설명 (선택)")
                .font(.headline)

            TextEditor(text: $reason)
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .frame(height: 150)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }
}

#Preview {
    ReportView(memberId: 1)
}
