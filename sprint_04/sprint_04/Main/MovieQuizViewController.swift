
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Poster: UIImageView!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var ButtonNo: UIButton!
    @IBOutlet weak var ButtonYes: UIButton!
    @IBOutlet weak var number: UILabel!
    
    var currentQuestionIndex = 0
    var correctAnswers = 0
    var totalCorrectAnswers = 0
    var totalGamesPlayed = 0
    var bestRecord = 0
    var totalQuestionsAsked = 0
    var bestRecordDate: Date?
    var dateString = ""
    
    
    
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuestion()
    }
    
    
    
    
    private func showCurrentQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        
        Question.text = currentQuestion.text
        
        Poster.image = UIImage(named: currentQuestion.image)
        
        number.text = "\(currentQuestionIndex + 1)/\(questions.count)"
    }
    
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        Poster.layer.masksToBounds = true // 1
        Poster.layer.borderWidth = 8 // 2
        Poster.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3
        Poster.layer.cornerRadius = 20 // 4
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.nextQuestion()
        }
    }
    
        
    
    
    

    @IBAction private func ButtonYes(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
        
    }
    @IBAction private func ButtonNo(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    
    
    
    
    
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            showCurrentQuestion()
        } else {
            totalGamesPlayed += 1
            totalCorrectAnswers += correctAnswers
            totalQuestionsAsked += questions.count
            if bestRecord < correctAnswers {
                bestRecord = correctAnswers
                bestRecordDate = Date()
                if let date = bestRecordDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy HH:mm"
                    dateString = "\(bestRecord)/\(questions.count) \(formatter.string(from: date))"
                }
            }
            
            let accuracy = totalQuestionsAsked > 0 ? (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100 : 0
            let accuracyString = String(format: "%.1f", accuracy)
            
            
            let message = """
            Ваш результат: \(correctAnswers) из \(questions.count)
            Игр сыграно: \(totalGamesPlayed)
            Ваш лучший рекорд: \(dateString)
            Средняя точность: \(accuracyString)%
            """
            
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: message,
                preferredStyle: .alert
                )
                
            
            let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
                self.currentQuestionIndex = 0
                self.showCurrentQuestion()
                self.totalGamesPlayed = 0
                self.correctAnswers = 0
            }

            alert.addAction(action)
                
            self.present(alert, animated: true, completion: nil)
        }
    }
}
