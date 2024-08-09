import UIKit
import UserNotificationsUI

fileprivate enum Constants {
    static let kCaption: String = "caption"
    static let kSubcaption: String = "subcaption"
    static let kImageUrl: String = "imageUrl"
    static let kActionUrl: String = "actionUrl"
}

@objc public class ContentVC: BaseNotificationContentVC {
    var contentView: UIView = UIView(frame: .zero)
    var pageControl: UIPageControl = UIPageControl(frame: .zero)
    var currentItemView: CaptionImageView = CaptionImageView(frame: .zero)
    var timer: Timer? = nil
    var items = [[String:String]]()
    var itemViews =  [CaptionImageView]()
    var currentItemIndex: Int = 0
    var autoDismiss: Int = 0
    var showPaging: Int = 0
    var autoPlay: Int = 0
    var orientation: String = ConstantKeys.kOrientationLandscape
    var jsonContent: ContentSliderProperties? = nil
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()

        contentView = UIView(frame: view.frame)
        view.addSubview(contentView)
        
        jsonContent = Utiltiy.loadContentData(data: data)
        createView()
    }
    
    func createView() {
        guard let jsonContent = jsonContent else {
            setUpConstraints()
            return
        }
        
        orientation = jsonContent.orientation
        autoDismiss = jsonContent.autoDismiss
        showPaging = jsonContent.showsPaging
        autoPlay = jsonContent.autoPlay

        let dispatchGroup = DispatchGroup()
        for (_,item) in jsonContent.items.enumerated() {
            dispatchGroup.enter()
            Utiltiy.checkImageUrlValid(imageUrl: item.imageUrl) { [weak self] (imageData) in
                DispatchQueue.main.async {
                    if imageData != nil {
                        var title = item.caption
                        if title.isEmpty {
                            title = self!.templateCaption
                        }
                        var subTiltle = item.subcaption
                        if subTiltle.isEmpty {
                            subTiltle = self!.templateSubcaption
                        }
                        var action = item.actionUrl
                        if action.isEmpty {
                            action = self!.deeplinkURL
                        }
                        
                        let itemComponents = CaptionedImageViewComponents(caption: title, subcaption: subTiltle, imageUrl: item.imageUrl, actionUrl: action, bgColor: ConstantKeys.kDefaultColor, captionColor: ConstantKeys.kHexBlackColor, subcaptionColor: ConstantKeys.kHexLightGrayColor)
                        let itemView = CaptionImageView(components: itemComponents)
                        self?.itemViews.append(itemView)
                        
                        let keyItem = [Constants.kCaption : item.caption, Constants.kSubcaption : item.subcaption, Constants.kImageUrl : item.imageUrl, Constants.kActionUrl : item.actionUrl]
                        self?.items.append(keyItem)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.setUpConstraints()
        }
    }
    
    func setUpConstraints() {
        if itemViews.count == 0 {
            // Add default alert view if no image is downloaded.
            createDefaultAlertView()
            createFrameWithoutImage()
        } else {
            createFrameWithImage()
        }

        for subView in itemViews {
            subView.superview?.removeFromSuperview()
        }
        
        currentItemView = itemViews[currentItemIndex]
        contentView.addSubview(currentItemView)
        currentItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            currentItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        if itemViews.count > 1 {
            if (showPaging != 0) {
                pageControl.numberOfPages = itemViews.count
                pageControl.hidesForSinglePage = true
                view.addSubview(pageControl)
                pageControl.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    pageControl.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Utiltiy.getCaptionHeight() + Constraints.kPageControlViewHeight)),
                    pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    pageControl.heightAnchor.constraint(equalToConstant: Constraints.kPageControlViewHeight)
                ])
            }
            if (autoPlay != 0) {
                startAutoPlay()
            } else {
                stopAutoPlay()
            }
        }
    }
    
    func createDefaultAlertView() {
        let itemComponents = CaptionedImageViewComponents(caption: templateCaption, subcaption: templateSubcaption, imageUrl: "", actionUrl: deeplinkURL, bgColor: ConstantKeys.kDefaultColor, captionColor: ConstantKeys.kHexBlackColor, subcaptionColor: ConstantKeys.kHexLightGrayColor)
        let itemView = CaptionImageView(components: itemComponents)
        itemViews.append(itemView)
    }
    
    func createFrameWithoutImage() {
        let viewWidth = view.frame.size.width
        let viewHeight = Utiltiy.getCaptionHeight()
        let frame: CGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.frame = frame
        contentView.frame = frame
        preferredContentSize = CGSize(width: viewWidth, height: viewHeight)
    }
    
    func createFrameWithImage() {
        let viewWidth = view.frame.size.width
        var viewHeight = viewWidth + Utiltiy.getCaptionHeight()

        if orientation == ConstantKeys.kOrientationLandscape  {
            viewHeight = (viewWidth * (Constraints.kLandscapeMultiplier)) + Utiltiy.getCaptionHeight()
        }

        let frame: CGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.frame = frame
        contentView.frame = frame
        preferredContentSize = CGSize(width: viewWidth, height: viewHeight)

    }
    
    
    @objc public override func handleAction(_ action: String) -> UNNotificationContentExtensionResponseOption {
        if action == ConstantKeys.kAction1 {
            // Maps to show previous
            stopAutoPlay()
            showPrevious()
        } else if action == ConstantKeys.kAction2 {
            // Maps to show next
            stopAutoPlay()
            showNext()
        } else if action == ConstantKeys.kAction3 {
            // Maps to run the relevant deeplink
            if itemViews.count > 0 {
                let urlString = itemViews[currentItemIndex].components.actionUrl
                parentNotificationViewController?.userDidPerformAction(ConstantKeys.kOpenedContentUrlAction, withProperties: items[currentItemIndex])
                if let url = URL(string: urlString) {
                    parentNotificationViewController?.openUrl(url)
                }
                return (autoDismiss == 1) ? .dismiss : .doNotDismiss
            }
            return .dismissAndForwardAction
        }
        return .doNotDismiss
    }
    
    @objc func showNext() {
        moveSlider(direction: 1)
    }
    
    func showPrevious() {
        moveSlider(direction: -1)
    }
    
    func moveSlider(direction: Int) {
        guard let _ = parentNotificationViewController else {
            stopAutoPlay()
            return
        }
        currentItemView.removeFromSuperview()

        currentItemIndex = currentItemIndex + direction
        if currentItemIndex >= itemViews.count {
            currentItemIndex = 0
        } else if currentItemIndex < 0 {
            currentItemIndex = itemViews.count - 1
        }

        currentItemView = itemViews[currentItemIndex]
        contentView.addSubview(currentItemView)
        currentItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            currentItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        pageControl.currentPage = currentItemIndex

        parentNotificationViewController?.userDidPerformAction(ConstantKeys.kViewContentItemAction, withProperties: items[currentItemIndex])
    }
    
    func startAutoPlay() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showNext), userInfo: nil, repeats: true)
        }
    }
    
    func stopAutoPlay() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc public override func getDeeplinkUrl() -> String! {
        let deeplink = itemViews[currentItemIndex].components.actionUrl
        return deeplink
    }
}
