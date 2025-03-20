import Foundation

enum ExpressionState {
    case empty
    case normal(String)
    case undefined
    case result(String)
}

class CalculatorLogic: CalculatorLogicProtocol {
    
    init() {
        loadHistory()
    }
    
    var openParenthesisCount: Int = 0
    var lastInfixExpression: String = ""
    var history: [HistoryEntry] = []
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
        openParenthesisCount = 0
    }
    
    private func evaluateExpression() {
        guard case .normal(let expr) = state else { return }
        guard expr.filter({ $0.isNumber }).count >= 2 else { return }
        
        let cleanedExpression = appendMissingParentheses(removeTrailingOperator(from: expr))
        
        let preparedExpression = utils.prepareExpression(cleanedExpression)
        
        let rpn = RPNConverter.infixToRPN(preparedExpression)
        
        let resultValue = RPNEvaluator.evaluate(rpn)
        
        guard !resultValue.isNaN else {
            state = .undefined
            return
        }
        
        let resultStr = utils.formatNumber(resultValue, toPlaces: 8)
        updateHistory(with: cleanedExpression, result: resultStr, preparedExpression: preparedExpression)
        
        lastInfixExpression = cleanedExpression
        state = .result(resultStr)
    }
    
    private func removeTrailingOperator(from expression: String) -> String {
        var expr = expression
        if let last = expr.last, utils.isOperator(last) {
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
    
    private func updateHistory(with originalExpression: String, result: String, preparedExpression: [String]) {
        let rpn = RPNConverter.infixToRPN(preparedExpression)
        let rpnExpression = rpn.joined(separator: " ")
        let entry = HistoryEntry(infixExpression: originalExpression, rpnExpression: rpnExpression, result: result)
        history.append(entry)
        saveHistory()
    }
    
    func saveHistory() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(history)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Ошибка сохранения истории: \(error)")
        }
    }
    
    func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }
        do {
            let decoder = JSONDecoder()
            history = try decoder.decode([HistoryEntry].self, from: data)
        } catch {
            print("Ошибка загрузки истории: \(error)")
        }
    }
    
}
