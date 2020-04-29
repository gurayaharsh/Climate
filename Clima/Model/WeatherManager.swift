//
//  WeatherManager.swift
//  Clima
//
//  Created by Harsh  on 2020-04-16.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ca3da37468bc1466544824628a34fb2a&units=metric"
    
    
    func getWeatherByCity(_ cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func getWeatherByCoord(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees){
         let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
               performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // Task is calling completitonHandler and passing it the inputs if they exist.
                
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weatherDisplay = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weatherDisplay)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> WeatherDisplay?{
        
        let decoder = JSONDecoder()
        
        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            let id = weatherData.weather[0].id
            let name = weatherData.name
            let temp = weatherData.main.temp
           
            
            let weatherDisplay = WeatherDisplay(conditionID: id, cityName: name, temperature: temp)
            
            return weatherDisplay
        }
        catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}
