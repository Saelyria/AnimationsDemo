
import UIKit

class MainViewController: UIViewController {
    let basicAnimationsButton = UIButton(type: .system)
    let propertyAnimatorButton = UIButton(type: .system)
    let pushAnimationButton = UIButton(type: .system)
    let modalAnimationsButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samples"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.basicAnimationsButton.setTitle("Basic Animations", for: .normal)
        self.basicAnimationsButton.addTarget(self, action: #selector(basicAnimationsPressed), for: .touchUpInside)
        self.propertyAnimatorButton.setTitle("Animations with a Property Animator", for: .normal)
        self.pushAnimationButton.setTitle("Push Animation", for: .normal)
        self.modalAnimationsButton.setTitle("Modal Animations", for: .normal)
        
        let buttons = [ self.basicAnimationsButton, self.pushAnimationButton, self.modalAnimationsButton ]
        buttons.forEach { button in self.setupStyleOnButton(button) }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupStyleOnButton(_ button: UIButton) {
        button.setupWithOutline()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200).isActive = true
    }
    
    @objc func basicAnimationsPressed() {
        let basicAnimsVC = BasicAnimationsViewController()
        self.navigationController?.pushViewController(basicAnimsVC, animated: true)
    }
    
    func propertyAnimatorPressed() {
        
    }
    
    func pushAnimationPressed() {
        
    }
    
    func modalAnimationsPressed() {
        
    }
}
