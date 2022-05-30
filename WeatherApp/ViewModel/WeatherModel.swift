
import Foundation
import CoreLocation


protocol WeatherModelProtocol: AnyObject {
    func cityRetrieved(city: City?)
    func weatherRetrieved(weather: Weather?)
    func locationTrackingDenied()
}

class WeatherModel: NSObject, NetworkManagerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    var city: City? {
        didSet {
            guard let city = city else { return }
            if weather == nil {
                getWeatherUsingLocation(location: (city.lat, city.lon))
            }
        }
    }
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            if city == nil {
                var cityName = weather.timezone
                guard let index = cityName.firstIndex(of: "/") else { return }
                cityName.removeSubrange(...index)
                networkManager.fetchCityData(city: cityName)
            }
        }
    }
    
    let cities = JSONParseManager.getCitiesList()
    
    weak var delegate: WeatherModelProtocol?
    
    let networkManager = NetworkManager()
    var locationManager: CLLocationManager?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        networkManager.delegate = self
    }
    
    // MARK: - Public Methods
    
    func getWeatherUsingUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func getWeatherUsingLocation(location: Coordinates) {
        networkManager.fetchWeatherData(coordinates: location)
    }
    
    func getWeatherUsingCityName(_ name: String) {
        networkManager.fetchCityData(city: name)
    }
    
    // MARK: - NetworkManagerDelegate Methods
    
    func weatherDataRetrieved(data: Data?) {
        
        let weather = JSONParseManager.parseWeatherData(data)
        
        if let weather = weather {
            delegate?.weatherRetrieved(weather: weather)
            self.weather = weather
        }
        else {
            delegate?.weatherRetrieved(weather: nil)
            self.weather = nil
        }
    }
    
    func cityDataRetrieved(data: Data?) {
        
        let city = JSONParseManager.parseCityData(data)
        
        if let city = city {
            delegate?.cityRetrieved(city: city)
            self.city = city
        }
        else {
            delegate?.cityRetrieved(city: nil)
            self.city = nil
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let currentCoordinates: Coordinates = (Double(location?.coordinate.latitude ?? 0), Double(location?.coordinate.longitude ?? 0))
        networkManager.fetchWeatherData(coordinates: currentCoordinates)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied ||
            manager.authorizationStatus == .restricted {
            delegate?.locationTrackingDenied()
        }
        else {
            locationManager?.startUpdatingLocation()
        }
    }
}
