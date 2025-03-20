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
            if digit == ButtonTitle.zero.rawValue && expression == ButtonTitle.zero.rawValue {
                state = .normal(digit)
            } else {
                state = .normal(expression + digit)
            }
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
            case let ch where ch == Character(ButtonTitle.openParenthesis.rawValue)
                             || CalculatorUtils().isOperator(ch):
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

    private func shouldPrependZeroForDecimal(after char: Character) -> Bool {
        return String(char) == ButtonTitle.openParenthesis.rawValue || CalculatorUtils().isOperator(char)
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
