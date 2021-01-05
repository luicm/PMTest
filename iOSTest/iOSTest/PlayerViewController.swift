import AVFoundation
import AVKit
import UIKit

// I have gone with the apple example to implement PiP in a Custom Player.
// https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player

final class PlayerViewController: UIViewController, AVPictureInPictureControllerDelegate {

    
    @IBOutlet private weak var playerView: PlayerView! {
        didSet {
            playerController.attachPlayerLayer(playerView.playerLayer)
        }
    }
    
    @IBOutlet private weak var statusLabel: UILabel!
    
    @IBOutlet private weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(UIImage(systemName: "playpause.fill"), for: .normal)
        }
    }
    
    /// Custom button to enable Picture in Picture
    @IBOutlet weak var pipButton: UIButton! {
        didSet {
            let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
            let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
            
            pipButton.setImage(startImage, for: .normal)
            pipButton.setImage(stopImage, for: .selected)
        }
    }
    
    var playerController = PlayerController.shared
    
    /// Controller created when user interacts with Picture in Picture option
    var pictureInPictureController: AVPictureInPictureController?
    ///Observer for the Picture in Picture notifications
    var pipPossibleObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerController.delegate = self
        
        setupPictureInPicture()
                        
        
        // Add notifications for device locked and unlocked
        NotificationCenter.default.addObserver(self, selector: #selector(lockedDevice), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unlockedDevice), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    }
    
    deinit {
        playerController.detachPlayerLayer(playerView.playerLayer)
        // Remove notifications
        NotificationCenter.default.removeObserver(UIApplication.protectedDataWillBecomeUnavailableNotification)
        NotificationCenter.default.removeObserver(UIApplication.protectedDataDidBecomeAvailableNotification)
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        playerController.playPause()
    }
    
    /// Activate and deactive PiP if availabe
    @IBAction func togglePictureInPictureMode(_ sender: UIButton) {
        guard let pipController = pictureInPictureController else {
            return
        }
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
    }
    
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported() {
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerView.playerLayer)
            pictureInPictureController?.delegate = self
            
            pipPossibleObservation = pictureInPictureController?.observe(\AVPictureInPictureController.isPictureInPicturePossible,
                                                                         options: [.initial, .new]) { [weak self] _, change in
                // Update the PiP button's enabled state.
                self?.pipButton.isEnabled = change.newValue ?? false
            }
            
        } else {
            // PiP isn't supported by the current device. Disable the PiP button.
            pipButton.isEnabled = false
        }
    }
    
    // remove player layer to avoid the video to pause when device is locked
    @objc func lockedDevice() {
        playerController.detachPlayerLayer(playerView.playerLayer)
    }
    // recover layer when device unlocked, so we can continue playing the video
    @objc func unlockedDevice() {
        playerController.attachPlayerLayer(playerView.playerLayer)
    }

}

extension PlayerViewController: PlayerControllerDelegate {
    
    func playbackStarted() {
        statusLabel.text = nil
    }
    
    func playbackFinished() {
        // since i yet not understand the full app, sending the UI code directly to the main thread in this point seams the most positive option 
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = "No Video"
        }
    }
}
