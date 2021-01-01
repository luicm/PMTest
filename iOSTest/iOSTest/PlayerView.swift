import AVFoundation
import UIKit

final class PlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
}
