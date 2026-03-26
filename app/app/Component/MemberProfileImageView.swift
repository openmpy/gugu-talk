import SwiftUI
import Kingfisher

struct MemberProfileImageView: View {
    
    let images: [MemberPublicImageResponse]
    
    var body: some View {
        TabView {
            if images.isEmpty {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(100)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(.systemGray6))
                    .background(Color(.systemGray4))
            } else {
                ForEach(images.indices, id: \.self) { index in
                    NavigationLink {
                        ImageFullCoverSlideView(
                            images: images.compactMap { URL(string: $0.url) },
                            startIndex: index
                        )
                    } label: {
                        KFImage(URL(string: images[index].url))
                            .resizable()
                            .placeholder {
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color(.systemGray4))
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.black)
                            .clipped()
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .aspectRatio(4/3, contentMode: .fit)
        .clipped()
    }
}
