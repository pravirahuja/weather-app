//
//  ViewController.swift
//  rainyshinycloudy
//
//  Created by pravir on 02/08/17.
//  Copyright © 2017 pravir. All rights reserved.
//

import UIKit
import CoreLocation // it is used to access your device's current location. You can pull it in for just getting the location or you can even use it with an M-K map view or a number of things. Now we'll be getting our location converting the coordinates into the lattitudes and longitudes and then we are going to save them in a singleton class so that we can access it anywhere in our app
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // create a location manager, a location manager is going to be keeping track of where we are and updating our GPS coordinates
    let locationManager = CLLocationManager()
    // create a variable to store our current location
    var currentLocation: CLLocation!
    
    var currentWeather = CurrentWeather()
    
    var forecast: Forecast! //
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // we are requesting the authorisation here
        // may use always authorised or when in use authorised depending upon the requirments and security options. It is used when we want to access the location even when the app is not running like in the google maps, but when in use authorisation works when the app is actually active on screen and in use
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //forecast = Forecast() //

        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // we want our function to run here (& not in viewdidload) because we want to run before we download our weather details. and this function will allow us to run before that
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    
    
    
    // now create a func which will check if we have authorised it, if so it'll run some code else it'll request authorisation and then it'll run that code
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
         // when we are already authorised, we want to get our current location and then we want to download all of the coordinates that we want.
            // instantiate your current location
            currentLocation = locationManager.location
            //after we have got our location we are saving it to our singleton class here using location shared instance, and now our location is accessible from anywhere in our app
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
           //print("")
           print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            currentWeather.downloadWeatherDetails {
                // Setup the UI to load downloaded data
                self.downloadForecastData{
                    self.updateMainUI()
                }
            }
        } else {
            
            let authorizationStatus = CLLocationManager.authorizationStatus()
            // when the app opens and we have not yet authorised it if we are opening it for the very first time it'll provide/open a little popup saying we need your location data to get you weather data and then you can either allow or deny it
            if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
                locationManager.requestWhenInUseAuthorization()
            }else {
                locationAuthStatus()
            }
            // now think about how to save this location data. For that we are gonna use singleton class, uses static variables which can be used throughout our entire app (similar to constants file but is different)
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete){   //
        // here we'll be downloading forecast weather data for TableView
        print("uuuuu")
        print(FORECAST_URL)
        let forecastURL = URL(string: FORECAST_URL)!
        
        Alamofire.request(forecastURL).responseJSON{
            // It is a closure to capture the response from the server
            response in
            let result = response.result // we have the raw data here which we want to pass as a dictionary
            
            if let dict = result.value as? Dictionary<String, Any>{
                
                if let list = dict["list"] as? [Dictionary<String, Any>]{
                    for obj in list {
                        let forecast = Forecast(weatherDict:obj)
                        /*
                         obj is put into weatherDict parameter of init of Forecast
                         we are gonna instantiate our forecast object and we are gonna pass in an object, but we are gonna put it into something called weatherDict (We are basically creating a dictionary that will everytime i parse through and i find a dictionary in my array i am going to run this loop and i am gonna pass in that dictionary into another dictionary.. For every forecast i find i am adding it to another dictionary somewhere else) now create an array forecasts where it'll go*/
                        /* After we create a weather object pulling from this array, we are gonna add it into the following array (forcasts)
                         */
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    // we want to create a cell so that it knows what to recreate all the way down our table view
    // cell for the row which is at index number 'x' OR
    // creating a cell for row number 'x'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // put in the identifier of the table view cell in the string part withIdentifier of the below function
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            // in our weathercell we are passing forecast so we need to tell which forecast to pass at which time
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        }else {
            return WeatherCell()
        }
    }
    
    func updateMainUI(){
        
        //let temp: Double = (currentWeather.currentTemp - 32) * (0.6)
        
        dateLabel.text = currentWeather.date
        print("-->"+currentWeather.date)
        currentTempLabel.text = "\(currentWeather.currentTemp)" //"\(temp)°C"
        print("-->"+"\(currentWeather.currentTemp)")
        currentWeatherTypeLabel.text = currentWeather.weatherType
        print("-->"+currentWeather.weatherType)
        locationLabel.text = currentWeather.cityName
        print("-->"+currentWeather.cityName)
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
        //print()
    }
    
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            locationAuthStatus()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
}

