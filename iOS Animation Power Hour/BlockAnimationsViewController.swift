
import UIKit

class BlockAnimationsViewController: UIViewController {
    var sections = [DemoSectionView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Block-Based Animations"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } 
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
        
        let basicsAnimationSection = self.createBasicsSection()
        self.sections.append(basicsAnimationSection)
        stackView.addArrangedSubview(basicsAnimationSection)
        
        let frameAnimationSection = self.createFrameSection()
        self.sections.append(frameAnimationSection)
        stackView.addArrangedSubview(frameAnimationSection)
        
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
    func createBasicsSection() -> DemoSectionView {
        let sectionTitle = "Basics"
        let description = "Block-based animations in iOS are simple and declarative. To start an animation, call the `UIView` class method `animate(withDuration:animations:)`, passing in the duration of the animation and a block. Inside the block, simply set the properties of the animating view to the values you want them to be after the duration, and UIKit will automatically do the tweening to get there.\n\nIn this example, we'll use a view's alpha and background color.\n\nAlpha is a decimal number between `0` and `1`, with a default value of `1`. The color of a view is determined by its `backgroundColor`. Background color is a `UIColor`, UIKit's color class. On a newly-made `UIView` this is set to `UIColor.clear`, or (r:0 g:0 b:0 a:0)."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-alpha")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!
        
        let action = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, animations: {
                if (redSquare.alpha > 0) {
                    redSquare.alpha = 0
                } else {
                    redSquare.alpha = 1
                }
                
                if (redSquare.backgroundColor != UIColor.red) {
                    redSquare.backgroundColor = UIColor.red
                } else {
                    redSquare.backgroundColor = UIColor.blue
                }
            })
        })

        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [action])
        return animationSection
    }
    
    func createFrameSection() -> DemoSectionView {
        let sectionTitle = "Frame and Bounds"
        let description = "Before Autolayout, iOS views were laid out by settings the `x`/`y`/`width`/`height` of views' `frame` and `bounds` properties, called 'springs and struts'. This method has been largely replaced with constraints, though both frame and bounds are still important values (and animatable). Understanding the difference between them is important as, in many cases, they can be the same value.\n\nFirst, frame. A view's frame is its location in its superview's coordinate system. So, a frame's `x` and `y` properties are the distance from the superview's origin (its top left corner). Think of a picture frame on a wall; the frame is the positioning on the wall along with its height and width.\n\nNext, bounds. A view's bounds is the visible portion of its content in its own coordinate system, where its origin is always the top-left corner of its frame. Think of it like two pieces of paper on top of each other. The frame is like a square hole cut into the top piece of paper that lets the bottom piece of paper show through. The bounds is which part of the bottom piece of paper is being seen through the hole. Subviews base their frame on their superview’s bounds (the bottom piece of paper), so moving the bottom paper moves the view’s subviews accordingly. This is how scroll views work; their frame (position in their superview) remains unchanged when it scrolls, though it changes the `y` of its bounds so its subviews move up or down.\n\nThe example below demonstrates animating these properties individually to help visualize the difference. The blue square is a subview of the red square; the 'Animate Frame' and 'Animate Bounds' buttons will change the frame and bounds of the red square. When we move the red square's frame, it (and its subviews) move in the grey space's coordinate system. When we move the red square's bounds, the red square's position in its superview doesn't change, but its subviews move. Moving the bounds' `x` positively by `50` sets the top left corner of the visible area in the red square to `(50,0)`. Because the blue square's frame is based on the orignal top-left corner of the red square `(0,0)`, it moves to the right along with that original origin."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-frame")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .blueSquareInRedSquare])
        let redSquare = animationExampleView.redSquares.first!
        
        var originalFrame: CGRect?
        var originalBounds: CGRect?
        let frameAction = DemoSectionViewButtonAction(buttonTitle: "Animate Frame", actionBlock: {
            if (originalFrame == nil) {
                originalFrame = redSquare.frame
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                if (redSquare.frame == originalFrame!) {
                    let newX = redSquare.frame.origin.x+50
                    redSquare.frame = CGRect(x: newX, y: redSquare.frame.origin.y, width: redSquare.frame.size.width, height: redSquare.frame.size.height)
                } else {
                    redSquare.frame = originalFrame!
                }
            })
        })
        
        let boundsAction = DemoSectionViewButtonAction(buttonTitle: "Animate Bounds", actionBlock: {
            if (originalBounds == nil) {
                originalBounds = redSquare.bounds
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                if (redSquare.bounds == originalBounds!) {
                    let newX = redSquare.bounds.origin.x+50
                    redSquare.bounds.origin = CGPoint(x: newX, y: redSquare.bounds.origin.y)
                } else {
                    redSquare.bounds = originalBounds!
                }
            })
        })
        
        let actions = [frameAction, boundsAction]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
        return animationSection
    }
    
    func createTransformSection() -> DemoSectionView {
        let sectionTitle = "Transform"
        let description = "A transform is an instance of `CGAffineTransform`. A single `CGAffineTransform` instance describes a type of transform, such as a translation, rotation, or scaling, and the function to get to it, with each type having its own initializer. Rotations are defined in radians (multiples of pi), translation is in screen points, and scale is a decimal where 1 is always the original size of the view in question.\n\nTo apply a transform to a view, create a `CGAffineTransform` object and set the view's `transform` property to the created transform. `CGAffineTransform` has a class property called `identity` that represents an unmodified transform; to reset the transform of a view, set its `transform` property to this property.\n\nNote that there are a couple other steps to apply these transforms at the same time, as they need to be concatenated into a single transform object."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!

        var rotateAction, scaleAction, translateAction, resetAction: DemoSectionViewButtonAction?
        translateAction = DemoSectionViewButtonAction(buttonTitle: "Animate translation", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                redSquare.transform = CGAffineTransform(translationX: 100, y: 0)
            })
        })
        
        rotateAction = DemoSectionViewButtonAction(buttonTitle: "Animate rotation", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                redSquare.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        })
        
        scaleAction = DemoSectionViewButtonAction(buttonTitle: "Animate scale", actionBlock: {
            translateAction?.button?.isEnabled = false
            rotateAction?.button?.isEnabled = false
            scaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            UIView.animate(withDuration: 1.0, animations: {
                redSquare.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        })
        
        resetAction = DemoSectionViewButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            translateAction?.button?.isEnabled = true
            rotateAction?.button?.isEnabled = true
            scaleAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            UIView.animate(withDuration: 1.0, animations: {
                redSquare.transform = CGAffineTransform.identity
            })
        })
        
        let actions = [translateAction!, rotateAction!, scaleAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
        return animationSection
    }
    
    func createMultiTransformSection() -> DemoSectionView {
        let sectionTitle = "Multiple Transforms"
        let description = "To apply multiple transforms at the same time, we have to concatenate each individual transform into a single `CGAffineTransform` object. This is most easily done by either calling the `concatenating()` method on one of the transforms, passing in the second transform, or the `translatedBy()`/`scaledBy()`/`rotatedBy()` methods on one of the transform to chain them.\n\nNote that since these are affine transforms, the order of the transforms does matter, especially with rotation and translation. These examples rotate then translate and translate then rotate, respectively. Note how 'Rotate then Translate' effectively translates the `x` of the view `-100` points and the `y -25` points; this is because the coordinate plane of the square has been turned upside-down as a result of the rotation being applied before the translation."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-multi-transform")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!
        
        var rotateThenTranslateAction, translateThenRotateAction, resetAction: DemoSectionViewButtonAction?
        rotateThenTranslateAction = DemoSectionViewButtonAction(buttonTitle: "Rotate then Translate", actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = false
            translateThenRotateAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            UIView.animate(withDuration: 1.0, animations: {
                let rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
                let rotateAndTranslateTransform = rotateTransform.translatedBy(x: 100, y: 25)
                redSquare.transform = rotateAndTranslateTransform
            })
        })
        
        translateThenRotateAction = DemoSectionViewButtonAction(buttonTitle: "Translate then Rotate", actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = false
            translateThenRotateAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            UIView.animate(withDuration: 1.0, animations: {
                let translateTransform = CGAffineTransform(translationX: 100, y: 25)
                let translateAndRotateTransform = translateTransform.rotated(by: CGFloat.pi)
                redSquare.transform = translateAndRotateTransform
            })
        })
        
        resetAction = DemoSectionViewButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            rotateThenTranslateAction?.button?.isEnabled = true
            translateThenRotateAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            
            UIView.animate(withDuration: 1.0, animations: {
                redSquare.transform = CGAffineTransform.identity
            })
        })
        
        let actions = [rotateThenTranslateAction!, translateThenRotateAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
        return animationSection
    }
    
    func createOptionsRepeatingSection() -> DemoSectionView {
        let sectionTitle = "Repeating"
        let description = "There are a bunch of other options you can give the animation method, including a delay, a completion block, and an array of options. One of these options is the ability to set an animation to repeat (`UIViewAnimationOptions.repeat`) and, when repeating, automatically reverse each time (`UIViewAnimationOptions.autoreverse`).\n\nStopping repeating block-based animations is one of the caveats of them; to stop them, you have to remove all animations from the view's layer and reset the view to its defaults manually, and it looks pretty janky."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-repeat")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!
        
        var animateAction, stopAnimateAction: DemoSectionViewButtonAction?
        animateAction = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                animateAction?.button?.isEnabled = false
                stopAnimateAction?.button?.isEnabled = true
                redSquare.alpha = 0
                redSquare.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
        })
        
        stopAnimateAction = DemoSectionViewButtonAction(buttonTitle: "Stop", startsEnabled: false, actionBlock: {
            animateAction?.button?.isEnabled = true
            stopAnimateAction?.button?.isEnabled = false
            redSquare.layer.removeAllAnimations()
            redSquare.alpha = 1
            redSquare.transform = CGAffineTransform.identity
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [animateAction!, stopAnimateAction!])
        return animationSection
    }
    
    func createOptionsCurrentStateSection() -> DemoSectionView {
        let sectionTitle = "Competing Animations"
        let description = "When an animation block is started that animates properties already being animated from another block, UIKit will complete the previous animation and start the new animation. This behaviour can be seen with the previous alpha and color animations by quickly tapping 'Animate' while an animation is underway. Luckily, there's an animation option (`UIViewAnimationOptions.beginFromCurrentState`) that tells UIKit to begin the animation of a newly-started competing block with the current values from an already-running block.\n\nIn this example, the block will reverse its animation from its current state, so rapidly tapping the 'Animate' button will not cause it to first set the view's alpha to its destination value before starting the new block."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-current-state")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!

        let action = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .beginFromCurrentState, animations: {
                if (redSquare.alpha > 0) {
                    redSquare.alpha = 0
                } else {
                    redSquare.alpha = 1
                }
            }, completion: nil)
        })
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [action])
        return animationSection
    }
    
    func createOptionsCurvesSection() -> DemoSectionView {
        let sectionTitle = "Animation Curves"
        let description = "Another set of animation options are built-in animation curves. When passed to the animate method, UIKit will calculate the animating properties according to the curve's underlying function. If a curve is not passed in, it defaults to `UIViewAnimationOptions.curveLinear`."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-options-curves")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .secondRedSquare])
        let square1 = animationExampleView.redSquares.first!
        let square2 = animationExampleView.redSquares[1]
        
        let action = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
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
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [action])
        return animationSection
    }
    
    func createSpringDampingSection() -> DemoSectionView {
        let sectionTitle = "Spring Animations - Damping"
        let description = "Views can also be easily animated to have a spring behaviour with blocks. The level of 'springiness' is determined by the damping (`usingSpringWithDamping:` portion of the method signature), a decimal value between `0` and `1`. Damping is the inverse to 'springiness' - a lower damping means the view will rebound more, and a damping of `1` will cause the view to not rebound at all."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-spring")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .secondRedSquare])
        let square1 = animationExampleView.redSquares.first!
        let square2 = animationExampleView.redSquares[1]
        
        let action = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
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
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [action])
        return animationSection
    }
    
    func createSpringVelocitySection() -> DemoSectionView {
        let sectionTitle = "Spring Animations - Velocity"
        let description = "Intial velocity, or the initial takeoff speed, of the view can be set on a springing animation by setting the `initialSpringVelocity:` parameter of the animation method call. It's a decimal value based on the total distance of the animation, where a value of `1` means the animation's velocity will be the distance travelled in one second. The 'animation distance' is the difference between the animated properties' current value and destination value.\n\nFor example, given a translation animation of 100 points over 1 second, an 'initial spring velocity' of `2.0` means it will begin the animation moving at 200points/second. Note that the animation will still take only 1 second to complete; UIKit will do all the math to make the animation start at the speed of 200points/second, but slow down at the correct points over the animation curve.\n\nPrecise calculation of the spring velocity is generally not required unless you need to match the view's current velocity; usually, it's a 'tinker with this until it feels right' kind of value."
        let sampleCode = self.stringFromCodeSampleFile(named: "animation-spring-velocity")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .secondRedSquare])
        let square1 = animationExampleView.redSquares.first!
        let square2 = animationExampleView.redSquares[1]
        
        let action = DemoSectionViewButtonAction(buttonTitle: "Animate", actionBlock: {
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
        
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [action])
        return animationSection
    }
}
