
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
        
        let optionsRepeatAnimationSection = self.createOptionsRepeatingSection()
        self.sections.append(optionsRepeatAnimationSection)
        stackView.addArrangedSubview(optionsRepeatAnimationSection)
        
        let optionsCurrentStateAnimationSection = self.createOptionsCurrentStateSection()
        self.sections.append(optionsCurrentStateAnimationSection)
        stackView.addArrangedSubview(optionsCurrentStateAnimationSection)
        
        let optionsCurvesAnimationSection = self.createOptionsCurvesSection()
        self.sections.append(optionsCurvesAnimationSection)
        stackView.addArrangedSubview(optionsCurvesAnimationSection)
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
            UIView.animate(withDuration: 1.0, animations: {
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
    
    func createOptionsRepeatingSection() -> DemoSectionView {
        let sectionTitle = "Repeating"
        let description = "There are a bunch of other options you can give the animation method, including a delay, a completion block, and an array of options. One of these options is the ability to set an animation to repeat (UIViewAnimationOptions.repeat) and, when repeating, automatically reverse each time (UIViewAnimationOptions.autoreverse).\n\nStopping repeating block-based animations is one of the caveats of them; to stop them, you have to remove all animations from the view's layer and reset the view to its defaults manually, and it looks pretty janky."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-repeat")
        let animatingView = self.createRedSquare()
        
        let animateActionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                animatingView.alpha = 0
                animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
        }
        let animateAction = DemoSectionViewAction(buttonTitle: animateActionTitle, actionBlock: animationBlock)
        
        let stopActionTitle = "Stop"
        let stopAnimationBlock = {
            animatingView.layer.removeAllAnimations()
            animatingView.alpha = 1
            animatingView.transform = CGAffineTransform.identity
        }
        let stopAnimateAction = DemoSectionViewAction(buttonTitle: stopActionTitle, actionBlock: stopAnimationBlock)
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [animateAction, stopAnimateAction])
        return animationSection
    }
    
    func createOptionsCurrentStateSection() -> DemoSectionView {
        let sectionTitle = "Competing Animations"
        let description = "When an animation block is started that animates properties already being animated from another block, UIKit will complete the previous animation and start the new animation. This behaviour can be seen with the previous animations by quickly tapping 'Animate' while an animation is underway. Luckily, there's an animation option (UIViewAnimationOptions.beginFromCurrentState) that tells UIKit to begin the animation of a newly-started competing block with the current values from an already-running block."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-current-state")
        let animatingView = self.createRedSquare()
        
        let actionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .beginFromCurrentState, animations: {
                if (animatingView.alpha > 0) {
                    animatingView.alpha = 0
                } else {
                    animatingView.alpha = 1
                }
            }, completion: nil)
        }
        let action = DemoSectionViewAction(buttonTitle: actionTitle, actionBlock: animationBlock)
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createOptionsCurvesSection() -> DemoSectionView {
        let sectionTitle = "Animation Curves"
        let description = "Another set of animation options are built-in animation curves. When passed to the animate method, UIKit will calculate the animating properties according to the curve's underlying function. If a curve is not passed in, it defaults to UIViewAnimationOptions.curveLinear."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-curves")
        
        let square1 = self.createRedSquare(width: 60)
        let square2 = self.createRedSquare(width: 60)
        let animatingView = UIView()
        animatingView.addSubview(square1)
        animatingView.addSubview(square2)
        NSLayoutConstraint(item: animatingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: animatingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint(item: square1, attribute: .centerX, relatedBy: .equal, toItem: animatingView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: square2, attribute: .centerX, relatedBy: .equal, toItem: animatingView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        let views = ["s1":square1, "s2":square2]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=30)-[s1]-20-[s2]-(>=30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        let actionTitle = "Animate"
        let animationBlock = {
            UIView.animate(withDuration: 1.0, animations: {
                if (square1.transform == CGAffineTransform.identity) {
                    square1.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square1.transform = CGAffineTransform.identity
                }
            })
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                if (square2.transform == CGAffineTransform.identity) {
                    square2.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square2.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        }
        let action = DemoSectionViewAction(buttonTitle: actionTitle, actionBlock: animationBlock)
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createRedSquare(width: CGFloat = 100) -> UIView {
        let redSquare = UIView()
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: redSquare, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: redSquare, attribute: .width, relatedBy: .equal, toItem: redSquare, attribute: .height, multiplier: 1, constant: 0).isActive = true
        redSquare.backgroundColor = UIColor.red
        return redSquare
    }
}
