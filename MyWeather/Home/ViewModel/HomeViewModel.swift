//
//  HomeViewModel.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import Foundation
import CoreLocation
import GooglePlaces

class HomeViewModel {

    //MARK: - Properties -

    /// Private properties

    private let weatherService: WeatherService
    private let currentLocation: CLLocation

    ///  general properties
    var onError: ((String, String) -> Void)?
    var weatherData: WeatherResponseData?
    var onData: ((WeatherResponseData) -> Void)?
    var locality = ""

    //MARK: - Init -

    init(service: WeatherService, currentLocation: CLLocation) {
        weatherService = service
        self.currentLocation = currentLocation
    }

    //MARK: - Function Calls -

    /// apicall integration for get wetherdata based on lat long

    func getLocalWeather() {
        weatherService.featchWeatherWithLocation(location: currentLocation) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.weatherData = weatherData
                self?.onData?(weatherData)
            case .failure(let error):
                self?.onError?(NSLocalizedString("Error", comment: ""), error.localizedDescription)
            }
        }
    }

    /// apicall integration for get wetherdata by city name

    func getWeatherForCity(city: String) {
        weatherService.featchWeatherWithCity(city: city) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.weatherData = weatherData
                self?.locality = city
                guard let lati = weatherData.coord?.lat else { return }
                guard let long = weatherData.coord?.lon else { return }
                self?.storeSearchCityToDefaults(city: city, lat: lati, long: long)
                self?.onData?(weatherData)
            case .failure(let error):
                self?.onError?(NSLocalizedString("Error", comment: ""), error.localizedDescription)
            }
        }
    }

    ///  Api Call for get wether data based on cityName serched in autoComplete via reverseGeocode

    func getLocalCityName() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) in
            if let error = error {
                self.onError?(NSLocalizedString("Error", comment: ""), error.localizedDescription)
            }

            if placemarks?.isEmpty == false {
                let placemarks = placemarks?[0]
                if let locality = placemarks?.locality {
                    self.locality = locality
                }
            }
        })
        getLocalWeather()
    }

    ///  Store data to defaults for last serched city

    func storeSearchCityToDefaults(city: String, lat: Double, long: Double) {
        let defaults = UserDefaults.standard
        defaults.set(city, forKey: Constants.Keys.city)
        defaults.set(lat, forKey: Constants.Keys.lat)
        defaults.set(long, forKey: Constants.Keys.long)
        defaults.synchronize()
    }
}


