
import UIKit

class CodeView: UIView {
    var code: String? {
        didSet {
            self.textView.text = code;
        }
    }
    
    var textView: UITextView!
    fileprivate var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        let textStorage = CodeAttributedString()
        textStorage.language = "Swift"
        textStorage.highlightr.setTheme(to: "paraiso-dark")
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        self.textView = UITextView(frame: self.frame, textContainer: textContainer)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.isScrollEnabled = false
        self.textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.textView.backgroundColor = textStorage.highlightr.theme.themeBackgroundColor
        self.addSubview(self.textView)
        self.textView.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.textView.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint(item: self.textView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self.textView, attribute: .height, multiplier: 1, constant: 0)
        self.heightConstraint.isActive = true
    }
}
