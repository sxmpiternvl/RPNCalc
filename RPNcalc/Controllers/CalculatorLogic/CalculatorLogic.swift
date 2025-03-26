
import Foundation

enum ExpressionState {
    case empty
    case normal(String)
    case undefined
    case result(String)
}

class CalculatorLogic: CalculatorLogicProtocol {
    
    private let userDefaultsManager = UserDefaultManager()

    var openParenthesisCount: Int = 0
    var lastInfixExpression: String = ""
    private(set) var state: ExpressionState = .empty
    private let numbersLogic = NumbersLogic()
    private let operatorsLogic = OperatorsLogic()
    private let parenthesisLogic = ParenthesisLogic()
    private let utils = CalculatorUtils()
    private let historyKey = "calculatorHistory"
    
    func getExpressionText() -> String {
        switch state {
        case .empty:
            return ButtonTitle.zero.rawValue
        case .normal(let expression):
            return expression
        case .undefined:
            return NSLocalizedString("nanNumber", comment: "NaN number")
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
        case .backspace:
            backspace()
        case .allClear:
            allClear()
        }
    }
    
    private func backspace() {
        switch state {
        case .normal(var expr):
            if let last = expr.last, String(last) == ButtonTitle.openParenthesis.rawValue {
                openParenthesisCount -= 1
            }
            expr.removeLast()
            state = expr.isEmpty ? .empty : .normal(expr)
        default:
            break
        }
    }
    
    private func allClear() {
        state = .empty
        lastInfixExpression = ""
        openParenthesisCount = 0
    }
    
    private func evaluateExpression() {
        guard case .normal(let expr) = state else { return }
        guard expr.filter({ $0.isNumber }).count >= 2 else { return }
        
        let cleanedExpression = appendMissingParentheses(removeTrailingOperator(expr))
        
        let preparedExpression = utils.prepareExpression(cleanedExpression)
        
        let rpn = RPNConverter.infixToRPN(preparedExpression)
        
        let resultValue = RPNEvaluator.evaluate(rpn)
        
        if resultValue.isNaN {
                state = .undefined
                return
            }
        
        let resultStr = utils.formatNumber(resultValue)
        
        updateHistory(infix: cleanedExpression, result: resultStr, postfix: rpn)
        lastInfixExpression = cleanedExpression
        state = .result(resultStr)
    }
    
    private func removeTrailingOperator(_ expression: String) -> String {
        var expr = expression
        if let last = expr.last, utils.isOperator(last) ||
            last == Character(ButtonTitle.decimalSeparator.rawValue) {
            expr.removeLast()
        }
        return expr
    }
    
    private func appendMissingParentheses(_ expression:String) -> String {
        var expr = expression
        if openParenthesisCount > 0 {
            let closingBrackets = String(repeating: ButtonTitle.closeParenthesis.rawValue, count: openParenthesisCount)
            expr.append(closingBrackets)
            openParenthesisCount = 0
        }
        return expr
    }
    
    private func updateHistory(infix infixExp: String, result: String, postfix rpn: [String]) {
        let rpnExpression = rpn.joined(separator: " ")
        let model: HistoryEntry = .init(id: UUID().uuidString, infixExpression: infixExp, rpnExpression: rpnExpression, result: result)
        userDefaultsManager.addHistory(model)
    }

    
}
