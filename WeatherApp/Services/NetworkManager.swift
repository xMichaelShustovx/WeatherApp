import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func weatherDataRetrieved(data: Data?)
    func cityDataRetrieved(data: Data?)
}

typealias Coordinates = (lat: Double, lon: Double)

class NetworkManager {
    
    // MARK: - Properties
    
    weak var delegate: NetworkManagerDelegate?
    
    private let key = "e1283dabf5c45524ed415d0ffe8420cb"
    
    // MARK: - Public Methods
    
    func fetchWeatherData(coordinates: Coordinates) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.lat)&lon=\(coordinates.lon)&exclude=minutely,hourly,alerts&units=metric&appid=\(key)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil, data != nil {
                self.delegate?.weatherDataRetrieved(data: data)
            }
            else {
                print("Couldn't retrieve weather data")
                self.delegate?.weatherDataRetrieved(data: nil)
            }
        }
        dataTask.resume()
    }
    
    func fetchCityData(city: String) {
        
        guard let url = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(key)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil, data != nil {
                self.delegate?.cityDataRetrieved(data: data)
            }
            else {
                print("Couldn't retrieve city location")
                self.delegate?.cityDataRetrieved(data: nil)
            }
        }
        dataTask.resume()
    }
}
