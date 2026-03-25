protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrect: Bool)
    func showFinalResults(message: String)
    func showNetworkError(message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

