import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageCopyright: UILabel!
    @IBOutlet weak var imageDescription: UITextView!
    @IBOutlet weak var selectedDate: UIDatePicker!
    
    let photoInfoController = PhotoInfoController()
    
    // loaded view
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let dFormatted = dFormatter(d: date)
        self.fetchApiInfo(date: dFormatted)
    }
    
    // returns date in format for api
    func dFormatter(d: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: d)
        return date
    }
    
    // when a new date in selected in date picker
    @IBAction func newDate(_ sender: Any) {
        let currentDate = Date()
        if currentDate < selectedDate.date {
             return
        }
        let dFormatted = dFormatter(d: selectedDate.date)
        fetchApiInfo(date: dFormatted)
    }
    
    // fetches api info with a certian date
    func fetchApiInfo(date: String){
        
        imageDescription.text = ""
        imageCopyright.text = ""
        imageTitle.text = "Loading"
    
        photoInfoController.fetchPhotoInfo(searchDate: date, completion: { (photoInfo) in
            
            if photoInfo == nil{
                let alertController = UIAlertController(title: "Error", message:
                        "Wasnt able to get request from api", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            
            if let photoInfo = photoInfo {  // only if we get photo info
  
                DispatchQueue.main.async {
                    
                    // you have to refer to local properties as self.whatever
                    // inside a closure.
                    self.imageTitle.text = photoInfo.title
                    self.imageDescription.text = photoInfo.explanation
                    if let copyright = photoInfo.copyright {
                        self.imageCopyright.text = "Copyright \(copyright)"
                    } else {
                        self.imageCopyright.isHidden = true
                    }
                    let url = photoInfo.url.absoluteString
                    self.setImage (url: url )
                }
            }
        })
    }

    // get the image from the url retunred by the api and display the image
    func setImage( url: String) {
        
        // force url to be https
        let http = URL(string: url)!
        var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        let https = comps.url!

        // try to convert
        guard let imageURL = URL(string: https.absoluteString)
        else {
            let alertController = UIAlertController(title: "Error", message:
                    "Couldnt get image", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        // try to get content
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL)
            else {
                let alertController = UIAlertController(title: "Error", message:
                        "Couldnt get image", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }

            // set image
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
}



