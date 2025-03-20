
protocol CalculatorLogicProtocol {
    var state: ExpressionState { get }
    var openParenthesisCount: Int { get }
    var lastInfixExpression: String { get }
    var history: [HistoryEntry] { get set }
    func getExpressionText() -> String
    func handleInput(_ button: ButtonTitle)
}
