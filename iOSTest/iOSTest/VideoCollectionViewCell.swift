import UIKit

final class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var hdImageView: UIImageView!

    var video: Video? {
        didSet {
            guard let video = video else {
                return
            }
            DispatchQueue.global().async { [thumbnailImageView] in
                if
                    let data = try? Data(contentsOf: video.thumbnailURL),
                    let image = UIImage(data: data)
                {
                    DispatchQueue.main.async {
                        thumbnailImageView?.image = image
                    }
                }
            }
            titleLabel.text = video.title
            subtitleLabel.text = video.subtitle
            descriptionLabel.attributedText = video.attributedDescription
            if video.hdQuality {
                hdImageView.isHidden = false
            }
        }
    }

    override func prepareForReuse() {
        video = nil
    }
}
