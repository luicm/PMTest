import AVFoundation

protocol PlayerControllerDelegate: AnyObject {
    func playbackStarted()
    func playbackFinished()
}

final class PlayerController {
    
    static let shared = PlayerController()
    
    weak var delegate: PlayerControllerDelegate?
    private lazy var delegateQueue = OperationQueue()
    
    private lazy var player = AVPlayer()
    
    func attachPlayerLayer(_ playerLayer: AVPlayerLayer) {
        playerLayer.player = player
    }
    
    func detachPlayerLayer(_ playerLayer: AVPlayerLayer) {
        playerLayer.player = nil
    }
    
    func play(_ video: Video) {
        
        player.replaceCurrentItem(with: AVPlayerItem(url: video.videoURL))
        player.play()
        
        delegate?.playbackStarted()
        
        // We can say here that we want the result in the main thread, by changing the value of queue to '.main'
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: video.playerItem,
                                               queue: delegateQueue) { [delegate] _ in
            
            delegate?.playbackFinished()
        }
    }
    
    func playPause() {
        if player.rate == 1 {
            player.pause()
        } else {
            player.play()
        }
    }
    
    
}
