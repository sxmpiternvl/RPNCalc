import Foundation

func stringFromRoundedNumber(_ value: Double, toPlaces places: Int) -> String {
    let intMax = 1e10
    let intMin = 1e-10
    if abs(value) >= intMax || (abs(value) < intMin && value != 0) {
        return String(format: "%e", value)
    }
    let multiplier = pow(10.0, Double(places))
    let roundedValue = (value * multiplier).rounded() / multiplier
    if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
        return "\(Int(roundedValue))"
    } else {
        return "\(roundedValue)"
    }
}
