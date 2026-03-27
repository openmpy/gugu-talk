struct ReportSaveRequest: Encodable {

    let type: String
    let images: [ReportImageItemRequest]
    let reason: String?
}
