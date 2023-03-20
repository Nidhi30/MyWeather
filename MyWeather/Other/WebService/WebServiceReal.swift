//
//  WebServiceReal.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import Foundation

enum WebServiceError: Error {
case decoding
}

class WebServiceReal: WebService {

    //MARK: - Private Properties -

    private var baseUrlString: String
    private var appId: String

    //MARK: - init -

    init(baseUrlString: String, appId: String) {
        self.baseUrlString = baseUrlString
        self.appId = appId
    }

    //MARK: - Function call -

    func ApiCall<T: Decodable>(path: String, param: [String:Any], completionHandler: @escaping (Result<T, Error>) -> Void) {
        var urlComponents = URLComponents(string: baseUrlString + path)
        let queryItems = param.compactMap { URLQueryItem(name: $0.key, value: $0.value as? String) }
        urlComponents?.queryItems = queryItems

        if let url = urlComponents?.url {

            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Error with fetching weatherData: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                }

                if let data = data,
                   let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                    completionHandler(.success(decodedData))
                } else {
                    completionHandler(.failure(WebServiceError.decoding))
                }
            })
            task.resume()
        }
    }
}
