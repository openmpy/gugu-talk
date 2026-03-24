import SwiftUI
import Kingfisher

struct ImageOrderView: View {

    @State private var images: [URL] = [
        URL(string: "https://picsum.photos/id/10/400/1000")!,
        URL(string: "https://picsum.photos/id/20/100/200")!,
        URL(string: "https://picsum.photos/id/30/400/300")!,
        URL(string: "https://picsum.photos/id/40/800/200")!,
        URL(string: "https://picsum.photos/id/50/50/50")!
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(images, id: \.self) { image in
                    VStack(spacing: 0) {
                        HStack {
                            KFImage(image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()

                            Spacer()

                            Image(systemName: "line.3.horizontal")
                                .font(.title)
                                .foregroundColor(.secondary)
                                .padding(.trailing)
                        }

                        Divider()
                            .padding(.leading, 100)
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                }
                .onMove { source, destination in
                    images.move(fromOffsets: source, toOffset: destination)
                }
            }
            .listStyle(.grouped)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                    } label: {
                        Text("제출하기")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .foregroundStyle(.white)
                            .glassEffect(.regular.tint(.blue).interactive())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ImageOrderView()
}
