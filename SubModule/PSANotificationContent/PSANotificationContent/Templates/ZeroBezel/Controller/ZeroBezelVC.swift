//
//  ZeroBezelVC.swift
//  CTNotificationContent
//
//  Created by Aishwarya Nanna on 23/08/22.
//

import UIKit
import UserNotificationsUI

@objc public class ZeroBezelVC: BaseNotificationContentVC {

    var contentView: UIView = UIView(frame: .zero)
    var jsonContent: ZeroBezelProperties? = nil
    var templateBigImage:String = ""
    var templateDl1:String = ""
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    private var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textAlignment = .left
        subTitleLabel.adjustsFontSizeToFitWidth = false
        subTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
        subTitleLabel.textColor = UIColor.lightGray
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subTitleLabel
    }()
    private var bigImageView: UIImageView = {
        let bigImageView = UIImageView()
        bigImageView.contentMode = .scaleAspectFill
        bigImageView.layer.masksToBounds = true
        bigImageView.translatesAutoresizingMaskIntoConstraints = false
        return bigImageView
    }()
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        contentView = UIView(frame: view.frame)
        view.addSubview(contentView)
        
        jsonContent = Utiltiy.loadContentData(data: data)
        createView()
        setupConstraints()
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
    
    func createView() {
        createFrameWithoutImage()
        contentView.addSubview(bigImageView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(titleLabel)
        
        guard let jsonContent = jsonContent else {
            return
        }
        
        if let title = jsonContent.title, !title.isEmpty{
            templateCaption = title
        }
        if let msg = jsonContent.msg, !msg.isEmpty{
            templateSubcaption = msg
        }
        if let msgSummary = jsonContent.subtitle, !msgSummary.isEmpty{
            templateSubcaption = msgSummary
        }
        if let deeplink = jsonContent.deepLink1, !deeplink.isEmpty{
            deeplinkURL = deeplink
        }
        if let bigImage = jsonContent.largeImg, !bigImage.isEmpty{
            templateBigImage = bigImage
        }
        
        self.titleLabel.text = templateCaption
        self.subTitleLabel.text = templateSubcaption
    
        if let bigImg = jsonContent.largeImg{
            Utiltiy.checkImageUrlValid(imageUrl: bigImg) { [weak self] (imageData) in
                DispatchQueue.main.async {
                    if imageData != nil {
                        self?.bigImageView.image = imageData
                        self?.activateImageViewContraints()
                        self?.createFrameWithImage()
                    }
                }
            }
        }
        
        if let titleColor = jsonContent.titleClr {
            self.titleLabel.textColor = UIColor(hex: titleColor)
        }
        if let msgColor = jsonContent.msgClr {
            self.subTitleLabel.textColor = UIColor(hex: msgColor)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Utiltiy.getCaptionHeight() - Constraints.kCaptionTopPadding)),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.kCaptionLeftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.kCaptionLeftPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: Constraints.kCaptionHeight),
            
            subTitleLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Constraints.kSubCaptionHeight + Constraints.kSubCaptionTopPadding)),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.kCaptionLeftPadding),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.kCaptionLeftPadding),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.kSubCaptionTopPadding),
            subTitleLabel.heightAnchor.constraint(equalToConstant: Constraints.kSubCaptionHeight)])
    }
    
    func activateImageViewContraints() {
        NSLayoutConstraint.activate([
            bigImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bigImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bigImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bigImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

