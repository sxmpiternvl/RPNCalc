
struct HistoryEntry: Identifiable, Codable {
    let id: String
    let infixExpression: String
    let rpnExpression: String
    let result: String
}
