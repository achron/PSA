import UIKit
import UserNotificationsUI
import AVKit
import AVFoundation

@objc public class SingleMediaVC: BaseNotificationContentVC {
    var contentView: UIView = UIView(frame: .zero)
    var currentItemView: CaptionImageView = CaptionImageView(frame: .zero)
    var player:AVPlayer?
    var videoPlayerView: VideoPlayerView = VideoPlayerView(frame: .zero)
    private var captionLabel: UILabel = {
        let captionLabel = UILabel()
        captionLabel.textAlignment = .left
        captionLabel.adjustsFontSizeToFitWidth = false
        captionLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        captionLabel.textColor = UIColor.black
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
    }()
    private var subcaptionLabel: UILabel = {
        let subcaptionLabel = UILabel()
        subcaptionLabel.textAlignment = .left
        subcaptionLabel.adjustsFontSizeToFitWidth = false
        subcaptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        subcaptionLabel.textColor = UIColor.lightGray
        subcaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return subcaptionLabel
    }()
    var playImage: UIImage = UIImage()
    var pauseImage: UIImage = UIImage()
    var playPauseButton: UIButton = UIButton(frame: .zero)
    var isPlaying: Bool = false
    
    @objc public override func viewDidLoad() {
        super.viewDidLoad()

        contentView = UIView(frame: view.frame)
        view.addSubview(contentView)

        createFrameWithImage()

        if mediaType == ConstantKeys.kMediaTypeVideo || mediaType == ConstantKeys.kMediaTypeAudio {
            // TODO: Remove mediaURL = "" when video template is supported.
            mediaURL = ""
            createVideoView()
        } else {
            createImageView()
        }
    }
    
    func createVideoView() {
        createBasicCaptionView()

        guard let urlToVideo = URL(string: mediaURL) else {
            createFrameWithoutImage()
            return
        }
        
        if AVAsset(url: urlToVideo).isPlayable {
            let player = AVPlayer(url: urlToVideo)

            videoPlayerView.player = player
            
            contentView.addSubview(videoPlayerView)
            videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
            let imageHeight = contentView.frame.size.height - Utiltiy.getCaptionHeight()
            NSLayoutConstraint.activate([
                videoPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -Constraints.kImageBorderWidth),
                videoPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -Constraints.kImageBorderWidth),
                videoPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constraints.kImageBorderWidth),
                videoPlayerView.heightAnchor.constraint(equalToConstant: imageHeight)
            ])

            videoPlayerView.player?.play()
            isPlaying = true
            
            playImage = UIImage(named: "playButton") ?? UIImage()
            pauseImage = UIImage(named: "pauseButton") ?? UIImage()

            playPauseButton.setImage(pauseImage, for: .normal)
            playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
            playPauseButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(playPauseButton)
            contentView.bringSubviewToFront(playPauseButton)
            
            NSLayoutConstraint.activate([
                playPauseButton.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor),
                playPauseButton.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor)
            ])
        } else {
            // Video url is invalid.
            createFrameWithoutImage()
        }
    }
    
    func createImageView() {
        Utiltiy.checkImageUrlValid(imageUrl: mediaURL) { [weak self] (imageData) in
            DispatchQueue.main.async {
                if imageData != nil {
                    let itemComponents = CaptionedImageViewComponents(caption: self!.templateCaption, subcaption: self!.templateSubcaption, imageUrl: self!.mediaURL, actionUrl: self!.deeplinkURL, bgColor: ConstantKeys.kDefaultColor, captionColor: ConstantKeys.kHexBlackColor, subcaptionColor: ConstantKeys.kHexLightGrayColor)
                    self?.currentItemView = CaptionImageView(components: itemComponents)
                } else {
                    let itemComponents = CaptionedImageViewComponents(caption: self!.templateCaption, subcaption: self!.templateSubcaption, imageUrl: "", actionUrl: self!.deeplinkURL, bgColor: ConstantKeys.kDefaultColor, captionColor: ConstantKeys.kHexBlackColor, subcaptionColor: ConstantKeys.kHexLightGrayColor)
                    self?.currentItemView = CaptionImageView(components: itemComponents)
                    self?.createFrameWithoutImage()
                }
                self?.setUpConstraints()
            }
        }
        
        let itemComponents = CaptionedImageViewComponents(caption: templateCaption, subcaption: templateSubcaption, imageUrl: mediaURL, actionUrl: deeplinkURL, bgColor: ConstantKeys.kDefaultColor, captionColor: ConstantKeys.kHexBlackColor, subcaptionColor: ConstantKeys.kHexLightGrayColor)
        currentItemView = CaptionImageView(components: itemComponents)
        
    }
    
    func setUpConstraints() {
        contentView.addSubview(currentItemView)
        currentItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            currentItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
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
    
    func createBasicCaptionView() {
        contentView.addSubview(captionLabel)
        contentView.addSubview(subcaptionLabel)
        captionLabel.text = templateCaption
        subcaptionLabel.text = templateSubcaption
        
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Utiltiy.getCaptionHeight() - Constraints.kCaptionTopPadding)),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.kCaptionLeftPadding),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.kTimerLabelWidth),
            captionLabel.heightAnchor.constraint(equalToConstant: Constraints.kCaptionHeight),
            
            subcaptionLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Constraints.kSubCaptionHeight + Constraints.kSubCaptionTopPadding)),
            subcaptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.kCaptionLeftPadding),
            subcaptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.kTimerLabelWidth),
            subcaptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.kSubCaptionTopPadding),
            subcaptionLabel.heightAnchor.constraint(equalToConstant: Constraints.kSubCaptionHeight)
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
    
    @objc func playPauseButtonTapped(_ sender:UIButton) {
        if isPlaying {
            videoPlayerView.player?.pause()
            playPauseButton.setImage(playImage, for: .normal)
            isPlaying = false
        } else {
            videoPlayerView.player?.play()
            playPauseButton.setImage(pauseImage, for: .normal)
            isPlaying = true
        }
    }
    
    @objc public override func getDeeplinkUrl() -> String! {
        return deeplinkURL
    }
}
