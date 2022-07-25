import Foundation

struct PhotoInfoController {
    
    func fetchPhotoInfo(searchDate: String, completion: @escaping (PhotoInfo?) -> Void) {
        // use the URLHelper extension to build up the right URL
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        var query: [String: String] = [
            "api_key" : "DEMO_KEY",
            "date" : ""
        ]
        query["date"] = searchDate
        let url = baseURL.withQueries(query)!
        
        // URLSessions work asynchronously in the background, so we need
        // a closure to actually process their results
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, // only passes if data exists
               let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                // do something with decoded data
                completion(photoInfo)
            }
            else {
                // what if we didn't get data or couldn't decode it?
                print("Couldn't get data for some reason")
                completion(nil)
            }
        }
        task.resume() // We set up the task, but have to actually run it
    }
}
