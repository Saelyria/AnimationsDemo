
import UIKit

class MainViewController: StackViewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
