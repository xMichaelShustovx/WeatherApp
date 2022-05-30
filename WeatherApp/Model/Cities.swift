
struct CityData: Decodable, Hashable {
    var name: String
    var coord: Coordinate
    
    static func == (lhs: CityData, rhs: CityData) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct Coordinate: Decodable {
    var lat: Double
    var lon: Double
}
