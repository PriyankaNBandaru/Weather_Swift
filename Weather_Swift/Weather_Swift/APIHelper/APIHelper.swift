//
//  APIHelper.swift:Helper class to make any API Calls.
//  Weather_Swift
//
//  Created by Priyanka Bandaru on 8/4/21.
//

import Foundation

class APIHelper {
    
    //Function to retrieve the weather information for a particular woeid on a particular date
    static func fetchlocationWeather(woeid:Int,date:String,completionHandler: @escaping (LocationWeather) -> Void) {
        var baseUrl:String = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let configValues = NSDictionary(contentsOfFile: path) {
                baseUrl = configValues["baseURL"]  as! String
            }
        }
        let str = baseUrl + "location/\(woeid)/\(date)"
        let url = URL(string: str)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching location weathers: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            if let data = data{
                let JSONfromlocation = JSONHelper.getJSONFrom(data: data)
                let locationWeather = LocationWeather()
                if let response = JSONfromlocation as? NSMutableArray{
                    //The first record displays the latest information of the weather for the date provided.
                    let locationWeatherRes = response[0]
                    if let locationWeatherDictionary = locationWeatherRes as? NSMutableDictionary{
                        locationWeather.weatherStateAbbr = locationWeatherDictionary.object(forKey: "weather_state_abbr")as? String ?? " "
                        locationWeather.weatherState = locationWeatherDictionary.object(forKey: "weather_state_name")as? String ?? " "
                        locationWeather.min_Temp = locationWeatherDictionary.object(forKey: "min_temp") as? Double ?? 0
                        locationWeather.max_Temp = locationWeatherDictionary.object(forKey: "max_temp") as? Double ?? 0
                        locationWeather.air_pressure = locationWeatherDictionary.object(forKey: "air_pressure") as? Double ?? 0
                        locationWeather.applicable_date = locationWeatherDictionary.object(forKey: "applicable_date") as? String ?? ""
                        locationWeather.the_temp = locationWeatherDictionary.object(forKey: "the_temp") as? Double ?? 0
                        locationWeather.wind_speed = locationWeatherDictionary.object(forKey: "wind_speed") as? Double ?? 0
                        locationWeather.wind_direction = locationWeatherDictionary.object(forKey: "wind_direction") as? Double ?? 0
                        locationWeather.wind_direction_compass = locationWeatherDictionary.object(forKey: "wind_direction_compass") as? String ?? " "
                        locationWeather.predictability  = locationWeatherDictionary.object(forKey: "predictability") as? Int ?? 0
                        locationWeather.visibility = locationWeatherDictionary.object(forKey: "visibility") as? Double ?? 0
                        locationWeather.humidity = locationWeatherDictionary.object(forKey: "humidity") as? Double ?? 0
                    }
                    completionHandler(locationWeather)
                }
            }
            
        })
        task.resume()
    }
}
