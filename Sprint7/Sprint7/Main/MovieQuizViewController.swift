import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var showFilmPoster: UIImageView!
    @IBOutlet private weak var showQuestionLabel: UILabel!
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var showQuestionNumber: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFilmPoster.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(delegate: self)
        let statisticService = StatisticServiceImplementation()
            let moviesLoader = MoviesLoader()
            
        presenter = MovieQuizPresenter(
            view: self,
            statisticService: statisticService,
            moviesLoader: moviesLoader)
        buttonYes.accessibilityIdentifier = "Yes"
        buttonNo.accessibilityIdentifier = "No"
        showQuestionNumber.accessibilityIdentifier = "Index"
        showFilmPoster.accessibilityIdentifier = "Poster"
    }

    // MARK: - Actions
    
    @IBAction private func buttonYesClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func buttonNoClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Functions
    
    func show(quiz step: QuizStepViewModel) {
        showFilmPoster.image = UIImage(data: step.image)
        showQuestionLabel.text = step.question
        showQuestionNumber.text = step.questionNumber
        showFilmPoster.layer.borderWidth = 0
        buttonsEnabled(true)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        buttonsEnabled(false)
        showFilmPoster.layer.masksToBounds = true
        showFilmPoster.layer.borderWidth = 8
        showFilmPoster.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
           // self?.presenter.proceedToNextQuestionOrResults()
       // }
    }
    
    func showFinalResults(message: String) {
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
            })
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                self?.presenter.restartGame()
            }
        alertPresenter?.show(alertModel: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func buttonsEnabled(_ isEnabled: Bool) {
        buttonYes.isEnabled = isEnabled
        buttonNo.isEnabled = isEnabled
    }
}



