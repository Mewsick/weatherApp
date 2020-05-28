//
//  SelectedWeatherViewController.swift
//  Labb_1
//
//  Created by Eric Johansson on 2020-02-18.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class SelectedWeatherViewController: UIViewController {

    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLable: UILabel!
    @IBOutlet weak var windSpeedLable: UILabel!
    @IBOutlet weak var weatherAdviceLable: UILabel!
    var currentCity = ""
    
    var snap : UISnapBehavior!
    var animator : UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weather_API = weatherAPI()
        weather_API.getWeather(searchInput: currentCity.replacingOccurrences(of: "Ö", with: "O").replacingOccurrences(of: "ö", with: "oe").replacingOccurrences(of: "Ä", with: "A").replacingOccurrences(of: "ä", with: "a").replacingOccurrences(of: "Å", with: "A").replacingOccurrences(of: "å", with: "a")) { (result) in
           switch result {
                case .success(let displayWeather):
                DispatchQueue.main.async {
                    self.cityNameLable.text = self.currentCity
                    self.tempLabel.text = "Temperature: " + displayWeather.main.temp.toString() + "°"
                    self.windSpeedLable.text = "Wind speed: " + displayWeather.wind.speed.toString() + " m/s"
                    self.weatherLable.text = displayWeather.weather[0].description
                    self.weatherAdviceLable.text = self.clothingAdvice(temp: displayWeather.main.temp, windSpeed: displayWeather.wind.speed)
                }
                case .failure(let error): print("Error \(error)")
           }
       }
        
        animator = UIDynamicAnimator(referenceView: self.view)
        cityNameLable.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 5)
        snap = UISnapBehavior(item: cityNameLable, snapTo: cityNameLable.center)
        snap.damping = 0.04
        animator.addBehavior(snap)
    }
    
    func clothingAdvice(temp: Double, windSpeed: Double) -> String{
        var advice = "Wear "
        
        if (temp >= 8){
            advice += "cooler clothes and "
        }else{
            advice += "warmer clothes and "
        }
        
        switch windSpeed {
        case 7...:
          advice += "windstopper!"
        case ...7:
          advice += "a fishing net!"
        default:
        advice = ""
        }
        
        return advice
    }
}


