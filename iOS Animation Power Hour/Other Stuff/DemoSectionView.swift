
import UIKit

class DemoSectionViewAction {
    var buttonTitle: String
    var actionBlock: () -> Void
    
    init(buttonTitle: String, actionBlock: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.actionBlock = actionBlock
    }
}

class DemoSectionView: CollapsableView {
    private var animatingView: UIView?
    private var animationClosure: (() -> Void)?
    private var actions = [DemoSectionViewAction]()
    
    convenience init(title: String, description: String, sampleCode: String, animatingView: UIView, actions: [DemoSectionViewAction]) {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        contentView.addSubview(descriptionLabel)
        
        let animatingViewSectionTitle = UILabel()
        animatingViewSectionTitle.text = "Example"
        animatingViewSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        contentView.addSubview(animatingViewSectionTitle)
        
        let animatingViewSection = UIView()
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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0@999-[desc]-35-[animTitle]-10-[animView(200)]-15-[buttons]-35-[codeTitle]-10-[code]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[desc]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[animView]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[buttons]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[codeTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[code]-25-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        self.init(title: title, contentView: contentView)
        self.animatingView = animatingView
        self.actions = actions
        for action in actions {
            let button = UIButton(type: .system)
            button.setTitle(action.buttonTitle, for: .normal)
            button.setupWithOutline()
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).isActive = true
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 90).isActive = true
            buttonsStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        let action = self.actions.filter { $0.buttonTitle == button.title(for: .normal) }.first
        if let action = action {
            action.actionBlock()
        }
    }
}
