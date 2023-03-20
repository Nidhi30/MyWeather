//
//  Sys.swift
//  MyWeather
//
//  Created by nidhi.lalani on 18/03/23.
//

import Foundation
struct Sys : Codable {
	let country : String?
	let sunrise : Int?
	let sunset : Int?

	enum CodingKeys: String, CodingKey {

		case country = "country"
		case sunrise = "sunrise"
		case sunset = "sunset"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
	}

}
