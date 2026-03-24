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
        
        let firstIndex = app.staticTexts["Index"].label
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        let secondIndex = app.staticTexts["Index"].label
        XCTAssertNotEqual(firstIndex, secondIndex)
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
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
}
