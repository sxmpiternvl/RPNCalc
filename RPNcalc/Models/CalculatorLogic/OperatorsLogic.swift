import Foundation

class OperatorsLogic: OperatorsLogicProtocol {
    private let utils = CalculatorUtils()
    
    func addOperator(_ op: String, currentState state: inout ExpressionState) {
        switch state {
        case .undefined:
            state = .normal(ButtonTitle.zero.rawValue + op)
        case .empty:
            state = (op == ButtonTitle.subtract.rawValue) ? .normal(ButtonTitle.subtract.rawValue) : .normal(ButtonTitle.zero.rawValue + op)
        case .result(let val):
            state = .normal(val + op)
        case .normal(var expr):
            guard let last = expr.last else {
                expr.append(op)
                state = .normal(expr)
                return
            }
            switch last {
            case Character(ButtonTitle.openParenthesis.rawValue):
                if op == ButtonTitle.subtract.rawValue {
                    expr.append(op)
                }
                state = .normal(expr)
            case let ch where ch.isNumber:
                expr.append(op)
                state = .normal(expr)
            case let ch where utils.isOperator(ch):
                if op == ButtonTitle.subtract.rawValue {
                    if ch != Character(ButtonTitle.subtract.rawValue) {
                        expr.append(op)
                    }
                } else {
                    expr.removeLast()
                    expr.append(op)
                }
                state = .normal(expr)
            default:
                expr.append(op)
                state = .normal(expr)
            }
        }
    }
    
}
