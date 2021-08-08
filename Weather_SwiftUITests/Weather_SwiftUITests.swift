//
//  Weather_SwiftUITests.swift
//  Weather_SwiftUITests
//
//  Created by Priyanka Bandaru on 7/29/21.
//

import XCTest

class Weather_SwiftUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
            app.terminate()
        }
    }
    func testloadWeatherWithSwiping() throws {
        app.launch()
        let isDisplayingWeatherView = app.otherElements["Weather View"].exists
        XCTAssertTrue(isDisplayingWeatherView)
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "City Label").label,"London")
        app.swipeRight()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "City Label").label,"Berlin")
        app.swipeLeft()
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "City Label").label,"London")
        app.terminate()
    }
    
    func testImageExists() throws {
        app.launch()
        let isDisplayingWeatherView = app.otherElements["Weather View"].exists
        XCTAssertTrue(isDisplayingWeatherView)
        XCTAssertTrue(app.images["Weather Image"].exists)
        app.terminate()
    }
    
    func testLabelsExistOnRightSwipe() throws{
        app.launch()
        assertLabelTests()
        app.swipeRight()
        assertLabelTests()
        app.terminate()
    }
    
    func testLabelsExistOnLeftSwipe() throws{
        app.launch()
        assertLabelTests()
        app.swipeLeft()
        assertLabelTests()
        app.terminate()
    }
    
    func assertLabelTests(){
        XCTAssertTrue(app.staticTexts["Weather State Label"].exists)
        XCTAssertTrue(app.staticTexts["Applicable Date Label"].exists)
        XCTAssertTrue(app.staticTexts["Temp Label"].exists)
        XCTAssertTrue(app.staticTexts["Max Temp Label"].exists)
        XCTAssertTrue(app.staticTexts["Min Temp Label"].exists)
    }
    
    func testWeatherStateLabel() throws{
        app.launch()
        let value = app.staticTexts.element(matching: .any, identifier: "Weather State Label").label
        switch(value){
        case "Light Rain":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "lr.png")
            break
        case "Heavy Rain":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "hr.png")
            break
        case "Clear":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "c.png")
            break
        case "Heavy Cloud":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "hc.png")
            break
        case "Light Cloud":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "lc.png")
            break
        case "Snow":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "sn.png")
            break
        case "Sleet":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "sl.png")
            break
        case "Hail":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "h.png")
            break
        case "ThunderStorm":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "t.png")
            break
        case "Showers":
            XCTAssertEqual(app.images["Weather Image"].value as! String, "s.png")
            break
        default:
            break
        }
    }
    
    func testWeatherStateImagefromLabel() throws{
        app.launch()
        let value = app.images["Weather Image"].value as! String
        switch(value){
        case "lr.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label,"Light Rain")
            break
        case "hr.png" :
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label,"Heavy Rain" )
            break
        case "c.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label,"Clear")
            break
        case "hc.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label,"Heavy Cloud")
            break
        case "lc.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "Light Cloud")
            break
        case "sn.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "Snow")
            break
        case "sl.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "Sleet")
            break
        case "h.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "Hail")
            break
        case "t.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "ThunderStorm")
            break
        case "s.png":
            XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Weather State Label").label, "Showers")
            break
        default:
            break
        }
    }
    func testDateCorrectlyGenerated(){
        app.launch()
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let inputFormatter = DateFormatter()
        let showDate = Calendar.current.date(from: tomorrow)!
        inputFormatter.dateFormat = "EEE, MMM dd"
        let resultString = inputFormatter.string(from: showDate)
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "Applicable Date Label").label,resultString)
        app.terminate()
    }
    
    func testDateGeneratedWithError(){
        app.launch()
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let inputFormatter = DateFormatter()
        let showDate = Calendar.current.date(from: tomorrow)!
        inputFormatter.dateFormat = "EEE MMM dd"
        let resultString = inputFormatter.string(from: showDate)
        XCTAssertNotEqual(app.staticTexts.element(matching: .any, identifier: "Applicable Date Label").label,resultString)
        app.terminate()
    }
}
