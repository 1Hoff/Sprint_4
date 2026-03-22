

final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    

    private var currentQuestionIndex = 0

    private var shuffledIndices: [Int] = []
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate

        reset()
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
    

    func reset() {
        currentQuestionIndex = 0
        shuffledIndices = Array(0..<questions.count).shuffled()
    }
    
    func requestNextQuestion() {

        guard currentQuestionIndex < shuffledIndices.count else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        

        let index = shuffledIndices[currentQuestionIndex]
        let question = questions[safe: index]
        

        currentQuestionIndex += 1
        
        delegate?.didReceiveNextQuestion(question: question)
    }
}
