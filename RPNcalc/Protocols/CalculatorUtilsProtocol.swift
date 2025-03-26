
protocol CalculatorUtilsProtocol {
    func prepareExpression(_ input: String) -> [String]
    func formatNumber(_ value: Double) -> String
    func isOperator(_ char: Character) -> Bool
}
