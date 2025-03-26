
import Foundation

class OperatorsLogic: OperatorsLogicProtocol {
    private let utils: CalculatorUtilsProtocol
    
    init(utils: CalculatorUtilsProtocol = CalculatorUtils()) {
        self.utils = utils
    }
    
    func addOperator(_ op: String, currentState state: inout ExpressionState) {
        switch state {
        case .undefined:
            state = .normal(ButtonTitle.zero.rawValue + op)
        case .empty:
            state = (op == ButtonTitle.subtract.rawValue) ? .normal(ButtonTitle.subtract.rawValue) : .normal(ButtonTitle.zero.rawValue + op)
        case .result(let val):
            state = .normal(val + op)
        case .normal(var expr):
            guard let last = expr.last else { return }
            switch last {
            case Character(ButtonTitle.openParenthesis.rawValue):
                if op == ButtonTitle.subtract.rawValue {
                    expr.append(op)
                }
                state = .normal(expr)
            case _ where last.isNumber:
                expr.append(op)
                state = .normal(expr)
            case _ where utils.isOperator(last):
                if utils.isOperator(last) {
                    expr.removeLast()
                }
                expr.append(op)
                state = .normal(expr)
            case _ where last == Character(ButtonTitle.decimalSeparator.rawValue):
                return
            default:
                expr.append(op)
                state = .normal(expr)
            }
        }
    }
    
}
