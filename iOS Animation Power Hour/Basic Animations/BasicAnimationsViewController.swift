
import UIKit

class BasicAnimationsViewController: UIViewController {
    var alphaAnimationSection = AnimationSectionDemoView()
    var colorAnimationSection = AnimationSectionDemoView()
    var transformAnimationSection = AnimationSectionDemoView()
    var constraintAnimationSection = AnimationSectionDemoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Block-Based Animations"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        // Alpha animation section
        let alphaLabel = UILabel()
        alphaLabel.text = "I animate my alpha!"
        let alphaLabelAnimationBlock = {
            UIView.animate(withDuration: 0.5, animations: {
                if (alphaLabel.alpha > 0) {
                    alphaLabel.alpha = 0
                } else {
                    alphaLabel.alpha = 1
                }
            })
        }
        let alphaSampleCode = self.stringFromCodeSampleFile(named: "animate-alpha")
        alphaAnimationSection.setup(title: "Alpha", sampleCode: alphaSampleCode, animatingView: alphaLabel, animatingClosure: alphaLabelAnimationBlock)
        alphaAnimationSection.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(alphaAnimationSection)
    }
    
    func stringFromCodeSampleFile(named fileName: String) -> String {
        let documentsDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        var contents = ""
        if let fileURL = documentsDir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            do {
                contents = try String(contentsOf: fileURL)
            } catch {}
        }
        return contents
    }
}
