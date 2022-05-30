import Foundation

class JSONParseManager {
    
    static func parseWeatherData(_ data: Data?) -> Weather? {
        
        guard let data = data else { return nil }

        do {
            let result = try JSONDecoder().decode(Weather.self, from: data)
            return result
        }
        catch {
            print(error.localizedDescription)
            print("Couldn't parse weather data")
            return nil
        }
    }
    
    static func parseCityData(_ data: Data?) -> City? {
        
        guard let data = data else { return nil }

        
        do {
            let result = try JSONDecoder().decode([City].self, from: data)
            guard result.count > 0 else { return nil }
            return result.first
        }
        catch {
            print(error.localizedDescription)
            print("Couldn't parse city data")
            return nil
        }
    }
    
    static func getCitiesList() -> [CityData]? {
        let url = Bundle.main.url(forResource: "citylist", withExtension: "json")
        guard let url = url else { return nil }
        do {
            let data = try Data(contentsOf: url)
            var result = try JSONDecoder().decode([CityData].self, from: data)
            result = Array(Set(result))
            result.sort { c1, c2 in
                c1.name > c2.name
            }
            return result
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
