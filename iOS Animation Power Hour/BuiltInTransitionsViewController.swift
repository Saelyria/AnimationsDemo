
import UIKit

class BuiltInTransitionsViewController: UIViewController {
    let navPushButton = UIButton(type: .system)
    let coverVerticalButton = UIButton(type: .system)
    let flipHorizontalButton = UIButton(type: .system)
    let crossDissolveButton = UIButton(type: .system)
    let partialCurlButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Built-in Transitions"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navPushButton.setTitle("Navigation Push", for: .normal)
        self.navPushButton.addTarget(self, action: #selector(navPushPressed), for: .touchUpInside)
        self.coverVerticalButton.setTitle("Cover Vertical", for: .normal)
        self.coverVerticalButton.addTarget(self, action: #selector(coverVerticalPressed), for: .touchUpInside)
        self.flipHorizontalButton.setTitle("Flip Horizontal", for: .normal)
        self.flipHorizontalButton.addTarget(self, action: #selector(flipHorizontalPressed), for: .touchUpInside)
        self.crossDissolveButton.setTitle("Cross Dissolve", for: .normal)
        self.crossDissolveButton.addTarget(self, action: #selector(crossDissolvePressed), for: .touchUpInside)
        self.partialCurlButton.setTitle("Partial Curl", for: .normal)
        self.partialCurlButton.addTarget(self, action: #selector(partialCurlPressed), for: .touchUpInside)
        
        let buttons = [ self.navPushButton, self.coverVerticalButton, self.flipHorizontalButton, self.crossDissolveButton, self.partialCurlButton ]
        buttons.forEach { button in self.setupStyleOnButton(button) }
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0).isActive = true
        } else {
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        }
        
        let descriptionText = "There are a number of transition animations built into iOS by default. To start, there are two ways to transitions to a new view controller - through a navigation push and through a modal presentation. Pushes are where it slides in from the right and has the back chevrons with the title of the previous view controller. Modal presentations are most commonly (and by default if no alternative transition animation is specified) the 'cover vertical' modal presentation where it slides up from the bottom.\n\nThere is only one kind of built-in push animation, but there are four modal presentation styles - 'cover vertical', 'flip horizontal', 'cross dissolve', and 'partial curl'. In reality, though, you'll only really use the 'cover vertical' and maybe the 'cross dissolve' - the other two are pretty tacky. These can all be seen using the below buttons."
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.attributedText = self.attributedStringWithMonospace(inText: descriptionText)
        stackView.addArrangedSubview(descriptionLabel)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-90-[desc]-90-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["desc":descriptionLabel]))
        
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
    
    func setupStyleOnButton(_ button: UIButton) {
        button.setupWithOutline()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
    }
    
    @objc func navPushPressed() {
        let sampleCode = self.stringFromCodeSampleFile(named: "push")
        let exampleVC = ExampleTransitionViewController(title: "Navigation Push", sampleCode: sampleCode, showsCloseControl: false)
        self.navigationController?.pushViewController(exampleVC, animated: true)
    }
    
    @objc func coverVerticalPressed() {
        let sampleCode = self.stringFromCodeSampleFile(named: "cover-vertical")
        let exampleVC = ExampleTransitionViewController(title: "Cover Vertical", sampleCode: sampleCode)
        let navController = UINavigationController(rootViewController: exampleVC)
        navController.modalTransitionStyle = .coverVertical
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func flipHorizontalPressed() {
        let sampleCode = self.stringFromCodeSampleFile(named: "flip-horizontal")
        let exampleVC = ExampleTransitionViewController(title: "Flip Horizontal", sampleCode: sampleCode)
        let navController = UINavigationController(rootViewController: exampleVC)
        navController.modalTransitionStyle = .flipHorizontal
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func crossDissolvePressed() {
        let sampleCode = self.stringFromCodeSampleFile(named: "cross-dissolve")
        let exampleVC = ExampleTransitionViewController(title: "Cross Dissolve", sampleCode: sampleCode)
        let navController = UINavigationController(rootViewController: exampleVC)
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func partialCurlPressed() {
        let sampleCode = self.stringFromCodeSampleFile(named: "partial-curl")
        let exampleVC = ExampleTransitionViewController(title: "Partial Curl", sampleCode: sampleCode)
        let navController = UINavigationController(rootViewController: exampleVC)
        navController.modalTransitionStyle = .partialCurl
        self.present(navController, animated: true, completion: nil)
    }
}
