import UIKit
import UserNotificationsUI
import WebKit

@objc public class WebVC: BaseNotificationContentVC {
    
    var contentView: UIView = UIView(frame: .zero)
    var jsonContent: WebViewProperties? = nil
    var templateDl1:String = ""
    var webView : WKWebView!
    var webViewUrl: String = ""
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = UIView(frame: view.frame)
        view.addSubview(contentView)
        jsonContent = Utiltiy.loadContentData(data: data)
        createView()
    }
    
    func createFrameWithWebView() {
        let viewWidth = view.frame.size.width
        var viewHeight = (viewWidth * (Constraints.kPortraitMultiplier))
        
        // landscape orientation
        if let orientation = jsonContent?.orientation, orientation == ConstantKeys.kOrientationLandscape  {
            viewHeight = (viewWidth * (Constraints.kLandscapeMultiplier))
        }
        
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.frame = frame
        contentView.frame = frame
        preferredContentSize = CGSize(width: viewWidth, height: viewHeight)
    }
    
    func createView() {
        
        createFrameWithWebView()
        if let payloadURL = jsonContent?.url, !payloadURL.isEmpty {
            webViewUrl = payloadURL
        }
        let url = NSURL(string: webViewUrl)
        let request = NSURLRequest(url: url! as URL)
        // init and load request in webview.
        webView = WKWebView(frame: contentView.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(webView)
        activateWebViewContraints()
        
        guard let jsonContent = jsonContent else {
            return
        }
        if let title = jsonContent.title, !title.isEmpty{
            templateCaption = title
        }
        if let msg = jsonContent.msg, !msg.isEmpty{
            templateSubcaption = msg
        }
        if let msgSummary = jsonContent.msgSummary, !msgSummary.isEmpty{
            templateSubcaption = msgSummary
        }
        if let deeplink = jsonContent.deepLink1, !deeplink.isEmpty{
            deeplinkURL = deeplink
        }
    }
    
    func activateWebViewContraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc public override func handleAction(_ action: String) -> UNNotificationContentExtensionResponseOption {
        if action == ConstantKeys.kAction3 {
            // Maps to run the relevant deeplink
            if !deeplinkURL.isEmpty {
                if let url = URL(string: deeplinkURL) {
                     parentNotificationViewController?.openUrl(url)
                }
            }
            return .dismiss
        }
        return .doNotDismiss
    }
    
    @objc public override func getDeeplinkUrl() -> String! {
        return deeplinkURL
    }
}

//MARK:- WKNavigationDelegate

extension WebVC: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
