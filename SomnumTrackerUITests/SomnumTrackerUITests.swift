//
//  SomnumTrackerUITests.swift
//  SomnumTrackerUITests
//
//  Created by Toni Lozano Fernández on 19/4/23.
//

import XCTest

final class SomnumTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testAddEntryAndStatsNavigation() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let addAlertButton = XCUIApplication().buttons["add"]
        XCTAssertTrue(addAlertButton.exists)
        addAlertButton.tap()
        let cancelButton = app.staticTexts["Cancel"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()
        
        addAlertButton.tap()
        let datePickerCalendar = app.datePickers["dateEntry"]
        XCTAssertTrue(datePickerCalendar.exists)
        datePickerCalendar.tap()
        
        let calendarCollectionViewsQuery = app.datePickers.collectionViews
        calendarCollectionViewsQuery.buttons["Monday, 12 June"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        let popoverdismissregionButton = app/*@START_MENU_TOKEN@*/.buttons["PopoverDismissRegion"]/*[[".buttons[\"dismiss popup\"]",".buttons[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        popoverdismissregionButton.tap()

        let resetButton = app.buttons["Reset"]
        XCTAssertTrue(resetButton.exists)
        resetButton.tap()
        
        datePickerCalendar.tap()
        calendarCollectionViewsQuery.buttons["Monday, 12 June"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        popoverdismissregionButton.tap()

        let datePickerTimeOfSleep = app.datePickers["timeOfSleepEntry"]
        XCTAssertTrue(datePickerTimeOfSleep.exists)
        
        datePickerTimeOfSleep.tap()
        
        popoverdismissregionButton.tap()

        let datePickerWakeUpTimeEntry = app.datePickers["wakeUpTimeEntry"]
        XCTAssertTrue(datePickerWakeUpTimeEntry.exists)
        
        datePickerWakeUpTimeEntry.tap()
        
        popoverdismissregionButton.tap()
        
        let submitButton = app.buttons["Submit"]
        XCTAssertTrue(submitButton.exists)
        submitButton.tap()

        let leftCircleButton = app.buttons["Arrow Left Circle"]
        XCTAssertTrue(leftCircleButton.exists)
        leftCircleButton.tap()
        
        let rightCircleButton = app.buttons["Arrow Right Circle"]
        XCTAssertTrue(rightCircleButton.exists)
        rightCircleButton.tap()
    }
    
    func testSettingsNavigation() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let leftCircleButton = app.buttons["Arrow Left Circle"]
        XCTAssertTrue(leftCircleButton.exists)
        leftCircleButton.tap()
        
        let rightCircleButton = app.buttons["Arrow Right Circle"]
        XCTAssertTrue(rightCircleButton.exists)
        rightCircleButton.tap()
        
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        
        let trashButton = app.buttons["trash"]
        XCTAssertTrue(trashButton.exists)
        trashButton.tap()
        
        let trashAlert = app.alerts["Confirm"].scrollViews.otherElements
        let trashCancelButton = trashAlert.buttons["CANCEL"]
        XCTAssertTrue(trashCancelButton.exists)
        trashCancelButton.tap()
        
        trashButton.tap()
        let trashConfirmButton = trashAlert.buttons["OK"]
        XCTAssertTrue(trashConfirmButton.exists)
        trashConfirmButton.tap()
    }
}
