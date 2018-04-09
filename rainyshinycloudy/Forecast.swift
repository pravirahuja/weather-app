//
//  Forecast.swift
//  rainyshinycloudy
//
//  Created by pravir on 08/08/17.
//  Copyright © 2017 pravir. All rights reserved.
//

// it is a new swift file not a cocoa touch class
import UIKit
//import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    // let's ensre that the above variables are nice and safe. We are gonna create functions that'll basically look to, if one of the above values comes back as empty or nil, it'll basically set it/ instantiate to an empty sring 
    
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }

    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    // now go back to weatherVC and download all the forecast data from this view controller because we have to update our table view, so it makes sense to download it within the same table view, so we can just pass that data straight in 
    
    init(weatherDict: Dictionary<String, Any>){
        if let temp = weatherDict["temp"] as? Dictionary<String, Any>{
            if let min = temp["min"] as? Double{
                //if let currentemperature
                    let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                    let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                    self._lowTemp = "\(kelvinToFarenheit)"
            }
            if let max = temp["max"] as? Double{
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                self._highTemp = "\(kelvinToFarenheit)"
            }
        }
        if let weather = weatherDict["weather"] as? [Dictionary<String, Any>]{
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        if let date = weatherDict["dt"] as? Double {
            // convert the date in the form of unix time stamp into the required form
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    }
}

// this extension is going to allow us to actually get the day of the week from the date, and then we'll be able to type the day of the week
// this extension will remove everything from the date except the day of the week
extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // this is the code that tells that I want the full name of the day of the week
        
        return dateFormatter.string(from: self) // this self is used because we are getting the date in this view controller & not somewhere else
    }
}
