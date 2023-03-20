//
//  Constants.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import Foundation

/// AppConstant to get static infromation via constant
///
struct Constants {
    struct Keys {
        static let lat = "lat"
        static let city = "city"
        static let long = "long"
    }
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let imageBaseUrl = "https://openweathermap.org/img/wn/"
    static let imageBaseUrlEndPoint = "@2x.png"
    static let appId = Bundle.main.infoDictionary?["appid"] as? String ?? ""
    static let googleAPIKey = "AIzaSyAeq3zQL9pwL_eTVFgshuudvKtmCUbg7o4"
}
