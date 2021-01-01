import UIKit

final class GridViewController: UICollectionViewController {

    var playerController = PlayerController.shared

    private lazy var videos: [Video] = {
        guard
            let path = Bundle.main.path(forResource: "data", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let videoData = try? JSONDecoder().decode(VideoData.self, from: data)
        else {
            assertionFailure("failed to load data")
            return []
        }
        return videoData.videos
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "VideoCollectionViewCell")

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { _, environment -> NSCollectionLayoutSection? in

            let itemsPerRow: CGFloat = {
                switch environment.traitCollection.horizontalSizeClass {
                case .compact:
                    return 2
                default:
                    if environment.container.contentSize.width > 800 {
                        return 3
                    } else {
                        return 2
                    }
                }
            }()

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/itemsPerRow),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(1/itemsPerRow))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            return section
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath)
        if let videoCell = cell as? VideoCollectionViewCell {
            videoCell.video = videos[indexPath.item]
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playerController.play(videos[indexPath.row])
    }
}

