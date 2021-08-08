//
//  JSONHelper.swift:Helper class to retrieve the JSON data from file/data and vice-versa
//  Weather_Swift
//
//  Created by Priyanka Bandaru on 8/3/21.
//

import Foundation

//MARK: - JSONHelper -

class JSONHelper {
    
    // to get json from file
    static func getJSONFrom(fileName: String) -> Any? {
        do {
            if let file = Bundle.main.url(forResource:fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
                return json
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    // to get json from data
    static func getJSONFrom(data: Data) -> Any? {
        let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
        return json
    }
    
    //to get data from json object
    static func data(withJSONObject:Any) -> Data?{
        let data =  try? JSONSerialization.data(withJSONObject:withJSONObject, options: JSONSerialization.WritingOptions.prettyPrinted)
        return data
    }
    
}

