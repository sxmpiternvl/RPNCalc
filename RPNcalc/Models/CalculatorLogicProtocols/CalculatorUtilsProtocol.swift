
protocol CalculatorUtilsProtocol {
    func prepareExpression(_ input: String) -> [String]
    func formatNumber(_ value: Double, toPlaces places: Int) -> String
    func isOperator(_ char: Character) -> Bool
}
