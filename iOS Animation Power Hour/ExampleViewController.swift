
import UIKit

protocol ExampleViewControllerAction {
    func callAction()
}

class ExampleViewControllerButtonAction: ExampleViewControllerAction {
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

class ExampleViewControllerSliderAction: ExampleViewControllerAction {
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

class ExampleViewController: UIViewController {
    private var descriptionText: String!
    private var sampleCode: String!
    private var animationExampleView: AnimationExampleView!
    private var actions: [ExampleViewControllerAction]!
    private var actionsDict = [UIControl: ExampleViewControllerAction]()
    
    required init(title: String, description: String, sampleCode: String, animationExampleView: AnimationExampleView, actions: [ExampleViewControllerAction]) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.descriptionText = description
        self.sampleCode = sampleCode
        self.animationExampleView = animationExampleView
        self.actions = actions
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let scrollView = AutoLayoutScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        }
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.attributedText = self.attributedStringWithMonospace(inText: descriptionText)
        scrollView.contentView.addSubview(descriptionLabel)
        
        let animatingViewSectionTitle = UILabel()
        animatingViewSectionTitle.text = "Example"
        animatingViewSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        animatingViewSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        scrollView.contentView.addSubview(animatingViewSectionTitle)
        
        animationExampleView.translatesAutoresizingMaskIntoConstraints = false
        animationExampleView.layer.shadowRadius = 5
        animationExampleView.layer.shadowOpacity = 0.1
        animationExampleView.layer.shadowColor = UIColor.black.cgColor
        animationExampleView.layer.shadowOffset = CGSize(width: 7, height: 7)
        scrollView.contentView.addSubview(animationExampleView)
        
        let actionsStackView = UIStackView()
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.alignment = .leading
        actionsStackView.distribution = .fillEqually
        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 15
        scrollView.contentView.addSubview(actionsStackView)
        
        let codeSectionTitle = UILabel()
        codeSectionTitle.text = "Code"
        codeSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        codeSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        scrollView.contentView.addSubview(codeSectionTitle)
        
        let sampleCodeView = CodeView()
        sampleCodeView.translatesAutoresizingMaskIntoConstraints = false
        sampleCodeView.code = sampleCode
        sampleCodeView.layer.cornerRadius = 8
        sampleCodeView.layer.shadowRadius = 5
        sampleCodeView.layer.shadowOpacity = 0.1
        sampleCodeView.layer.shadowColor = UIColor.black.cgColor
        sampleCodeView.layer.shadowOffset = CGSize(width: 7, height: 7)
        sampleCodeView.clipsToBounds = false
        scrollView.contentView.addSubview(sampleCodeView)
        
        let views = ["desc":descriptionLabel, "animTitle":animatingViewSectionTitle, "animView":animationExampleView, "actions":actionsStackView, "codeTitle":codeSectionTitle, "code":sampleCodeView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[desc]-35-[animTitle]-10-[animView(200)]-15-[actions]-35-[codeTitle]-10-[code]->=20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[desc]-90-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[animTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[animView]-60-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[actions]-(>=60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[codeTitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[code]-60-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        for action in self.actions {
            if let buttonAction = action as? ExampleViewControllerButtonAction {
                let button = UIButton(type: .system)
                button.setupWithOutline()
                buttonAction.button = button
                NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40).isActive = true
                NSLayoutConstraint(item: button, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 90).isActive = true
                actionsStackView.addArrangedSubview(button)
                self.actionsDict[button] = action
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
                
            else if let sliderAction = action as? ExampleViewControllerSliderAction {
                let slider = UISlider()
                slider.translatesAutoresizingMaskIntoConstraints = false
                sliderAction.slider = slider
                NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 180).isActive = true
                actionsStackView.addArrangedSubview(slider)
                self.actionsDict[slider] = sliderAction
                slider.addTarget(self, action: #selector(onSliderValueChanged(slider:)), for: .valueChanged)
            }
        }
    }
    
    @objc func onSliderValueChanged(slider: UISlider) {
        if let action = self.actionsDict[slider] {
            action.callAction()
        }
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        if let action = self.actionsDict[button] {
            action.callAction()
        }
    }
}
