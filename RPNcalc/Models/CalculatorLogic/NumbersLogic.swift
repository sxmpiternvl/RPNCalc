import Foundation

class NumbersLogic {
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
            
            if String(last) == ButtonTitle.openParenthesis.rawValue || isOperator(last) {
                state = .normal(expr + ButtonTitle.zero.rawValue + ButtonTitle.decimalSeparator.rawValue)
            } else {
                var currentNumber = ""
                for char in expr.reversed() {
                    if char.isNumber || String(char) == ButtonTitle.decimalSeparator.rawValue {
                        currentNumber.append(char)
                    } else {
                        break
                    }
                }
                
                if currentNumber.contains(ButtonTitle.decimalSeparator.rawValue) {
                    return
                }
                state = .normal(expr + ButtonTitle.decimalSeparator.rawValue)
            }
        }
    }
    
}
