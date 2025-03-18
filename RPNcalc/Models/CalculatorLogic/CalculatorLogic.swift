import Foundation

enum ExpressionState {
    case empty
    case normal(String)
    case undefined
    case result(String)
}

class CalculatorLogic {
    private(set) var state: ExpressionState = .empty
    var openParenthesisCount: Int = 0
    
    private let numbersLogic = NumbersLogic()
    private let operatorsLogic = OperatorsLogic()
    private let parenthesisLogic = ParenthesisLogic()
    
    func getExpressionText() -> String {
        switch state {
        case .empty:
            return ButtonTitle.zero.rawValue
        case .normal(let expression):
            return expression
        case .undefined:
            return "Не определено"
        case .result(let result):
            return result
        }
    }
    
    func handleInput(_ button: ButtonTitle) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            numbersLogic.addDigit(button.rawValue, currentState: &state)
        case .decimalSeparator:
            numbersLogic.addDecimalPoint(currentState: &state)
        case .add:
            operatorsLogic.addOperator(ButtonTitle.add.rawValue, currentState: &state)
        case .subtract:
            operatorsLogic.addOperator(ButtonTitle.subtract.rawValue, currentState: &state)
        case .multiply:
            operatorsLogic.addOperator(ButtonTitle.multiply.rawValue, currentState: &state)
        case .divide:
            operatorsLogic.addOperator(ButtonTitle.divide.rawValue, currentState: &state)
        case .power:
            operatorsLogic.addOperator(ButtonTitle.power.rawValue, currentState: &state)
        case .openParenthesis:
            parenthesisLogic.addOpenParenthesis(currentState: &state, openParenthesisCount: &openParenthesisCount)
        case .closeParenthesis:
            parenthesisLogic.addCloseParenthesis(currentState: &state, openParenthesisCount: &openParenthesisCount)
        case .equals:
            evaluateExpression()
        case .allClear, .backspace:
            clear()
        }
    }
        
    private func clear() {
        switch state {
        case .undefined, .empty, .result(_):
            state = .empty
            openParenthesisCount = 0
        case .normal(var expr):
            if let last = expr.last, String(last) == ButtonTitle.openParenthesis.rawValue {
                openParenthesisCount -= 1
            }
            expr.removeLast()
            state = expr.isEmpty ? .empty : .normal(expr)
        }
    }
    
    private func evaluateExpression() {
        guard case .normal(let expr) = state else { return }
        guard expr.filter({ $0.isNumber }).count >= 2 else { return }
        
        var expressionToEvaluate = expr
        
        if let last = expressionToEvaluate.last, isOperator(last) {
            expressionToEvaluate.removeLast()
        }
        
        if openParenthesisCount > 0 {
            expressionToEvaluate.append(String(repeating: ButtonTitle.closeParenthesis.rawValue, count: openParenthesisCount))
            openParenthesisCount = 0
        }
        
        print("Infix expression: \(expressionToEvaluate)")
        
        if let resultStr = evaluate(expressionToEvaluate) {
            state = .result(resultStr)
        } else {
            state = .undefined
        }
    }
    
    private func evaluate(_ expression: String) -> String? {
        let preparedExpression = prepareExpression(expression)
        let rpn = RPNConverter.infixToRPN(preparedExpression)
        let result = RPNEvaluator.evaluate(rpn)
        if result.isNaN {
            return nil
        }
        return formatNumber(result, toPlaces: 8)
    }
    
}
