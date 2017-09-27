
import UIKit

class BlockAnimationsViewController: UIViewController {
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
        
        let springDampingSection = self.createSpringDampingSection()
        self.sections.append(springDampingSection)
        stackView.addArrangedSubview(springDampingSection)
        
        let springVelocitySection = self.createSpringVelocitySection()
        self.sections.append(springVelocitySection)
        stackView.addArrangedSubview(springVelocitySection)
    }
}
    
fileprivate extension BlockAnimationsViewController {
    func createAlphaSection() -> DemoSectionView {
        let sectionTitle = "Alpha"
        let description = "Block-based animations in iOS are simple and declarative. To start an animation, call the `UIView` class method `animate(withDuration:animations:)`, passing in the duration of the animation and a block. Inside the block, simply set the properties of the animating view to the values you want them to be after the duration, and UIKit will automatically do the tweening to get there.\n\nIn this example, we'll use a view's alpha. Alpha is a decimal number between 0 and 1, with a default value of 1."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-alpha")
        let animatingView = self.createRedSquare()
        
        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.alpha > 0) {
                    animatingView.alpha = 0
                } else {
                    animatingView.alpha = 1
                }
            })
        })

        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createColorSection() -> DemoSectionView {
        let sectionTitle = "Color"
        let description = "The color of a view is determined by its `backgroundColor`. Background color is a UIColor, UIKit's color class. On a newly-made UIView it is UIColor.clear, or (r:0 g:0 b:0 a:0)."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-color")
        let animatingView = self.createRedSquare()
        
        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, animations: {
                if (animatingView.backgroundColor != UIColor.red) {
                    animatingView.backgroundColor = UIColor.red
                } else {
                    animatingView.backgroundColor = UIColor.blue
                }
            })
        })

        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createTransformSection() -> DemoSectionView {
        let sectionTitle = "Transform"
        let description = "A transform is an instance of CGAffineTransform. A single CGAffineTransform instance describes a type of transform, such as a translation, rotation, or scaling, and the function to get to it, with each type having its own initializer. Rotations are defined in radians (multiples of pi), translation is in screen points, and scale is a decimal where 1 is always the original size of the view in question.\n\nTo apply a transform to a view, create a CGAffineTransform object and set the view's transform property to the created transform. CGAffineTransform has a class property called identity that represents an unmodified transform; to reset the transform of a view, set its transform property to this property. Generally, for the purpose of animation, it is better to use a view's transform or center instead of its frame or bounds, as transform and center don't affect Autolayout constraints and are much easier to reset.\n\nNote that there are a couple other steps to apply these transforms at the same time, as they need to be concatenated into a single transform object."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let animatingView = self.createRedSquare()

        var rotateAction, scaleAction, translateAction, resetAction: DemoSectionViewAction?
        translateAction = DemoSectionViewAction(buttonTitle: "Animate translation", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                animatingView.transform = CGAffineTransform(translationX: 100, y: 0)
            })
        })
        
        rotateAction = DemoSectionViewAction(buttonTitle: "Animate rotation", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                animatingView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        })
        
        scaleAction = DemoSectionViewAction(buttonTitle: "Animate scale", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            translateAction?.button?.isEnabled = true
            rotateAction?.button?.isEnabled = true
            scaleAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            UIView.animate(withDuration: 1.0, animations: {
                animatingView.transform = CGAffineTransform.identity
            })
        })
        
        let actions = [translateAction!, rotateAction!, scaleAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createMultiTransformSection() -> DemoSectionView {
        let sectionTitle = "Multiple Transforms"
        let description = "To apply multiple transforms at the same time, we have to concatenate each individual transform into a single CGAffineTransform object. This is most easily done by either calling the concatenating() method on one of the transforms, passing in the second transform, or the `translatedBy`/`scaledBy`/`rotatedBy` methods on one of the transform to chain them.\n\nNote that since these are affine transforms, the order of the transforms does matter, especially with rotation and translation. These examples rotate then translate and translate then rotate, respectively. Note how 'rotate then translate' effectively translates the x of the view -100 points; this is because the coordinate plane of the square has been turned upside-down as a result of the rotation."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-multi-transform")
        let animatingView = self.createRedSquare()
        
        var rotateThenTranslateAction, translateThenRotateAction, resetAction: DemoSectionViewAction?
        rotateThenTranslateAction = DemoSectionViewAction(buttonTitle: "Rotate then Translate", actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = false
            translateThenRotateAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            UIView.animate(withDuration: 1.0, animations: {
                let rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
                let rotateAndTranslateTransform = rotateTransform.translatedBy(x: 100, y: 0)
                animatingView.transform = rotateAndTranslateTransform
            })
        })
        
        translateThenRotateAction = DemoSectionViewAction(buttonTitle: "Translate then Rotate", actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = false
            translateThenRotateAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            UIView.animate(withDuration: 1.0, animations: {
                let translateTransform = CGAffineTransform(translationX: 100, y: 0)
                let translateAndRotateTransform = translateTransform.rotated(by: CGFloat.pi)
                animatingView.transform = translateAndRotateTransform
            })
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = true
            translateThenRotateAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            
            UIView.animate(withDuration: 1.0, animations: {
                animatingView.transform = CGAffineTransform.identity
            })
        })
        
        let actions = [rotateThenTranslateAction!, translateThenRotateAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createOptionsRepeatingSection() -> DemoSectionView {
        let sectionTitle = "Repeating"
        let description = "There are a bunch of other options you can give the animation method, including a delay, a completion block, and an array of options. One of these options is the ability to set an animation to repeat (UIViewAnimationOptions.repeat) and, when repeating, automatically reverse each time (UIViewAnimationOptions.autoreverse).\n\nStopping repeating block-based animations is one of the caveats of them; to stop them, you have to remove all animations from the view's layer and reset the view to its defaults manually, and it looks pretty janky."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-repeat")
        let animatingView = self.createRedSquare()
        
        var animateAction, stopAnimateAction: DemoSectionViewAction?
        animateAction = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                animateAction?.button?.isEnabled = false
                stopAnimateAction?.button?.isEnabled = true
                animatingView.alpha = 0
                animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
        })
        
        stopAnimateAction = DemoSectionViewAction(buttonTitle: "Stop", startsEnabled: false, actionBlock: {
            animateAction?.button?.isEnabled = true
            stopAnimateAction?.button?.isEnabled = false
            animatingView.layer.removeAllAnimations()
            animatingView.alpha = 1
            animatingView.transform = CGAffineTransform.identity
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [animateAction!, stopAnimateAction!])
        return animationSection
    }
    
    func createOptionsCurrentStateSection() -> DemoSectionView {
        let sectionTitle = "Competing Animations"
        let description = "When an animation block is started that animates properties already being animated from another block, UIKit will complete the previous animation and start the new animation. This behaviour can be seen with the previous alpha and color animations by quickly tapping 'Animate' while an animation is underway. Luckily, there's an animation option (UIViewAnimationOptions.beginFromCurrentState) that tells UIKit to begin the animation of a newly-started competing block with the current values from an already-running block.\n\nIn this example, the block will reverse its animation from its current state, so rapidly tapping the 'Animate' button will not cause it to first set the view's alpha to its destination value before starting the new block."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-current-state")
        let animatingView = self.createRedSquare()

        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .beginFromCurrentState, animations: {
                if (animatingView.alpha > 0) {
                    animatingView.alpha = 0
                } else {
                    animatingView.alpha = 1
                }
            }, completion: nil)
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createOptionsCurvesSection() -> DemoSectionView {
        let sectionTitle = "Animation Curves"
        let description = "Another set of animation options are built-in animation curves. When passed to the animate method, UIKit will calculate the animating properties according to the curve's underlying function. If a curve is not passed in, it defaults to UIViewAnimationOptions.curveLinear."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-curves")
        
        let (animatingView, square1, square2) = self.createViewWithTwoRedSquares()
        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
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
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createSpringDampingSection() -> DemoSectionView {
        let sectionTitle = "Spring Animations - Damping"
        let description = "Views can also be easily animated to have a spring behaviour with blocks. The level of 'springiness' is determined by the damping (usingSpringWithDamping:), a decimal value between 0 and 1. Damping is the inverse to 'springiness' - a lower damping means the view will rebound more, and a damping of 1 will cause the view to not rebound at all."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-spring")
        
        let (animatingView, square1, square2) = self.createViewWithTwoRedSquares()
        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
                if (square1.transform == CGAffineTransform.identity) {
                    square1.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square1.transform = CGAffineTransform.identity
                }
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                if (square2.transform == CGAffineTransform.identity) {
                    square2.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square2.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
    
    func createSpringVelocitySection() -> DemoSectionView {
        let sectionTitle = "Spring Animations - Velocity"
        let description = "Intial velocity, or the initial takeoff speed, of the view can be set on a springing animation by setting the 'initialSpringVelocity' parameter of the animation method call. It's a decimal value based on the total distance of the animation, where a value of 1 means the animation's velocity will be the distance travelled in one second. The 'animation distance' is the difference between the animated properties' current value and to-value.\n\nFor example, given a translation animation of 100 points over 1 second, an 'initial spring velocity' of 2.0 means it will begin the animation moving at 200points/second. Note that the animation will still take only 1 second to complete; UIKit will do all the math to make the animation start at the speed of 200points/second, but slow down at the correct points over the animation curve.\n\nPrecise calculation of the spring velocity is generally not required unless you need to match the view's current velocity; usually, it's a 'tinker with this until it feels right' kind of value."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-spring-velocity")
        
        let (animatingView, square1, square2) = self.createViewWithTwoRedSquares()
        let action = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: [], animations: {
                if (square1.transform == CGAffineTransform.identity) {
                    square1.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square1.transform = CGAffineTransform.identity
                }
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                if (square2.transform == CGAffineTransform.identity) {
                    square2.transform = CGAffineTransform(translationX: 100, y: 0)
                } else {
                    square2.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: [action])
        return animationSection
    }
}
