
import UIKit

class BasicAnimationsViewController: UIViewController {
    var sections = [DemoSectionView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Block-Based Animations"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        self.view.addSubview(scrollView)
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 25
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        let alphaAnimationSection = self.createAlphaSection()
        self.sections.append(alphaAnimationSection)
        stackView.addArrangedSubview(alphaAnimationSection)
        
        let colorAnimationSection = self.createColorSection()
        self.sections.append(colorAnimationSection)
        stackView.addArrangedSubview(colorAnimationSection)
        
        let transformAnimationSection = self.createTransformSection()
        self.sections.append(transformAnimationSection)
        stackView.addArrangedSubview(transformAnimationSection)
        
        let multiTransformAnimationSection = self.createMultiTransformSection()
        self.sections.append(multiTransformAnimationSection)
        stackView.addArrangedSubview(multiTransformAnimationSection)
    }
    
    func stringFromCodeSampleFile(named fileName: String) -> String {
        var contents = ""
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            if let data = try? String(contentsOfFile: filePath) {
                contents = data
            }
        }
        return contents
    }
}
    
fileprivate extension BasicAnimationsViewController {
    func createAlphaSection() -> DemoSectionView {
        let sectionTitle = "Alpha"
        let description = "Alpha is a decimal number between 0 and 1. Its default value is 1."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-alpha")
        let animatingView = self.createRedSquare()
        
        let actionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.alpha > 0) {
                    animatingView.alpha = 0
                } else {
                    animatingView.alpha = 1
                }
            })
        }
        let action = DemoSectionViewAction(buttonTitle: actionTitle, actionBlock: animationBlock)

        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createColorSection() -> DemoSectionView {
        let sectionTitle = "Color"
        let description = "Background color is a UIColor, UIKit's color class. On a newly-made UIView it is UIColor.clear, or (r:0 g:0 b:0 a:0)."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-color")
        let animatingView = self.createRedSquare()
        
        let actionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.backgroundColor != UIColor.red) {
                    animatingView.backgroundColor = UIColor.red
                } else {
                    animatingView.backgroundColor = UIColor.blue
                }
            })
        }
        let action = DemoSectionViewAction(buttonTitle: actionTitle, actionBlock: animationBlock)

        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createTransformSection() -> DemoSectionView {
        let sectionTitle = "Transform"
        let description = "A transform is an instance of CGAffineTransform. A single CGAffineTransform instance describes a type of transform, such as a translation, rotation, or scaling, and the function to get to it, with each type having its own initializer.\n\nTo apply a transform to a view, create a CGAffineTransform object and set the view's transform property to the created transform. CGAffineTransform has a class property called identity that represents a view's unmodified transform; to reset the transform of a view, set its transform property to this property.\n\nNote that applying there are a couple other steps to apply these transforms at the same time."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let animatingView = self.createRedSquare()
        
        // translate
        let translateTitle = "Animate translation"
        let translateAnimationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.transform == CGAffineTransform.identity) {
                    animatingView.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    animatingView.transform = CGAffineTransform.identity
                }
            })
        }
        let translateAction = DemoSectionViewAction(buttonTitle: translateTitle, actionBlock: translateAnimationBlock)
        
        // rotate
        let rotateTitle = "Animate rotation"
        let rotateAnimationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.transform == CGAffineTransform.identity) {
                    animatingView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                } else {
                    animatingView.transform = CGAffineTransform.identity
                }
            })
        }
        let rotateAction = DemoSectionViewAction(buttonTitle: rotateTitle, actionBlock: rotateAnimationBlock)
        
        // scale
        let scaleTitle = "Animate scale"
        let scaleAnimationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.transform == CGAffineTransform.identity) {
                    animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                } else {
                    animatingView.transform = CGAffineTransform.identity
                }
            })
        }
        let scaleAction = DemoSectionViewAction(buttonTitle: scaleTitle, actionBlock: scaleAnimationBlock)
        
        let actions = [translateAction, rotateAction, scaleAction]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createMultiTransformSection() -> DemoSectionView {
        let sectionTitle = "Multiple Transforms"
        let description = "To apply multiple transforms at the same time, we have to concatenate each individual transform into a single CGAffineTransform object. This is most easily done by calling the concatenating() method on one of the transforms, passing in the second transform."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-multi-transform")
        let animatingView = self.createRedSquare()
        
        let actionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 2.0, animations: {
                if (animatingView.transform == CGAffineTransform.identity) {
                    let translateTransform = CGAffineTransform(translationX: 100, y: 0)
                    let scaleTransform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    animatingView.transform = translateTransform.concatenating(scaleTransform)
                } else {
                    animatingView.transform = CGAffineTransform.identity
                }
            })
        }
        let action = DemoSectionViewAction(buttonTitle: actionTitle, actionBlock: animationBlock)
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createRedSquare() -> UIView {
        let redSquare = UIView()
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: redSquare, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: redSquare, attribute: .width, relatedBy: .equal, toItem: redSquare, attribute: .height, multiplier: 1, constant: 0).isActive = true
        redSquare.backgroundColor = UIColor.red
        return redSquare
    }
}
