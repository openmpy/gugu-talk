import SwiftUI
import Kingfisher

struct MemberRowView: View {

    let thumbnail: String?
    let nickname: String
    let gender: String
    let updatedAt: String
    let content: String
    let age: Int
    let likes: Int64
    let distance: Double?
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: thumbnail ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .frame(width: 55, height: 55)
                        .foregroundColor(Color(.systemGray6))
                        .background(Color(.systemGray4))
                        .clipShape(Circle())
                }
                .font(.title)
                .frame(width: 55, height: 55)
                .foregroundColor(Color(.systemGray6))
                .background(Color(.systemGray4))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                HStack {
                    Text(nickname)
                        .font(.headline.bold())
                        .foregroundStyle(gender == "MALE" ? LinearGradient.male : LinearGradient.female)

                    Spacer()
                    
                    Text(updatedAt.relativeTime)
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                }
                
                Text(content.byCharWrapping)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                
                HStack {
                    HStack {
                        Text(gender == "MALE" ? "남자" : "여자")
                        Text("·")
                        Text("\(age)살")
                        Text("·")
                        Text("♥ \(likes)")
                    }
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
                    
                    Spacer()
                    
                    if let distance = distance {
                        Text(String(format: "%.1f", distance) + "km")
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
