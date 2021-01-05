import AVFoundation
import UIKit

final class PlayerViewController: UIViewController {

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

    var playerController = PlayerController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        playerController.delegate = self
        // Add notifications for device locked and unlocked
        NotificationCenter.default.addObserver(self, selector: #selector(lockedDevice), name: UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unlockedDevice), name: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil)
    }

    deinit {
        playerController.detachPlayerLayer(playerView.playerLayer)
    }

    @IBAction func playPause(_ sender: UIButton) {
        playerController.playPause()
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
