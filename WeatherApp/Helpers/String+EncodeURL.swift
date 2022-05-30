
import Foundation


extension String {
    
    var encodeURL: String {
        self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
}
