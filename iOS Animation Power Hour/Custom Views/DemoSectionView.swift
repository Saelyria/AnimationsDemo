
import UIKit

// MARK: - Actions

protocol DemoSectionViewAction {
    func callAction()
}

class DemoSectionViewButtonAction: DemoSectionViewAction {
    let buttonTitle: String
    let actionBlock: () -> Void
    let shouldStartEnabled: Bool
    var button: UIButton? {
        didSet {
            button?.setTitle(self.buttonTitle, for: .normal)
            button?.isEnabled = self.shouldStartEnabled
        }
    }
    
    init(buttonTitle: String, startsEnabled: Bool = true, actionBlock: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.actionBlock = actionBlock
        self.shouldStartEnabled = startsEnabled
    }
    
    func callAction() {
        self.actionBlock()
    }
}

class DemoSectionViewSliderAction: DemoSectionViewAction {
    let actionBlock: (Float) -> Void
    var slider: UISlider? {
        didSet {
            slider?.isContinuous = true
        }
    }
    
    init(actionBlock: @escaping (Float) -> Void) {
        self.actionBlock = actionBlock
    }
    
    func callAction() {
        if let slider = self.slider {
            self.actionBlock(slider.value)
        }
    }
}

// MARK: - DemoSectionView

class DemoSectionView: CollapsableView {
    private var sampleCodeView: CodeView!
    private var animationExampleView: AnimationExampleView!
    private var animationClosure: (() -> Void)?
    private var actionStackView: UIStackView!
    private var actions = [UIControl: DemoSectionViewAction]()
    
    required init(title: String, description: String, sampleCode: String, animationExampleView: AnimationExampleView, actions: [DemoSectionViewAction]) {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.attributedText = DemoSectionView.attributedStringWithMonospace(inText: description)
        contentView.addSubview(descriptionLabel)
        
        let animatingViewSectionTitle = UILabel()
        animatingViewSectionTitle.text = "Example"
        animatingViewSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        contentView.addSubview(animatingViewSectionTitle)
        
        animationExampleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animationExampleView)
        
        let actionsStackView = UIStackView()
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.alignment = .center
        actionsStackView.distribution = .fillEqually
        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 15
        contentView.addSubview(actionsStackView)
        NSLayoutConstraint(item: actionsStackView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
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
        
        let views = ["desc":descriptionLabel, "animTitle":animatingViewSectionTitle, "animView":animationExampleView, "actions":actionsStackView, "codeTitle":codeSectionTitle, "code":sampleCodeView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10@999-[desc]-35-[animTitle]-10-[animView(200)]-15-[actions]-35-[codeTitle]-10-[code]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[desc]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animView]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[codeTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[code]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        super.init(title: title, contentView: contentView)
        self.animationExampleView = animationExampleView
        self.actionStackView = actionsStackView
        self.sampleCodeView = sampleCodeView
        
        for action in actions {
            if let buttonAction = action as? DemoSectionViewButtonAction {
                let button = UIButton(type: .system)
                button.setupWithOutline()
                buttonAction.button = button
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).isActive = true
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 90).isActive = true
                actionStackView.addArrangedSubview(button)
                self.actions[button] = action
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
            
            else if let sliderAction = action as? DemoSectionViewSliderAction {
                let slider = UISlider()
                slider.translatesAutoresizingMaskIntoConstraints = false
                sliderAction.slider = slider
                NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 180).isActive = true
                actionStackView.addArrangedSubview(slider)
                self.actions[slider] = sliderAction
                slider.addTarget(self, action: #selector(onSliderValueChanged(slider:)), for: .valueChanged)
            }
        }
    }
    
    required init(title: String, contentView: UIView, startsCollapsed: Bool) {
        fatalError("init(title:contentView:startsCollapsed:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class func attributedStringWithMonospace(inText text: String) -> NSAttributedString {
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
    
    @objc func onSliderValueChanged(slider: UISlider) {
        if let action = self.actions[slider] {
            action.callAction()
        }
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        if let action = self.actions[button] {
            action.callAction()
        }
    }
}
