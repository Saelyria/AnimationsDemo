
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
    
    func attributedStringWithMonospace(inText text: String) -> NSAttributedString {
        let monospaceFont = UIFont(name: "Menlo-Regular", size: 16)
        guard monospaceFont != nil else { return NSAttributedString(string: text) }
        
        let attributedText = NSMutableAttributedString(string: text)
        do {
            let regexString = "`([^`]*)`"
            let regex = try NSRegularExpression(pattern: regexString, options: [])
            
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
            
            for match in matches {
                let rangeBetweenTildes = match.range(at: 1)
                let attributes = [NSAttributedStringKey.font : monospaceFont!, NSAttributedStringKey.foregroundColor : UIColor(red: 82/255, green: 109/255, blue: 153/255, alpha: 1)]
                attributedText.setAttributes(attributes, range: rangeBetweenTildes)
            }
            
            attributedText.mutableString.replaceOccurrences(of: "`", with: "", options: [], range: NSRange(location: 0, length: attributedText.length))
            return  attributedText
        } catch _ {
            return NSAttributedString(string: text)
        }
    }
}
