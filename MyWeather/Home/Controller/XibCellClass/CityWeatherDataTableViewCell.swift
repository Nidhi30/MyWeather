//
//  CityWeatherDataTableViewCell.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import UIKit
import SDWebImage

class CityWeatherDataTableViewCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblAtmosphere: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var imgAtmosphere: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!

    //MARK: - Properties -

    static let identifire = "CityWeatherDataTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Function calls -

    static func nib() -> UINib {
        return UINib(nibName: "CityWeatherDataTableViewCell", bundle: nil)
    }

    /// function to set data in tableview cell

    func updateCityWeatherData(weatherData: WeatherResponseData) {
        if let weather = weatherData.weather {
            if weather.count > 0 {
                let wetherInfo = weather[0]
                if let data = wetherInfo.main {
                    lblAtmosphere.text = data
                }
                if let img = wetherInfo.icon {
                    let imgUrl = URL(string: Constants.imageBaseUrl + img + Constants.imageBaseUrlEndPoint)
                    imgAtmosphere.sd_setImage(with: imgUrl)
                }
            }
        }
        if let temprature = weatherData.main?.temp {
            let temp =  (temprature - 273.15) * 1.8 + 32
            lblTemprature.text = String(format: "%.2f", temp) + " °F"
        }

        if let date = weatherData.dt {
            let timeinterval = TimeInterval(date)
            let timeStamp = Date(timeIntervalSince1970:timeinterval)
            let dateFormatter = DateFormatter()
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            let string = dateFormatter.string(from: timeStamp)
            lblDateTime.text = String(describing: string)
        }
    }
}
