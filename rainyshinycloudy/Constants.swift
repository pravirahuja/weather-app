//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by pravir on 07/08/17.
//  Copyright © 2017 pravir. All rights reserved.
//

import Foundation
// think about how are we gonna store the URL, as we need to put in information inside this URL

let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "e69b7d858bdebf4002d2e5eaf851981a"
//lat=35   28.7041   -36
//&lon=139  77.1025   123
//&appid=

// This is going to tell our function in currentweather.swift class when we are finished downloading
typealias DownloadComplete = () -> ()



//let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"


let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=e69b7d858bdebf4002d2e5eaf851981a"




//let FORECAST_URL = "http://samples.openweathermap.org/data/2.5/forecast/daily?zip=94040&appid=b1b15e88fa797225412429c1c50c122a1"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=e69b7d858bdebf4002d2e5eaf851981a"

//  Location.sharedInstance.longitude and Location.sharedInstance.latitude are optional in nature so while using them in the FORECAST_URL we need to make them ! unwrap them or make them of not nil type.
