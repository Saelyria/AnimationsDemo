
import UIKit

class DemoSectionViewAction {
    let buttonTitle: String
    let actionBlock: () -> Void
    let shouldStartEnabled: Bool
    var button: UIButton?
    
    init(buttonTitle: String, startsEnabled: Bool = true, actionBlock: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.actionBlock = actionBlock
        self.shouldStartEnabled = startsEnabled
    }
}

class DemoSectionView: CollapsableView {
    private var sampleCodeView: CodeView!
    private var animatingView: UIView?
    private var animationClosure: (() -> Void)?
    private var actions = [DemoSectionViewAction]()
    
    convenience init(title: String, description: String, sampleCode: String, animatingView: UIView, actions: [DemoSectionViewAction]) {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        descriptionLabel.textColor = UIColor.darkGray
        contentView.addSubview(descriptionLabel)
        
        let animatingViewSectionTitle = UILabel()
        animatingViewSectionTitle.text = "Example"
        animatingViewSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        contentView.addSubview(animatingViewSectionTitle)
        
        let animatingViewSection = UIView()
        animatingViewSection.clipsToBounds = true
        animatingViewSection.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSection.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        animatingViewSection.layer.cornerRadius = 8
        contentView.addSubview(animatingViewSection)
        
        animatingView.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSection.addSubview(animatingView)
        NSLayoutConstraint(item: animatingView, attribute: .centerX, relatedBy: .equal, toItem: animatingViewSection, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animatingView, attribute: .centerY, relatedBy: .equal, toItem: animatingViewSection, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 15
        contentView.addSubview(buttonsStackView)
        
        let codeSectionTitle = UILabel()
        codeSectionTitle.text = "Code"
        codeSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        codeSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        contentView.addSubview(codeSectionTitle)
        
        let sampleCodeView = CodeView()
        sampleCodeView.translatesAutoresizingMaskIntoConstraints = false
        sampleCodeView.code = sampleCode
        sampleCodeView.layer.cornerRadius = 8
        sampleCodeView.clipsToBounds = true
        contentView.addSubview(sampleCodeView)
        
        let views = ["desc":descriptionLabel, "animTitle":animatingViewSectionTitle, "animView":animatingViewSection, "buttons":buttonsStackView, "codeTitle":codeSectionTitle, "code":sampleCodeView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10@999-[desc]-35-[animTitle]-10-[animView(200)]-15-[buttons]-35-[codeTitle]-10-[code]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[desc]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animView]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[buttons]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[codeTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[code]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.init(title: title, contentView: contentView)
        self.animatingView = animatingView
        self.sampleCodeView = sampleCodeView
        self.actions = actions
        for action in actions {
            let button = UIButton(type: .system)
            action.button = button
            button.setTitle(action.buttonTitle, for: .normal)
            button.setupWithOutline()
            button.isEnabled = action.shouldStartEnabled
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).isActive = true
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 90).isActive = true
            buttonsStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        descriptionLabel.attributedText = self.attributedStringWithMonospace(inText: description)
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        let action = self.actions.filter { $0.buttonTitle == button.title(for: .normal) }.first
        if let action = action {
            action.actionBlock()
        }
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
