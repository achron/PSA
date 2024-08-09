import UIKit
import UserNotificationsUI

@objc public class CarouselVC: BaseNotificationContentVC {
    var contentView: UIView = UIView(frame: .zero)
    var pageControl: UIPageControl = UIPageControl(frame: .zero)
    var currentItemView: CaptionImageView = CaptionImageView(frame: .zero)
    var timer: Timer? = nil
    var itemViews =  [CaptionImageView]()
    var currentItemIndex: Int = 0

    var bgColor: String = ConstantKeys.kDefaultColor
    var captionColor: String = ConstantKeys.kHexBlackColor
    var subcaptionColor: String = ConstantKeys.kHexLightGrayColor
    var jsonContent: CarouselProperties? = nil
    var nextButtonImage: UIImage = UIImage()
    var previousButtonImage: UIImage = UIImage()
    var nextButton: UIButton = UIButton(frame: .zero)
    var previousButton: UIButton = UIButton(frame: .zero)
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()

        contentView = UIView(frame: view.frame)
        view.addSubview(contentView)

        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(openDeeplink))
        contentView.addGestureRecognizer(recognizer1)
        
        jsonContent = Utiltiy.loadContentData(data: data)
        createView()
    }
    
    func createView() {
        guard let jsonContent = jsonContent else {
            // Show default alert view and update constraints when json data is not available.
            setUpConstraints()
            return
        }

        if let title = jsonContent.title, !title.isEmpty {
            templateCaption = title
        }
        if let msg = jsonContent.msg, !msg.isEmpty {
            templateSubcaption = msg
        }
        if let msgSummary = jsonContent.msgSummary, !msgSummary.isEmpty {
            templateSubcaption = msgSummary
        }
        if let bg = jsonContent.bgClr, !bg.isEmpty {
            bgColor = bg
        }
        if let titleColor = jsonContent.titleClr, !titleColor.isEmpty {
            captionColor = titleColor
        }
        if let msgColor = jsonContent.msgClr, !msgColor.isEmpty {
            subcaptionColor = msgColor
        }
        var actionUrl = deeplinkURL
        if let deeplink = jsonContent.deepLink1, !deeplink.isEmpty {
            actionUrl = deeplink
        }
        deeplinkURL = actionUrl

        if templateType == TemplateConstants.kTemplateBasic {
            var basicImageUrl = ""
            if let url = jsonContent.largeImg, !url.isEmpty {
                basicImageUrl = url
            }else if isFromProductDisplay{
                //case for handling image data for product display
                if let url = jsonContent.img1, !url.isEmpty {
                    basicImageUrl = url
                }else if let url = jsonContent.img2, !url.isEmpty {
                    basicImageUrl = url
                }else if let url = jsonContent.img3, !url.isEmpty {
                    basicImageUrl = url
                }
            }

            Utiltiy.checkImageUrlValid(imageUrl: basicImageUrl) { [weak self] (imageData) in
                DispatchQueue.main.async {
                    if imageData != nil {
                        let itemComponents = CaptionedImageViewComponents(caption: self!.templateCaption, subcaption: self!.templateSubcaption, imageUrl: basicImageUrl, actionUrl: actionUrl, bgColor: self!.bgColor, captionColor: self!.captionColor, subcaptionColor: self!.subcaptionColor)
                        let itemView = CaptionImageView(components: itemComponents)
                        self?.itemViews.append(itemView)
                    }
                    self?.setUpConstraints()
                }
            }
        } else if templateType == TemplateConstants.kTemplateAutoCarousel || templateType == TemplateConstants.kTemplateManualCarousel {
            // Add non empty image urls.
            var imageUrls = [String]()
            if let url = jsonContent.img1, !url.isEmpty {
                imageUrls.append(url)
            }
            if let url = jsonContent.img2, !url.isEmpty {
                imageUrls.append(url)
            }
            if let url = jsonContent.img3, !url.isEmpty {
                imageUrls.append(url)
            }
            
            let dispatchGroup = DispatchGroup()
            for (_,url) in imageUrls.enumerated() {
                dispatchGroup.enter()
                Utiltiy.checkImageUrlValid(imageUrl: url) { [weak self] (imageData) in
                    DispatchQueue.main.async {
                        if imageData != nil {
                            let itemComponents = CaptionedImageViewComponents(caption: self!.templateCaption, subcaption: self!.templateSubcaption, imageUrl: url, actionUrl: actionUrl, bgColor: self!.bgColor, captionColor: self!.captionColor, subcaptionColor: self!.subcaptionColor)
                            let itemView = CaptionImageView(components: itemComponents)
                            self?.itemViews.append(itemView)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.setUpConstraints()
            }
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

        // Show other view elements if image downloaded is more than 1
        if itemViews.count > 1 {
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
            
            if templateType == TemplateConstants.kTemplateAutoCarousel {
                startAutoPlay()
            } else if templateType == TemplateConstants.kTemplateManualCarousel {
                // TODO: Unhide buttons when user interaction will be added.
//                nextButton.isHidden = true
//                previousButton.isHidden = true

                
                // Show Next and Previous button for manual carousel.
                nextButtonImage = UIImage(named: "nextButton") ?? UIImage()
                nextButton.setImage(nextButtonImage, for: .normal)
                nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
                previousButtonImage = UIImage(named: "previousButton") ?? UIImage()
                previousButton.setImage(previousButtonImage, for: .normal)
                previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

                contentView.addSubview(nextButton)
                contentView.addSubview(previousButton)
                nextButton.translatesAutoresizingMaskIntoConstraints = false
                previousButton.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    nextButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100.0),
                    nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
                    nextButton.heightAnchor.constraint(equalToConstant: 40.0),
                    nextButton.widthAnchor.constraint(equalToConstant: 40.0),

                    previousButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100.0),
                    previousButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
                    previousButton.heightAnchor.constraint(equalToConstant: 40.0),
                    previousButton.widthAnchor.constraint(equalToConstant: 40.0)
                ])
                contentView.bringSubviewToFront(nextButton)
                contentView.bringSubviewToFront(previousButton)
            }
        }
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
        // For view in Landscape
        viewHeight = (viewWidth * (Constraints.kLandscapeMultiplier)) + Utiltiy.getCaptionHeight()

        let frame: CGRect = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.frame = frame
        contentView.frame = frame
        preferredContentSize = CGSize(width: viewWidth, height: viewHeight)
    }
    
    func createDefaultAlertView() {
        let itemComponents = CaptionedImageViewComponents(caption: templateCaption, subcaption: templateSubcaption, imageUrl: "", actionUrl: deeplinkURL, bgColor: bgColor, captionColor: captionColor, subcaptionColor: subcaptionColor)
        let itemView = CaptionImageView(components: itemComponents)
        itemViews.append(itemView)
    }
    
    @objc func nextButtonTapped() {
        showNext()
    }
    
    @objc func previousButtonTapped() {
        showPrevious()
    }

    @objc func openDeeplink() {
        let urlString = itemViews[currentItemIndex].components.actionUrl
        if !urlString.isEmpty {
            if let url = URL(string: urlString) {
                parentNotificationViewController?.openUrl(url)
            }
        }
        else {
            if #available(iOS 12.0, *) {
                self.extensionContext?.performNotificationDefaultAction()
            }
        }
    }
    
    @objc public override func handleAction(_ action: String) -> UNNotificationContentExtensionResponseOption {
        if action == ConstantKeys.kAction1 {
            // Maps to show previous
            if templateType == TemplateConstants.kTemplateManualCarousel {
                showPrevious()
            }
        } else if action == ConstantKeys.kAction2 {
            // Maps to show next
            if templateType == TemplateConstants.kTemplateManualCarousel {
                showNext()
            }
        } else if action == ConstantKeys.kAction3 {
            // Maps to run the relevant deeplink
            if itemViews.count > 0 {
                let urlString = itemViews[currentItemIndex].components.actionUrl
                if !urlString.isEmpty {
                    if let url = URL(string: urlString) {
                        parentNotificationViewController?.openUrl(url)
                    }
                }
                return .dismiss
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
        guard let _ =  parentNotificationViewController else {
            timer?.invalidate()
            timer = nil
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
        if templateType == TemplateConstants.kTemplateManualCarousel {
            contentView.bringSubviewToFront(nextButton)
            contentView.bringSubviewToFront(previousButton)
        }
    }
    
    func startAutoPlay() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showNext), userInfo: nil, repeats: true)
        }
    }
    
    @objc public override func getDeeplinkUrl() -> String! {
        let deeplink = itemViews[currentItemIndex].components.actionUrl
        return deeplink
    }
}
