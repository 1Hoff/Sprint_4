
import UIKit

class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak var showFilmPoster: UIImageView!
    @IBOutlet weak var showQuestionLabel: UILabel!
    @IBOutlet weak var ButtonNo: UIButton!
    @IBOutlet weak var ButtonYes: UIButton!
    @IBOutlet weak var showQuestionNumber: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var totalCorrectAnswers = 0
    private var totalGamesPlayed = 0
    private var bestRecord = 0
    private var totalQuestionsAsked = 0
    private var bestRecordDate: Date?
    private var bestRecordString = ""
    
    
    
    
    private struct QuizQuestion {
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
        
        showQuestionLabel.text = currentQuestion.text
        
        showFilmPoster.image = UIImage(named: currentQuestion.image)
        
        showQuestionNumber.text = "\(currentQuestionIndex + 1)/\(questions.count)"
    }
    
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        showFilmPoster.layer.masksToBounds = true // 1
        showFilmPoster.layer.borderWidth = 8 // 2
        showFilmPoster.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3
        showFilmPoster.layer.cornerRadius = 20 // 4
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showFilmPoster.layer.borderWidth = 0
            self.nextQuestion()
        }
    }
    
        
    
    
    

    @IBAction private func ButtonYes(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = true // 2
        ButtonYes.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
        
    }
    @IBAction private func ButtonNo(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex] // 1
        let givenAnswer = false // 2
        ButtonNo.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer) // 3
    }
    
    
    
    
    
    
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            ButtonNo.isEnabled = true
            ButtonYes.isEnabled = true
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
                    bestRecordString = "\(bestRecord)/\(questions.count) \(formatter.string(from: date))"
                }
            }
            
            let accuracy = totalQuestionsAsked > 0 ? (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100 : 0
            let accuracyString = String(format: "%.1f", accuracy)
            
            
            let message = """
            Ваш результат: \(correctAnswers) из \(questions.count)
            Игр сыграно: \(totalGamesPlayed)
            Ваш лучший рекорд: \(bestRecordString)
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
