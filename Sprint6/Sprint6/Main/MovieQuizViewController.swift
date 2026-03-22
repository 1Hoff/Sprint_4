import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var showFilmPoster: UIImageView!
    @IBOutlet private weak var showQuestionLabel: UILabel!
    @IBOutlet private weak var ButtonNo: UIButton!
    @IBOutlet private weak var ButtonYes: UIButton!
    @IBOutlet private weak var showQuestionNumber: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private var alertPresenter: AlertPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        showFilmPoster.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(delegate: self)

        showLoadingState()
        questionFactory?.loadData()
    }

    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.show(question: question)
        }
    }
    
    private func show(question: QuizQuestion) {
        showFilmPoster.image = UIImage(data: question.image)
        showQuestionLabel.text = question.text
        showQuestionNumber.text = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        showFilmPoster.layer.borderWidth = 0
        ButtonYes.isEnabled = true
        ButtonNo.isEnabled = true
    }
    
    
    
    
    
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
            
            let model = AlertModel(
                title: "Ошибка",
                message: message,
                buttonText: "Попробовать еще раз") { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    self?.questionFactory?.loadData()
                }
        alertPresenter?.show(alertModel: model)
        }
        
        
        
    func didLoadDataFromServer() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true // На всякий случай скрываем принудительно
            self?.questionFactory?.requestNextQuestion()
        }
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
        

    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 }
        
        showFilmPoster.layer.masksToBounds = true
        showFilmPoster.layer.borderWidth = 8
        showFilmPoster.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        ButtonYes.isEnabled = false
        ButtonNo.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            

            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        

        questionFactory?.reset()
        

        questionFactory?.requestNextQuestion()
    }

    
    
    
    
    
    private func showFinalResults() {
        guard let stats = statisticService else { return }
        

        let bestGame = stats.bestGame
        let recordText = "\(bestGame.correct)/\(bestGame.total)"
        let dateText = bestGame.date.dateTimeString
        let accuracyText = String(format: "%.2f", stats.totalAccuracy)
        
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(stats.gamesCount)
        Рекорд: \(recordText) (\(dateText))
        Средняя точность: \(accuracyText)%
        """
        

            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.restartQuiz()
                })
            

            alertPresenter?.show(alertModel: alertModel)
        }
        
        


    @IBAction private func ButtonYes(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func ButtonNo(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    private func showLoadingState() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}


