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
            // It needs to be a sync process, cant use in this stage an async process, it leads to unexpected results
            // It was enough to remove it, since it was not necesary at all.
            // we could have a placeholder for the waiting images, that can also help for the videos without image
            if let data = try? Data(contentsOf: video.thumbnailURL),
               let image = UIImage(data: data) {
                thumbnailImageView.image = image
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
