import UIKit

class ViewController: UIViewController {
    
    private let calculatorView = CalculatorView()
    private var logic: CalculatorLogicProtocol = CalculatorLogic()
    private var isDarkMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupCalculatorView()
        setupButtonActions()
        setupLongPressForClearButton()
        updateDisplay()
        setupNavigationBarButton()
    }
    
    private func setupNavigationBarButton() {
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
            action: #selector(
                toggleTheme
            )
        )
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
    
    private func setupButtonActions() {
        let buttons = calculatorView.buttonsContainer.arrangedSubviews
            .compactMap { $0 as? UIStackView }
            .flatMap { $0.arrangedSubviews }
            .compactMap { $0 as? UIButton }
        
        buttons.forEach { button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle,
              let button = ButtonTitle(rawValue: title) else { return }
        logic.handleInput(button)
        updateDisplay()
    }
    
    private func setupLongPressForClearButton() {
        if let clearButton = calculatorView.dynamicClearButton {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressClear(_:)))
            clearButton.addGestureRecognizer(longPress)
        }
    }
    
    @objc func longPressClear(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            logic.handleInput(.allClear)
            updateDisplay()
        }
    }
    
    private func updateDisplay() {
        let expression = logic.getExpressionText()
        let fontSize: CGFloat = (expression == "Не определено") ? 46 : 58
        let font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: font
        ]
        let attributedText = NSMutableAttributedString(string: expression, attributes: mainAttributes)
        if logic.openParenthesisCount > 0 {
            let lightText = String(repeating: ")", count: logic.openParenthesisCount)
            let lightAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: font
            ]
            let lightAttributedText = NSAttributedString(string: lightText, attributes: lightAttributes)
            attributedText.append(lightAttributedText)
        }
        calculatorView.displayLabel.attributedText = attributedText
        updateClearButtonTitle()
        view.layoutIfNeeded()
        
        let maxOffsetX = max(0, calculatorView.displayScrollView.contentSize.width - calculatorView.displayScrollView.bounds.width)
        calculatorView.displayScrollView.setContentOffset(CGPoint(x: maxOffsetX, y: 0), animated: false)
        
        
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
    
    @objc private func toggleTheme() {
        isDarkMode.toggle()
        let newStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
        guard let window = view.window else { return }
        window.overrideUserInterfaceStyle = newStyle
    }
    
}

