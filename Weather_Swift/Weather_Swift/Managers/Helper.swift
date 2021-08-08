//
//  Helper.swift
//  Weather_Swift
//
//  Created by Priyanka Bandaru on 8/5/21.
//

import Foundation
import UIKit
class Helper{
    
    static func loadLocationsfromJSON()->[Location]{
        var locations = [Location]()
        let location_response = JSONHelper.getJSONFrom(fileName: "Locations")
        if location_response != nil{
            if let response = location_response as? NSMutableArray{
                for locationres in response{
                    let location = Location()
                    if let locationDictionary = locationres as? NSMutableDictionary{
                        location.title = locationDictionary.object(forKey: "title")as? String ?? " "
                        location.woeid=locationDictionary.object(forKey: "woeid") as? Int ?? 0
                        location.location_type=locationDictionary.object(forKey: "location_type") as? String ?? " "
                        locations.append(location)
                    }
                }
            }
        }
        return locations
    }
    
    static func getTommorrowsDate()->String{
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let inputFormatter = DateFormatter()
        let showDate = Calendar.current.date(from: tomorrow)!
        inputFormatter.dateFormat = "yyyy/MM/dd"
        let resultString = inputFormatter.string(from: showDate)
        return resultString
    }
    
    static func convertDatefrom(string:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:string)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEE, MMM dd"
        return dateFormatterPrint.string(from: date!)
    }
    
    static func getIndexToDisplay(swipeDirection:String,currentLocation:String,fromLocation:[Location])-> Int {
        var indexTodisplay = Int()
        if swipeDirection == "right"{
            let indexOfCity = fromLocation.enumerated().filter({ $0.element.title == currentLocation }).map({$0.offset})
            indexTodisplay = fromLocation.count - 1
            if indexOfCity[0] <= fromLocation.count - 1 && indexOfCity[0] != 0 {
                indexTodisplay = indexOfCity[0] - 1
            }
        }else if swipeDirection == "left"{
            let indexOfCity = fromLocation.enumerated().filter({ $0.element.title == currentLocation }).map({$0.offset})
            indexTodisplay = 0
            if indexOfCity[0] < fromLocation.count - 1{
                indexTodisplay = indexOfCity[0] + 1
            }
        }
        return indexTodisplay
    }
    
    static func getImageName(state:String)->(String,String){
        var imageName:String = ""
        var weatherImageName:String = " "
        switch(state){
        case Weather.lightRain:
            imageName = BackgroundImage.lightRain
            weatherImageName = WeatherImageName.lightRain
            break
        case Weather.heavyRain:
            imageName = BackgroundImage.heavyRain
            weatherImageName = WeatherImageName.heavyRain
            break
        case Weather.clear:
            imageName = BackgroundImage.clear
            weatherImageName = WeatherImageName.clear
            break
        case Weather.heavyCloud:
            imageName = BackgroundImage.heavyCloud
            weatherImageName = WeatherImageName.heavyCloud
            break
        case Weather.lightCloud:
            imageName = BackgroundImage.lightCloud
            weatherImageName = WeatherImageName.lightCloud
            break
        case Weather.snow:
            imageName = BackgroundImage.snow
            weatherImageName = WeatherImageName.snow
            break
        case Weather.sleet:
            imageName = BackgroundImage.sleet
            weatherImageName = WeatherImageName.sleet
            break
        case Weather.hail:
            imageName = BackgroundImage.hail
            weatherImageName = WeatherImageName.hail
            break
        case Weather.thunderstorm:
            imageName = BackgroundImage.thunderstorm
            weatherImageName = WeatherImageName.thunderstorm
            break
        case Weather.showers:
            imageName = BackgroundImage.showers
            weatherImageName = WeatherImageName.showers
            break
        default:
            break
        }
        return (imageName,weatherImageName)
    }
    
}


