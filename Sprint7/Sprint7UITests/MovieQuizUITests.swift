import XCTest
func testYesButton() {
    let app = XCUIApplication()
    app.launch()

    let firstIndex = app.staticTexts["Index"].label
    app.buttons["Yes"].tap()
    sleep(2)
    let secondIndex = app.staticTexts["Index"].label
    XCTAssertNotEqual(firstIndex, secondIndex)
}
