func replaceSigns(_ input: String) -> [String] {
   var result = input
   result = result.replacingOccurrences(of: "÷", with: "/")
   result = result.replacingOccurrences(of: "×", with: "*")

   var output:[String] = []
   let chars = result.split(separator: "")
   for i in 0..<chars.count {
       let char = chars[i]
       switch char {
       case "-":
           if i == 0 || chars[i - 1] == "(" {
               output.append("0")
           }
           output.append(String(char))
       default:
           output.append(String(char))
       }
   }
   return output
}
