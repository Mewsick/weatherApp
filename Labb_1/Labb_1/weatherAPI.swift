//
//  weatherAPI.swift
//  Labb_1
//
//  Created by Eric Johansson on 2020-02-14.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import Foundation

struct weatherAPI{
    
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?q="
    let APIKey: String = "&appid=" + "59b650ca1bfad13ee548f24a8c9be0e7&units=metric"
    
    func getWeather(searchInput: String, completion: @escaping(Result < city, Error>) -> Void){
        
        let newSearchInput = searchInput.replacingOccurrences(of: "Ö", with: "O").replacingOccurrences(of: "ö", with: "o").replacingOccurrences(of: "Ä", with: "A").replacingOccurrences(of: "ä", with: "a").replacingOccurrences(of: "Å", with: "A").replacingOccurrences(of: "å", with: "a")
        let completeURL: String = baseURL + newSearchInput + APIKey
        guard let url: URL = URL(string: completeURL) else {return}
        print("creating request")
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            if let unwrappedError = error{
                print("Nått gick fel. Error: \(unwrappedError)")
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                print("We got data! \(String(data: unwrappedData, encoding: String.Encoding.utf8) ?? "No data")")
                print(newSearchInput)
                do {
                    let decoder = JSONDecoder()
                    let weatherCity: city = try decoder.decode(city.self, from: unwrappedData)
                    print("city: \(weatherCity.name)")
                    print("temperature: \(weatherCity.main.temp)")
                    completion(.success(weatherCity))
                } catch {
                    print("Couldn't parse JSON... either bad connection or database could not handle Å, Ä or Ö ")
                }
            }
        }
        task.resume()
        print("Task started")
    }
}
        

