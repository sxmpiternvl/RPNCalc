
class NumbersLogic: NumbersLogicProtocol {
    private let utils: CalculatorUtilsProtocol
    
    init(utils: CalculatorUtilsProtocol = CalculatorUtils()) {
        self.utils = utils
    }
    
    func addDigit(_ digit: String, currentState state: inout ExpressionState) {
        switch state {
        case .undefined, .empty, .result(_):
            state = .normal(digit)
        case .normal(let expression):
            state = .normal(updateCurrentOperand(expression, with: digit))
        }
    }
    
    func addDecimalPoint(currentState state: inout ExpressionState) {
        switch state {
        case .undefined, .empty, .result(_):
            state = .normal(ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
        case .normal(let expr):
            guard let last = expr.last else {
                state = .normal(ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
                return
            }
            switch last {
            case _ where last == Character(ButtonTitle.openParenthesis.rawValue)
                || utils.isOperator(last):
                state = .normal(expr + ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
            default:
                let currentNumber = extractCurrentNumber(from: expr)
                switch currentNumber.contains(ButtonTitle.decimalSeparator.rawValue) {
                case true:
                    state = .normal(expr)
                case false:
                    state = .normal(expr + ButtonTitle.decimalSeparator.rawValue)
                }
            }
        }
    }

    
    func updateCurrentOperand(_ expression: String, with digit: String) -> String {
        let currentOperand = extractCurrentNumber(from: expression)
        if currentOperand == "0" {
            return digit == ButtonTitle.zero.rawValue
                ? expression
                : String(expression.dropLast(currentOperand.count)) + digit
        } else {
            return expression + digit
        }
    }
    
    
    private func extractCurrentNumber(from expression: String) -> String {
        var currentNumber = ""
        for char in expression.reversed() {
            if char.isNumber || String(char) == ButtonTitle.decimalSeparator.rawValue {
                currentNumber.append(char)
            } else {
                break
            }
        }
        return String(currentNumber.reversed())
    }
    
    
}
