
import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
        let correct = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
        return total > 0 ? (correct / total) * 100 : 0
    }
    
    var gamesCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        let currentCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(currentCorrect + count, forKey: Keys.correct.rawValue)
        
        let currentTotal = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(currentTotal + amount, forKey: Keys.total.rawValue)
        
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if newRecord > bestGame {
            bestGame = newRecord
        }
    }
}
