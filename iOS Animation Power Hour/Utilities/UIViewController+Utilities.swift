
import UIKit

extension UIViewController {
    func stringFromCodeSampleFile(named fileName: String) -> String {
        var contents = ""
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            if let data = try? String(contentsOfFile: filePath) {
                contents = data
            }
        }
        return contents
    }
}
