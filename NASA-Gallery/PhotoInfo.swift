import Foundation

struct PhotoInfo: Codable {
    
    var title: String
    var explanation: String
    var url: URL
    var copyright: String?
    
    enum Keys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: Keys.self)
        self.title = try valueContainer.decode(String.self, forKey: .title)
        self.explanation = try valueContainer.decode(String.self, forKey: .description)
        self.url = try valueContainer.decode(URL.self, forKey: .url)
        self.copyright = try? valueContainer.decode(String.self, forKey: .copyright)
        if self.copyright == nil{
            self.copyright = "none"
        }
    }
}
