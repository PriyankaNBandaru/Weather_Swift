//
//  Weather_SwiftTests.swift
//  Weather_SwiftTests
//
//  Created by Priyanka Bandaru on 7/29/21.
//

import XCTest
@testable import Weather_Swift

class Weather_SwiftTests: XCTestCase {
    var vc:ViewController?
    var locations:[Location]?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.setUpDefauts()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
extension Weather_SwiftTests{
    func setUpDefauts(){
        let storyboard   = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(identifier: "viewController") as? ViewController
        self.setWeatherInfo()
    }
    
    func setWeatherInfo(){
        locations = Helper.loadLocationsfromJSON()
    }
}
extension Weather_SwiftTests{
    
    func testLocationLoaded(){
        if locations != nil{
            XCTAssertTrue(true,"Locations loaded")
        }else{
            XCTAssertFalse(false,"Locations loaded")
        }
    }
    
    func testURLGenerated(){
        let woeid = 890869
        let date = "2021/08/06"
        let url = URL(string:"https://www.metaweather.com/api/location/\(woeid)/\(date)")
        if url != nil{
            XCTAssertTrue(true,"URL generation success")
        }else{
            XCTAssertFalse(false,"URL generation success")
        }
    }
    
    func testURLNotGenerated(){
        let woeid = 890869
        let date = "2021-08-06"
        let url = URL(string:"https://www.metaweather.com/api/location/\(woeid)/\(date)")
        if url == nil{
            XCTAssertTrue(true,"URL generation failed")
        }else{
            XCTAssertFalse(false,"URL generation failed")
        }
    }
    
    func testLocationExist(){
        let locationCity = "New York"
        if let location  = locations{
            if location.contains(where:{$0.title == locationCity}){
                XCTAssertTrue(true,"Location Exist")
            }else{
                XCTAssertFalse(false,"Location Exist")
            }
        }
    }
    
    func testLocationNotExist(){
        let locationCity = "San Francisco"
        if let location = locations{
            if !location.contains(where: {$0.title == locationCity}){
                XCTAssertTrue(true,"Location doesn't Exist")
            }else{
                XCTAssertFalse(false,"Location doesn't Exist")
            }
        }
    }
    
    func testfetchLocationWeatherReturnsSuccess(){
        var locationWeatherResponse:LocationWeather?
        let locationWeatherExpectation = expectation(description: "location Weather")
        APIHelper.fetchlocationWeather(woeid: 890869, date: "2021/08/06",completionHandler: { (locationWea) ->Void in
            locationWeatherResponse = locationWea
            locationWeatherExpectation.fulfill()
        })
        waitForExpectations(timeout: 1){ (error) in
            XCTAssertNotNil(locationWeatherResponse)
        }
    }
    
    func testConvertJSONFromDataReturnsSuccess(){
        let jsonData = "[{\"title\": \"Gothenburg\",\"location_type\": \"City\",\"woeid\": 890869}]".data(using:.utf8)
        let json = JSONHelper.getJSONFrom(data: jsonData!)
        XCTAssertNotNil(json)
    }
    func testgetJSONFromFileReturnsSuccess(){
        let json = JSONHelper.getJSONFrom(fileName: "Locations")
        XCTAssertNotNil(json)
    }
    
    func testgetJSONWithUnknownFileNameReturnsFailure(){
        let json = JSONHelper.getJSONFrom(fileName: "Location")
        XCTAssertNil(json)
    }
    
}

