import Foundation

class OperatorsLogic {
    func addOperator(_ op: String, currentState state: inout ExpressionState) {
        switch state {
        case .undefined:
            state = .normal(ButtonTitle.zero.rawValue + op)
        case .empty:
            state = (op == ButtonTitle.subtract.rawValue) ? .normal(ButtonTitle.subtract.rawValue) : .normal(ButtonTitle.zero.rawValue + op)
        case .result(let val):
            state = .normal(val + op)
        case .normal(var expr):
            if let last = expr.last {
                if String(last) == ButtonTitle.openParenthesis.rawValue {
                    if op == ButtonTitle.subtract.rawValue {
                        expr.append(op)
                    }
                    state = .normal(expr)
                } else if last.isNumber || String(last) == ButtonTitle.closeParenthesis.rawValue {
                    expr.append(op)
                    state = .normal(expr)
                } else if isOperator(last) && op != ButtonTitle.subtract.rawValue {
                    expr.removeLast()
                    expr.append(op)
                    state = .normal(expr)
                } else {
                    expr.append(op)
                    state = .normal(expr)
                }
            } else {
                expr.append(op)
                state = .normal(expr)
            }
        }
    }
    
}
