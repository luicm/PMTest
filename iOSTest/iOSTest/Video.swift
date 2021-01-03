import AVFoundation
import UIKit

final class Video: Decodable {

    private enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case description
        case hdQuality = "hd"
        case thumbnailURL = "thumb"
        case videoURL = "source"
    }

    var title: String
    var subtitle: String
    var description: String
    var hdQuality: Bool
    var thumbnailURL: URL
    var videoURL: URL

    lazy var attributedDescription: NSAttributedString = {
        applyItalicAttribute(text: description)
    }()

    // change lazy var to computed property solves memory issues
    var playerItem: AVPlayerItem {
        AVPlayerItem(url: videoURL)
    }

    init(title: String, subtitle: String, description: String, hdQuality: Bool, thumbnailURL: URL, videoURL: URL) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.hdQuality = hdQuality
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
    }
}
