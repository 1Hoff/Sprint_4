import XCTest

final class Sprint7UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testYesButton() {
        let app = XCUIApplication()
        app.launch()
        
        let poster = app.images["Poster"]
        let firstIndex = app.staticTexts["Index"].label
        
        XCTAssertTrue(poster.exists)
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        let secondIndex = app.staticTexts["Index"].label
        
        XCTAssertNotEqual(firstIndex, secondIndex)
        XCTAssertTrue(poster.exists)
    }

    func testNoButton() {
        let app = XCUIApplication()
        app.launch()
        
        let firstIndex = app.staticTexts["Index"].label
        app.buttons["No"].tap()
        
        sleep(2)
        
        let secondIndex = app.staticTexts["Index"].label
        XCTAssertNotEqual(firstIndex, secondIndex)
    }

    func testAlertAppearance() {
        let app = XCUIApplication()
        app.launch()
        
        for _ in 1...10 {
            let yesButton = app.buttons["Yes"]
                XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
                yesButton.tap()
                sleep(2)
        }
        
        let alertElement = app.alerts.firstMatch
        let alertExists = alertElement.waitForExistence(timeout: 15)
            
        XCTAssertTrue(alertExists, "Алерт об окончании раунда не появился спустя 15 секунд")
        XCTAssertEqual(alertElement.label, "Этот раунд окончен!")
    }

    func testGameRestart() {
        let app = XCUIApplication()
        app.launch()

        for _ in 1...10 {
            let yesButton = app.buttons["Yes"]
                XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
                yesButton.tap()
                sleep(2)
        }

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 10))
        alert.buttons.firstMatch.tap()
        XCTAssertFalse(alert.exists)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
