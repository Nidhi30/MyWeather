//
//  NetworkManager.swift
//  MyWeather
//
//  Created by nidhi.lalani on 18/03/23.
//

import Foundation

protocol WebService {
    func ApiCall<T: Decodable>(
        path: String,
        param: [String:Any],
        completionHandler: @escaping (Result<T, Error>) -> Void
    )
}
