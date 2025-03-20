
protocol NumbersLogicProtocol {
    func addDigit(_ digit: String, currentState state: inout ExpressionState)
    func addDecimalPoint(currentState state: inout ExpressionState)
}
