import XCTest
@testable import RPNcalc  // Обратите внимание на маленькую 'c'

class CalculatorLogicTests: XCTestCase {
    
    var logic: CalculatorLogic!
    
    override func setUp() {
        super.setUp()
        logic = CalculatorLogic()
    }
    
    override func tearDown() {
        logic = nil
        super.tearDown()
    }
    
    // MARK: - State Tests
    func testInitialState() {
        XCTAssertEqual(logic.getExpressionText(), "0")
    }
    
    // MARK: - Number Input Tests
    func testNumberInput() {
        logic.handleInput(.one)
    }
    
    func testMultipleNumberInput() {
        logic.handleInput(.one)
        logic.handleInput(.two)
    }
    
    // MARK: - Operator Tests
    func testOperatorAfterNumber() {
        logic.handleInput(.five)
        logic.handleInput(.add)
    }
    
    // MARK: - Evaluation Tests
    func testSimpleEvaluation() {
        logic.handleInput(.five)
        logic.handleInput(.add)
        logic.handleInput(.three)
        logic.handleInput(.equals)
        
        if case .result(let result) = logic.state {
            XCTAssertEqual(result, "8")
        } else {
            XCTFail("Expected result state")
        }
    }
    
    // MARK: - Helper Methods
    private func assertStateAfterInputs(_ inputs: [ButtonTitle], equals expectedState: ExpressionState) {
        inputs.forEach { logic.handleInput($0) }
    }
}
