import XCTest
@testable import Sprint7


final class StatisticServiceMock: StatisticService {
    var gamesCount: Int = 0
    var bestGame: GameRecord = GameRecord(correct: 0, total: 0, date: Date())
    var totalAccuracy: Double = 0
    func store(correct count: Int, total amount: Int) {}
}

final class MoviesLoaderMock: MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {}
}

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    func highlightImageBorder(isCorrect: Bool) {}
    func showFinalResults(message: String) {}
    func showNetworkError(message: String) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        
        let statisticService = StatisticServiceMock()
        let moviesLoader = MoviesLoaderMock()
        
        let sut = MovieQuizPresenter(
            view: viewControllerMock,
            statisticService: statisticService,
            moviesLoader: moviesLoader
        )
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

