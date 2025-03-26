
import Foundation

class ParenthesisLogic:ParenthesisLogicProtocol {
    private let utils = CalculatorUtils()
    
    func addOpenParenthesis(currentState state: inout ExpressionState, openParenthesisCount: inout Int) {
        switch state {
        case .undefined, .empty, .result(_):
            state = .normal(ButtonTitle.openParenthesis.rawValue)
            openParenthesisCount = 1
        case .normal(var expr):
            guard let last = expr.last, String(last) != ButtonTitle.decimalSeparator.rawValue else { return }
            if let last = expr.last, last.isNumber || String(last) == ButtonTitle.closeParenthesis.rawValue {
                expr.append(ButtonTitle.multiply.rawValue)
            }
            expr.append(ButtonTitle.openParenthesis.rawValue)
            openParenthesisCount += 1
            state = .normal(expr)
        }
    }
    
    func addCloseParenthesis(currentState state: inout ExpressionState, openParenthesisCount: inout Int) {
        guard openParenthesisCount > 0 else { return }
        switch state {
        case .undefined, .empty, .result(_):
            return
        case .normal(var expr):
            if let last = expr.last, String(last) == ButtonTitle.openParenthesis.rawValue || utils.isOperator(last) {
                return
            }
            expr.append(ButtonTitle.closeParenthesis.rawValue)
            openParenthesisCount -= 1
            state = .normal(expr)
        }
    }
}
