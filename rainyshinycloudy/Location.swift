//
//  Location.swift
//  rainyshinycloudy
//
//  Created by pravir on 09/08/17.
//  Copyright © 2017 pravir. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()  // accessible from anywhere in the app, kind of like a global platform
    private init(){}
    
    var latitude: Double!
    var longitude: Double!
// now we are ready to store location data to our singleton class and then we can access it from anywhere


}
