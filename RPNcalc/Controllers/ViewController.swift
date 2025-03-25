import UIKit

class ViewController: UIViewController, CalculatorViewDelegate {    
    
    private let calculatorView = CalculatorView()
    private var logic: CalculatorLogicProtocol = CalculatorLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupCalculatorView()
        calculatorView.delegate = self
        updateDisplay()
        setupNavigationBarButton()
    }
    
    private func setupCalculatorView() {
        view.addSubview(calculatorView)
        calculatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calculatorView.topAnchor.constraint(equalTo: view.topAnchor),
            calculatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calculatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calculatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - CalculatorViewDelegate Methods
    func calculatorViewDidTapButton(didTapButton button: ButtonTitle) {
        logic.handleInput(button)
        updateDisplay()
    }
    
    func calculatorViewDidLongPressClear() {
        logic.handleInput(.allClear)
        updateDisplay()
    }
    
    
    // MARK: - Update Display
    
    private func updateDisplay() {
        let expression = logic.getExpressionText()
        let attributedText = Utils.createAttributedText(for: expression, count: logic.openParenthesisCount)
        calculatorView.displayLabel.attributedText = attributedText
        updateClearButtonTitle()
        view.layoutIfNeeded()
        updateScrollViewOffset()
        updateHistoryLabel()
    }
    
    private func updateScrollViewOffset() {
        let maxOffsetX = max(0, calculatorView.displayScrollView.contentSize.width - calculatorView.displayScrollView.bounds.width)
        calculatorView.displayScrollView.setContentOffset(CGPoint(x: maxOffsetX, y: 0), animated: false)
    }
    
    private func updateHistoryLabel() {
        if !logic.lastInfixExpression.isEmpty {
            calculatorView.historyLabel.text = logic.lastInfixExpression
        } else {
            calculatorView.historyLabel.text = ""
        }
    }
    
    private func updateClearButtonTitle() {
        switch logic.state {
        case .undefined, .empty, .result(_):
            calculatorView.dynamicClearButton?.setTitle("AC", for: .normal)
        case .normal(_):
            calculatorView.dynamicClearButton?.setTitle("⌫", for: .normal)
        }
    }
    
    // MARK: - Navigation Bar Buttons
    
    private func setupNavigationBarButton() {
        navigationController?.navigationBar.tintColor = UIColor.textLabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .done,
            target: self,
            action: #selector(showHistory)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb"),
            style: .done,
            target: self,
            action: #selector(toggleThemeNav)
        )
    }
    
    @objc private func showHistory() {
        let historyVC = HistoryViewController()
        historyVC.history = logic.history
        
        historyVC.onDeleteEntry = { [weak self] index in
            self?.logic.history.remove(at: index)
        }
        historyVC.onClearHistory = { [weak self] in
            self?.logic.history.removeAll()
        }
        let navVC = UINavigationController(rootViewController: historyVC)
        navVC.modalPresentationStyle = .pageSheet
        present(navVC, animated: true, completion: nil)
    }
    
    @objc private func toggleThemeNav() {
        Utils.toggleColorScheme(view: view)
    }
    
}
