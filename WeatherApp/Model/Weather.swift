import Foundation
import UIKit

struct City: Decodable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
}

struct Weather: Decodable {
    var timezone: String
    var current: CurrentWeather
    var daily: [WeatherForecast]
}

struct CurrentWeather: Decodable {
    var dt: Double
    var temp: Double
    var pressure: Double
    var humidity: Double
    var weather: [WeatherDescription]
}

struct WeatherForecast: Decodable {
    var dt: Double
    var temp: Temperature
    var pressure: Double
    var humidity: Double
    var weather: [WeatherDescription]
}

struct Temperature: Decodable {
    var day: Double
}

struct WeatherDescription: Decodable {
    var main: String
    var icon: String
}
