
import UIKit

class MainViewController: UIViewController {
    let blockAnimationsButton = UIButton(type: .system)
    let propertyAnimatorButton = UIButton(type: .system)
    let defaultTransitionsButton = UIButton(type: .system)
    let customTransitionsButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samples"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.blockAnimationsButton.setTitle("Block-Based Animations", for: .normal)
        self.blockAnimationsButton.addTarget(self, action: #selector(basicAnimationsPressed), for: .touchUpInside)
        self.propertyAnimatorButton.setTitle("Animations with a Property Animator", for: .normal)
        self.propertyAnimatorButton.addTarget(self, action: #selector(propertyAnimatorPressed), for: .touchUpInside)
        self.defaultTransitionsButton.setTitle("Built-in Transitions", for: .normal)
        self.defaultTransitionsButton.addTarget(self, action: #selector(defaultTransitionsPressed), for: .touchUpInside)
        self.customTransitionsButton.setTitle("Custom Transitions", for: .normal)
        self.customTransitionsButton.addTarget(self, action: #selector(customTransitionsPressed), for: .touchUpInside)
        
        let buttons = [ self.blockAnimationsButton, self.propertyAnimatorButton, self.defaultTransitionsButton, self.customTransitionsButton ]
        buttons.forEach { button in self.setupStyleOnButton(button) }

        let stackView = UIStackView(arrangedSubviews: buttons)
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
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 30).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    func setupStyleOnButton(_ button: UIButton) {
        button.setupWithOutline()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
    }
    
    @objc func basicAnimationsPressed() {
        let basicAnimsVC = BlockAnimationsViewController()
        self.navigationController?.pushViewController(basicAnimsVC, animated: true)
    }
    
    @objc func propertyAnimatorPressed() {
        let propertyAnimatorVC = PropertyAnimatorViewController()
        self.navigationController?.pushViewController(propertyAnimatorVC, animated: true)
    }
    
    @objc func defaultTransitionsPressed() {
        
    }
    
    @objc func customTransitionsPressed() {
        
    }
}
