import Foundation

struct RPNEvaluator {
    static func evaluate(_ rpn: [String]) -> Double {
        var stack = [Double]()
        for token in rpn {
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else {
                    return Double.nan
                }
                let a = stack.removeLast()
                let b = stack.removeLast()
                var result: Double = 0
                switch token {
                case "+":
                    result = b + a
                case "-":
                    result = b - a
                case "*":
                    result = b * a
                case "/":
                    if a == 0 { return Double.nan }
                    result = b / a
                case "^":
                    result = pow(b, a)
                default:
                    break
                }
                stack.append(result)
            }
        }
        return stack.last ?? 0
    }
}
