
protocol ParenthesisLogicProtocol {
    func addOpenParenthesis(currentState state: inout ExpressionState, openParenthesisCount: inout Int)
    func addCloseParenthesis(currentState state: inout ExpressionState, openParenthesisCount: inout Int)
}
