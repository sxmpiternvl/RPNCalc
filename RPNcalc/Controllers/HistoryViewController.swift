
import UIKit

class HistoryViewController: UIViewController {
    
    private let userDefaultsManager = UserDefaultManager()
    private var history: [HistoryEntry] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistory()
        setupHistoryViewController()
        setupConstraints()
        setupNavigationBarButton()
    }
    
    private func setupHistoryViewController() {
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("historyTitle", comment: "History title")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    private func setupNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("clear", comment: "Clear history"),
            style: .plain,
            target: self,
            action: #selector(clearHistory)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("done", comment: "Done"),
            style: .done,
            target: self,
            action: #selector(done)
        )
    }
    
    @objc func clearHistory() {
        history.removeAll()
        userDefaultsManager.clearHistory()
        getHistory()
        tableView.reloadData()
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    private func getHistory() {
        history = userDefaultsManager.getHistory()
    }
}

// MARK: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infixLabel = NSLocalizedString("infix", comment: "Label for the infix expression")
        let postfixLabel = NSLocalizedString("postfix", comment: "Label for the postfix (RPN) expression")
        let resultLabel = NSLocalizedString("Result", comment: "Label for the result")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let entry = history[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(infixLabel): \(entry.infixExpression)
        \(postfixLabel): \(entry.rpnExpression)
        \(resultLabel): \(entry.result)
        """
        return cell
    }
}

// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = history[indexPath.row]
            history.remove(at: indexPath.row)
            userDefaultsManager.removeHistory(with: model.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
