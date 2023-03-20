//
//  WeatherServiceReal.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import Foundation
import CoreLocation

class WeatherServiceReal: WeatherService {
    private let webService: WebService

    init(webService: WebService) {
        self.webService = webService
    }

    func featchWeatherWithLocation(location: CLLocation, completion: @escaping (Result<WeatherResponseData, Error>) -> Void) {
        webService.ApiCall(path: "weather", param: ["lat" : "\(location.coordinate.latitude)", "lon" : "\(location.coordinate.longitude)", "appid": Constants.appId], completionHandler: completion)
    }

    func featchWeatherWithCity(city: String, completion: @escaping (Result<WeatherResponseData, Error>) -> Void) {
        webService.ApiCall(path: "weather", param: ["q": city, "appid": Constants.appId], completionHandler: completion)
    }
}
