import SwiftUI
import PhotosUI

struct PhotoReorderSheet: View {

    let title: String
    @Binding var images: [EditableImage]
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
                    ForEach(Array(images.enumerated()), id: \.element.id) { index, editableImage in
                        HStack {
                            Image(uiImage: editableImage.uiImage)
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
    }

    private func moveDown(index: Int) {
        guard index < images.count - 1 else { return }
        images.swapAt(index, index + 1)
    }
}
