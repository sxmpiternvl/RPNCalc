
import Foundation

struct UserDefaultManager {
    
    private let historyKey = "CalculatorHistory"
    
    func getHistory() -> [HistoryEntry] {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([HistoryEntry].self, from: data)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func addHistory(_ history: HistoryEntry) {
        var list = getHistory()
        list.append(history)
        save(list)
    }
    
    func removeHistory(with id: String) {
        var list = getHistory()
        list.removeAll(where: { $0.id == id })
        save(list)
    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
    
    private func save(_ list: [HistoryEntry]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("\(error)")
        }
    }
}
