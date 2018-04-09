//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by pravir on 07/08/17.
//  Copyright © 2017 pravir. All rights reserved.
//

import UIKit
// this is where we will store all of our variables that will keep track of our weather data
import Alamofire
// if you have cocoa pods installed into your app like alamofire, and if you want to use it in your viewcontroller or in your class, you just need to type import nad then the name of that. If error pops her press shift cmd A, shift cmd B

class CurrentWeather{
    
// inside this class we need to create a function that will download all of our weather data, and then it'll set all of these values to the variables here to work the way they are supposed to
    
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName : String {
        if _cityName == nil {
           _cityName = ""
        }
    return _cityName
    }
    var date : String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType : String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp : Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    
    
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete){
    // alamofire download
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        //Alamofire.request(.GET, currentWeatherURL)
        Alamofire.request(currentWeatherURL).responseJSON {
        // we have created this closure inside of the alamofire to handle all the downloads
            //this closure tell that after we have requestd, what's gonna be the response
            response in
            let result = response.result
            //print(result) the result is of string form
            
            if let dict = result.value as? Dictionary<String, AnyObject>{// we are now inside the JSON dictionary
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print("in"+self._cityName)
                    print(self.cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, Any>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    print("in" + self._weatherType)
                        print(self.weatherType)
                    }
                }
                if let main = dict["main"] as? Dictionary<String,Any> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        self._currentTemp = kelvinToFarenheit
                    print("in" + "\(self._currentTemp)")
                        print(self.currentTemp)
                    }
                }
            }
           completed() 
        }
        // now go call this function in the view did load of weatherVC 
        }
    }
