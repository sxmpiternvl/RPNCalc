import UIKit
class CalculatorView: UIView {
    
    let buttonTitles: [[String]] = [
        ["AC", "(", ")", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["^", "0", ".", "="]
    ]
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let displayScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let displayContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    var dynamicClearButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(mainStack)
        mainStack.addArrangedSubview(displayScrollView)
        mainStack.addArrangedSubview(buttonsContainer)
        displayScrollView.addSubview(displayContainer)
        displayContainer.addSubview(displayLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let displayHeightConstraint = displayScrollView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.45)
        displayHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            displayContainer.topAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.topAnchor),
            displayContainer.bottomAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.bottomAnchor),
            displayContainer.leadingAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.leadingAnchor),
            displayContainer.trailingAnchor.constraint(equalTo: displayScrollView.contentLayoutGuide.trailingAnchor),
            displayContainer.heightAnchor.constraint(equalTo: displayScrollView.frameLayoutGuide.heightAnchor),
            displayContainer.widthAnchor.constraint(greaterThanOrEqualTo: displayScrollView.frameLayoutGuide.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            displayLabel.bottomAnchor.constraint(equalTo: displayContainer.bottomAnchor, constant: -16),
            displayLabel.leadingAnchor.constraint(equalTo: displayContainer.leadingAnchor, constant: 16),
            displayLabel.trailingAnchor.constraint(equalTo: displayContainer.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButtons() {
        buttonTitles.forEach { row in
            let rowStack = createButtonRow(row)
            buttonsContainer.addArrangedSubview(rowStack)
        }
    }

    private func createButtonRow(_ titles: [String]) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually

        titles.forEach { title in
            let button = createButton(title)
            if (title == "AC" || title == "⌫") && dynamicClearButton == nil {
                dynamicClearButton = button
            }
            rowStack.addArrangedSubview(button)
        }
        return rowStack
    }

    private func createButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        button.layer.cornerRadius = 30
        
        switch title {
        case "+", "-", "×", "÷", "=":
            button.backgroundColor = .systemPink
        case "(", ")", "AC", "⌫":
            button.backgroundColor = .darkGray
        default:
            button.backgroundColor = .gray
        }
        
        button.setTitleColor(.orange, for: .normal)
        return button
    }
    
}
