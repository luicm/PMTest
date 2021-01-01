import UIKit

extension UIFont {

    public var italicFont: UIFont? {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert([.traitItalic])
        if let italicDescriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) {
            return UIFont(descriptor: italicDescriptor, size: pointSize)
        } else {
            assertionFailure("failed to create italic font descriptor")
            return nil
        }
    }
}
