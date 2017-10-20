
import UIKit

class MainViewController: UIViewController {
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: -160).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        
        self.title = "Samples"
        
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
            let customTransitionsVC = CustomTransitionViewController()
            self.navigationController?.pushViewController(customTransitionsVC, animated: true)
        })
        stackView.addArrangedSubview(customTransitionCell)
    }
}
