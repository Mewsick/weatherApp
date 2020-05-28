//
//  weatherProperties.swift
//  Labb_1
//
//  Created by Eric Johansson on 2020-02-14.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import Foundation

struct city: Decodable {
    let name : String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
}

struct Wind: Decodable{
    let speed: Double
    let deg: Int
}

struct Weather: Decodable {
    let description: String
}


extension Double {
    func toString() -> String {
        return String(format: "%.1f", self)
    }
}
