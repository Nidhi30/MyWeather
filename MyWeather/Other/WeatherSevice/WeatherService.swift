//
//  WeatherService.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import Foundation
import CoreLocation

protocol WeatherService {

    ///  function to featchdata with location argument to featch location from coordinates

    func featchWeatherWithLocation
    (
        location: CLLocation,
        completion: @escaping (Result<WeatherResponseData, Error>) -> Void
    )

    /// function to featchdata with cityname argument to featch location from city

    func featchWeatherWithCity
    (
        city: String,
        completion: @escaping (Result<WeatherResponseData, Error>) -> Void
    )
}
