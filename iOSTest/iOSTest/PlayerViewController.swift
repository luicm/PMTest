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
    }

    deinit {
        playerController.detachPlayerLayer(playerView.playerLayer)
    }

    @IBAction func playPause(_ sender: UIButton) {
        playerController.playPause()
    }
}

extension PlayerViewController: PlayerControllerDelegate {

    func playbackStarted() {
        statusLabel.text = nil
    }

    func playbackFinished() {
        statusLabel.text = "No Video"
    }
}
