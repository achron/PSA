@objc public class Utiltiy: NSObject {
    static func checkImageUrlValid(imageUrl: String, completionBlock: @escaping (UIImage?) -> Void) -> Void {
        if let url = URL(string: imageUrl) {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    // Invalid url or error in loading url.
                    completionBlock(nil)
                    return
                }
                guard let imageData = UIImage(data: data) else {
                    // Image can't be loaded from url.
                    completionBlock(nil)
                    return
                }
                
                // Image url is valid.
                completionBlock(imageData)
            }
            dataTask.resume()
        } else {
            // Image url is empty.
            completionBlock(nil)
        }
    }
    
    static func webViewURLReachable(webViewURL: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: webViewURL){
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            URLSession.shared.dataTask(with: request) { _, response, _ in
                completion((response as? HTTPURLResponse)?.statusCode == 200)
            }.resume()
        }
    }
    
    static func getCaptionHeight() -> CGFloat {
        return Constraints.kCaptionHeight + Constraints.kSubCaptionHeight + Constraints.kBottomPadding
    }
    static func height(withConstrainedWidth width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 12.0),text: String = "") -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    static func  getCaptionHeight(subCaption:String,width:CGFloat,font:UIFont = UIFont.systemFont(ofSize: 12.0)) -> CGFloat{
        return Constraints.kCaptionHeight + self.height(withConstrainedWidth: width, font: font, text: subCaption) + Constraints.kBottomPadding
    }
    
    // Decoding data
    static func loadContentData<T>(data:String)->T? where T:Decodable{
        var jsonContent: T? = nil
        if let configData = data.data(using: .utf8) {
            do {
                jsonContent = try JSONDecoder().decode(T.self, from: configData)
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
                jsonContent = nil
            }
        }
        return jsonContent
    }
    
    // Required keys check for product display template
    @objc public static func isRequiredKeysProvided(jsonString: String)->Bool{
        if #available(iOS 12.0, *) {
            let jsonContent: ProductDisplayProperties? = Utiltiy.loadContentData(data: jsonString)
            if ( jsonContent?.img1 == nil || jsonContent?.img2 == nil || jsonContent?.btnTitle1 == nil || jsonContent?.btnTitle2 == nil || jsonContent?.btnSubTitle1 == nil || jsonContent?.btnSubTitle2 == nil || jsonContent?.deepLink1 == nil || jsonContent?.deepLink2 == nil || jsonContent?.price1 == nil || jsonContent?.price2 == nil || jsonContent?.actionTitle == nil){
                return false
            }else{
                return true
            }
        }else{
            return false
        }        
    }
    
    //Get controller type between vertical and linear, for product display template
    @objc public static func getControllerType(jsonString: String) -> BaseNotificationContentVC{
        let jsonContent: ProductDisplayProperties? = Utiltiy.loadContentData(data: jsonString)
        if (jsonContent?.linearDislay != nil){
                if
                    ((jsonContent?.linearDislay?.localizedCaseInsensitiveContains("true"))!) {
                let contentController: ProductDisplayLVC = ProductDisplayLVC()
//                    contentController.data = jsonString
                    contentController.jsonContent = jsonContent
                    return contentController
                }else{
                    let contentController: ProductDisplayVC =
                    ProductDisplayVC()
//                    contentController.data = jsonString
                    contentController.jsonContent = jsonContent
                    return contentController
                }
        }else{
            let contentController: ProductDisplayVC = ProductDisplayVC()
//                contentController.data = jsonString
            contentController.jsonContent = jsonContent
            return contentController
        }
    }
}
