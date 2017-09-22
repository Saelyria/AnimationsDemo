
import UIKit

class AnimationSectionDemoView: UIView {
    var titleLabel = UILabel()
    var animatingView: UIView!
    var goButton = UIButton(type: .system)
    var sampleCodeView = UITextView()
    
    func setup(title: String, sampleCode: String, animatingView: UIView, animatingClosure: () -> Void) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        self.animatingView = animatingView
        animatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animatingView)
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.setTitle("Go", for: .normal)
        goButton.setupWithOutline()
        self.addSubview(goButton)
        
        let highlightr = Highlightr()
        highlightr!.setTheme(to: "paraiso-dark")
        let highlightedCode: NSAttributedString? = highlightr!.highlight(sampleCode, as: "swift")
        sampleCodeView.translatesAutoresizingMaskIntoConstraints = false
        sampleCodeView.attributedText = highlightedCode
        self.addSubview(sampleCodeView)
        
        let views = ["title":titleLabel, "animView":animatingView, "button":goButton, "code":sampleCodeView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[title]-10-[animView]-10-[button]-10-[code]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[animView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[button]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[code]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
}
