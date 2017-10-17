
import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Samples"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 1
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        self.view.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: -160).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        if #available(iOS 11.0, *) {
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 25).isActive = true
        } else {
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100).isActive = true
        }
        
        let blockBasedCell = ExampleViewCell(title: "Block-Based Animations", description: "", onTapAction: {
            let basicAnimsVC = BlockAnimationsViewController()
            self.navigationController?.pushViewController(basicAnimsVC, animated: true)
        })
        stackView.addArrangedSubview(blockBasedCell)
        
        let propertyAnimatorCell = ExampleViewCell(title: "Property Animators", description: "", onTapAction: {
            let propertyAnimatorVC = PropertyAnimatorViewController()
            self.navigationController?.pushViewController(propertyAnimatorVC, animated: true)
        })
        stackView.addArrangedSubview(propertyAnimatorCell)
        
        let builtInCell = ExampleViewCell(title: "Built-In Transitions", description: "", onTapAction: {
            let builtInTransitionsVC = BuiltInTransitionsViewController()
            self.navigationController?.pushViewController(builtInTransitionsVC, animated: true)
        })
        stackView.addArrangedSubview(builtInCell)
        
        let customTransitionCell = ExampleViewCell(title: "Custom Transitions", description: "", onTapAction: {
            
        })
        stackView.addArrangedSubview(customTransitionCell)
    }
}
