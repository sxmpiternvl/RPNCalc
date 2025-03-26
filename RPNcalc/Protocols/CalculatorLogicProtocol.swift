
protocol CalculatorLogicProtocol {
    var state: ExpressionState { get }
    var openParenthesisCount: Int { get }
    var lastInfixExpression: String { get }
    func getExpressionText() -> String
    func handleInput(_ button: ButtonTitle)
    
}
