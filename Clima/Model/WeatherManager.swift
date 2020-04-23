//
//  WeatherManager.swift
//  Clima
//
//  Created by Harsh  on 2020-04-16.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ca3da37468bc1466544824628a34fb2a&units=metric"
    
    // apiKey = "ca3da37468bc1466544824628a34fb2a"
    
    func getWeather(_ cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // Task is calling completitonHandler and passing it the inputs if they exist.
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(safeData)
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data){
        
        let decoder = JSONDecoder()
        
        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            print(weatherData.name)
            print(weatherData.main.temp)
            print(weatherData.weather[0].description)
        }
        catch {
            print(error)
        }
    }
}
