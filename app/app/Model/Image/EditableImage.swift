import UIKit

struct EditableImage: Identifiable {
    let id: UUID
    var uiImage: UIImage
    var serverInfo: MemberGetImageResponse?

    init(uiImage: UIImage, serverInfo: MemberGetImageResponse? = nil) {
        self.id = UUID()
        self.uiImage = uiImage
        self.serverInfo = serverInfo
    }
}
