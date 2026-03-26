struct ImageItemRequest: Encodable {
    
    let id: Int64?
    let key: String?
    let type: String     // "PUBLIC" or "PRIVATE"
    let sortOrder: Int
}
