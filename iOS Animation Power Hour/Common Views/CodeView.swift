
import UIKit

/// A view containing a text view formatted to show syntax-highlighted code.
class CodeView: UIView {
    var code: String? {
        didSet {
            self.textView.text = code;
        }
    }
    
    var theme: Theme {
        get {
            return self.textStorage.highlightr.theme
        }
    }
    
    var textView: UITextView!
    fileprivate var heightConstraint: NSLayoutConstraint!
    private let textStorage = CodeAttributedString()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        textStorage.language = "Swift"
        textStorage.highlightr.setTheme(to: "solarized-light") //paraiso-dark, Androidstudio, Atelier Sulphurpool Light/Light, Dark, Docco, Github Gist, Solarized Dark
        let font = textStorage.highlightr.theme.codeFont.withSize(16)
        textStorage.highlightr.theme.setCodeFont(font)
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        self.textView = UITextView(frame: self.frame, textContainer: textContainer)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.isScrollEnabled = false
        self.textView.isEditable = false
        self.textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.textView.backgroundColor = UIColor.groupTableViewBackground//textStorage.highlightr.theme.themeBackgroundColor
        self.textView.layer.cornerRadius = 8
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
