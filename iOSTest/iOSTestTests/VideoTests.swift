import XCTest
@testable import iOSTest

final class VideoTests: XCTestCase {

    private var video: Video!

    override func setUp() {
        super.setUp()
        video = Video(title: "Test",
                      subtitle: "All the Things",
                      description: "[The goal of unit testing] is to isolate each part of the program and show that the individual parts are correct. [A unit test] provides a strict, written contract that the piece of code must satisfy. As a result, it affords several benefits. [Unit testing] finds problems early in the development cycle.",
                      hdQuality: true,
                      thumbnailURL: URL(string: "https://example.com/thumb.jpg")!,
                      videoURL: URL(string: "https://example.com/video.mp4")!)
    }

    func testAttributedDescription() {

        let expectation: NSAttributedString = {
            let string = "The goal of unit testing is to isolate each part of the program and show that the individual parts are correct. A unit test provides a strict, written contract that the piece of code must satisfy. As a result, it affords several benefits. Unit testing finds problems early in the development cycle."
            let font = UIFont.preferredFont(forTextStyle: .caption2)
            let attributedString = NSMutableAttributedString(string: string, attributes: [.font: font])
            let italicFont = font.italicFont!
            let italicAttributes: [NSAttributedString.Key: Any] = [.font: italicFont]
            ["The goal of unit testing", "A unit test", "Unit testing"].map {
                (string as NSString).range(of: $0)
            }.forEach {
                attributedString.addAttributes(italicAttributes, range: $0)
            }
            return attributedString
        }()

        XCTAssertEqual(video.attributedDescription, expectation)
    }
}
