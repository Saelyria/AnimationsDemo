
import UIKit

class PropertyAnimatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Property Animators"
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
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 1
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: -160).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
        
        let basicsSection = self.createBasicsSection()
        stackView.addArrangedSubview(basicsSection)
        
        let statesSection = self.createStatesSection()
        stackView.addArrangedSubview(statesSection)
        
        let reversedSection = self.createReverseSection()
        stackView.addArrangedSubview(reversedSection)
        
        let scrubbbingSection = self.createScrubbingSection()
        stackView.addArrangedSubview(scrubbbingSection)
        
        let addAnimationSection = self.createAddAnimationSection()
        stackView.addArrangedSubview(addAnimationSection)
        
        let customCurveSection = self.createTimingCurvesSection()
        stackView.addArrangedSubview(customCurveSection)
        
        let providersSection = self.createTimingObjectsSection()
        stackView.addArrangedSubview(providersSection)
    }
}

extension PropertyAnimatorViewController {
    func createBasicsSection() -> ExampleViewCell {
        let sectionTitle = "Basics"
        let description = "Property animators work largely the same way as block-based animations, though give us the ability to start, pause, resume, reverse, scrub, and otherwise dynamically modify animations by keeping reference to the animator.\n\nThey have four main init methods, each with their own level of customization. The simplest are the `init(duration: curve: animations:)` and `init(duration: dampingRatio: animations:)` initializers, whose parameters are basically the same as their block-based relatives. The curve is a `UIViewAnimationCurve` (one of either `easeInOut`, `easeIn`, `easeOut`, or `linear`), and `dampingRatio` is a decimal between `0` and `1` with an inverse effect on 'bounciness', just like in block-based animations. There is also the class method `runningPropertyAnimator(withDuration: delay: options: animations: completion:)`, which is basically a block-based animation masquerading as a property animator."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-basics")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let redSquare = animationExampleView.redSquares.first!
        
        var startAction, pauseAction, resetAction: ExampleViewControllerButtonAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: {
                redSquare.alpha = 0
                redSquare.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.addCompletion({_ in
                startAction?.button?.isEnabled = false
                pauseAction?.button?.isEnabled = false
                resetAction?.button?.isEnabled = true
            })
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = ExampleViewControllerButtonAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            propertyAnimator.startAnimation()
        })
        
        pauseAction = ExampleViewControllerButtonAction(buttonTitle: "Pause", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.pauseAnimation()
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = false
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            redSquare.alpha = 1
            redSquare.transform = CGAffineTransform.identity
        })
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [startAction!, pauseAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createStatesSection() -> ExampleViewCell {
        let sectionTitle = "States"
        let description = "Property animators have three states: `inactive`, `active`, and `stopped`. They begin in the `inactive` state, move to the active state when `startAnimation` is called, and, after the animation completes, moves back to the `inactive` state. Pausing the animation doesn't affect its state - it will still be in the `active` state. An animator that reaches its `inactive` state is considered finished and can't be animated any further unless its `pausesOnCompletion` property is `true`, which allows it to still be reversed or scrubbed once finished.\n\nThe `stopped` state is a peculiar case. To stop an animation, you call `stopAnimation`. Stopping an animation means that it won’t be continuable; that it’s done. `stopAnimation` takes a boolean value determining whether it should finish immediately (clear the animation stack and set the view’s animating properties to the current visible values) and go immediately to the `inactive` state or whether it should wait for you to manually call `finishAnimation`. While waiting for you to manually finish the animation, it will be in the `stopped` state.\n\nThe advantage of manually calling `finishAnimation` is that you can specificy whether the animation finishes by setting the view's animating properties to their current values, its starting values from before the animation, or the values expected at the end of the animation.\n\nThere is also the animator's `isRunning` property, which is effectively a fourth state. This is `true` when the animation is actually animating, and `false` when paused, stopped, or inactive."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-states")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .label])
        let square = animationExampleView.redSquares.first!
        let label = animationExampleView.label!
        
        var startAction, pauseAction, stopAction, finishAction, resetAction: ExampleViewControllerButtonAction?
        
        func string(forPropertyAnimatorState state: UIViewAnimatingState) -> String {
            switch state {
            case .active: return "active"
            case .inactive: return "inactive"
            case .stopped: return "stopped"
            }
        }
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.addCompletion({ _ in
                label.text = "State: inactive"
                startAction?.button?.isEnabled = false
                pauseAction?.button?.isEnabled = false
                stopAction?.button?.isEnabled = false
                finishAction?.button?.isEnabled = false
                resetAction?.button?.isEnabled = true
            })
            return propertyAnimator
        }
        
        var propertyAnimator = createPropertyAnimator()
        label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        
        startAction = ExampleViewControllerButtonAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = true
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.startAnimation()
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        pauseAction = ExampleViewControllerButtonAction(buttonTitle: "Pause", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.pauseAnimation()
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        stopAction = ExampleViewControllerButtonAction(buttonTitle: "Stop", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.stopAnimation(false) //don't immediately finish
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        finishAction = ExampleViewControllerButtonAction(buttonTitle: "Finish", startsEnabled: false, actionBlock: {
            guard propertyAnimator.state == .stopped else { return }
            
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.finishAnimation(at: .current)
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            if propertyAnimator.state == .stopped {
                propertyAnimator.finishAnimation(at: .current)
            } else {
                propertyAnimator.stopAnimation(true)
            }
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
            
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = false
        })
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [startAction!, pauseAction!, stopAction!, finishAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createReverseSection() -> ExampleViewCell {
        let sectionTitle = "Reversing"
        let description = "Getting a property animator to reverse its animation is as simple as settings it `isReversed` property to `true`. This can effectively be repeated forever if `isReversed` is inversed and `startAnimation` is called whenever the animation reaches the beginning/end. On iOS 11 or later, `pausesOnCompletion` should be set to `true` as well so that when the animation finishes for the first time, it pauses instead of entering its `inactive` state so it can continue to be used. There is currently no API to add a callback for when a property animator reaches its beginning/end points (added completion blocks are only called when it reaches its `inactive` state and finishes), so an infinitely repeating animation would be better done with a block animation.\n\nNote with the example that if the animation reaches one of its ends, it will pause on iOS 11 (as expected with `pausesOnCompletion = true`), meaning that 'Start/Resume' will have to be called again at these points. On iOS 10, changing `isReversed` will do nothing on completion as the animator will have finished."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-reverse")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare, .label])
        let square = animationExampleView.redSquares.first!
        let label = animationExampleView.label!
        label.text = "isInversed = false (shrinking)"
        
        var startAction, changeDirectionAction, resetAction: ExampleViewControllerButtonAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            if #available(iOS 11.0, *) {
                propertyAnimator.pausesOnCompletion = true
            }
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = ExampleViewControllerButtonAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.startAnimation()
        })
        
        changeDirectionAction = ExampleViewControllerButtonAction(buttonTitle: "Change direction", actionBlock: {
            startAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.isReversed = !propertyAnimator.isReversed
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [startAction!, changeDirectionAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createScrubbingSection() -> ExampleViewCell {
        let sectionTitle = "Scrubbing"
        let description = "One of the most powerful features of property animators is scrubbing. It allows us to, while the animation is in flight, change the current point of the animation (in turn setting the properties being animated to their values at that point in the animation). This is done by setting the `fractionComplete` property to a decimal value between `0` and `1`, where `0` is the start of the animation and `1` is the end. This can be used to make animations interactive or based on any other condition you can think of, like the progress of a download."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-scrubbing")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let square = animationExampleView.redSquares.first!
        
        let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
            square.alpha = 0
            square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })

        let sliderAction = ExampleViewControllerSliderAction { sliderValue in
            propertyAnimator.fractionComplete = CGFloat(sliderValue)
        }
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: [sliderAction])
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createAddAnimationSection() -> ExampleViewCell {
        let sectionTitle = "Adding Animations and Completions"
        let description = "Another interesting feature of property animators is the ability to dynamically add animations to them while running. This is done by passing a block to the `addAnimations(_:)` method of the animator, passing in a closure declaring the desired end value, just like the original closure. An animation added while the original is running (`state == .active`) will animate with the duration remaining on the animation. So, for example, if the animation was originally created to last four seconds and an `alpha = 0` animation closure is passed in halfway through (`fractionComplete == 0.5`), it will fade the alpha from `1` to `0` over the remaining two seconds.\n\nAnimations can be added to property animators post-mortem as well (i.e. they've finished and their `state` is `inactive`). Animations added at this point will run with the duration originally specified. Note, however, that it is considered a programmer error to add an animation while the animator's `state` is `stopped`.\n\nCompletion blocks are added in basically the same way - simply call `addCompletion(:)` with a closure. Note that completions are only called when an animator reaches its `inactive` state, so will not be called if an animation finishes and its `pausesOnCompletion` is `true` as it will remain in the `active` state."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-add")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let square = animationExampleView.redSquares.first!
        
        var startAction, addAlphaAction, addScaleAction, resetAction: ExampleViewControllerButtonAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 10.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(translationX: 100, y: 0)
            })
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = ExampleViewControllerButtonAction(buttonTitle: "Start", actionBlock: {
            startAction?.button?.isEnabled = false
            addAlphaAction?.button?.isEnabled = true
            addScaleAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            propertyAnimator.startAnimation()
        })
        
        addAlphaAction = ExampleViewControllerButtonAction(buttonTitle: "Add Alpha Animation", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = false
            addAlphaAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.addAnimations({
                square.alpha = 0
            })
        })
        
        addScaleAction = ExampleViewControllerButtonAction(buttonTitle: "Add Color Animation", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = false
            addScaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.addAnimations({
                square.backgroundColor = UIColor.blue
            })
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            addAlphaAction?.button?.isEnabled = false
            addScaleAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = false
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            square.alpha = 1
            square.backgroundColor = UIColor.red
        })
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [startAction!, addAlphaAction!, addScaleAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createTimingCurvesSection() -> ExampleViewCell {
        let sectionTitle = "Custom Timing Curves"
        let description = "It's possible to create custom timing functions for animations by using one of the property animator's other initializers, `init(duration: controlPoint1: controlPoint2: animations:)`. It takes two `CGPoint`s (UIKit's point class, containing an `x` and `y` value) used to define a Bézier curve that UIKit will use to determine the animation points. Bézier curve creation tools are fairly abundant and can be used to find a curve that matches the kind of animation you want. Note that mathematically, Bézier curves can be created with more than two control points to create lines with multiple curves, though `UIViewPropertyAnimator` only supports two. To do more than two, you will need to create your own property animator class, as described in 'Advanced Animations'."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-timing-curves")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let square = animationExampleView.redSquares.first!
        
        var firstBezierAction, secondBezierAction, resetAction: ExampleViewControllerButtonAction?
        
        var propertyAnimator: UIViewPropertyAnimator?
        
        firstBezierAction = ExampleViewControllerButtonAction(buttonTitle: "Animate Bézier 1", actionBlock: {
            firstBezierAction?.button?.isEnabled = false
            secondBezierAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            let controlPoint1 = CGPoint(x: 0.2, y: 1.36)
            let controlPoint2 = CGPoint(x: 0.83, y: -0.33)
            propertyAnimator = UIViewPropertyAnimator(duration: 2.0, controlPoint1: controlPoint1, controlPoint2: controlPoint2) {
                square.transform = CGAffineTransform(translationX: 100, y: 0)
            }
            
            propertyAnimator?.startAnimation()
        })
        
        secondBezierAction = ExampleViewControllerButtonAction(buttonTitle: "Animate Bézier 2", actionBlock: {
            firstBezierAction?.button?.isEnabled = false
            secondBezierAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            let controlPoint1 = CGPoint(x: 0.0, y: 0.0)
            let controlPoint2 = CGPoint(x: 1.0, y: 1.0)
            propertyAnimator = UIViewPropertyAnimator(duration: 2.0, controlPoint1: controlPoint1, controlPoint2: controlPoint2) {
                square.transform = CGAffineTransform(translationX: 100, y: 0)
            }
            
            propertyAnimator?.startAnimation()
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            firstBezierAction?.button?.isEnabled = true
            secondBezierAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            propertyAnimator?.stopAnimation(true)
            propertyAnimator = nil
            square.transform = CGAffineTransform.identity
        })
        
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [firstBezierAction!, secondBezierAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
    
    func createTimingObjectsSection() -> ExampleViewCell {
        let sectionTitle = "Timing Curve Providers"
        let description = "You can store animation parameters like curve, control points, or damping in a timing curve provider, along with a handful of other, more advanced animation parameters. A timing provider is any object conforming to `UITimingCurveProvider`, though you are most likely to use one of its concrete implementers, `UICubicTimingParameters` or `UISpringTimingParameters`. The cubic parameters object can be created with one of the default `UIViewAnimationCurve`s, (as described in 'Basics') or a Bézier curve made with two control points. To create a spring timing object, you are expected to provide a combination of damping, initial velocity, and/or mass and stiffness.\n\nNote that with the `init(duration: timingParameters:)` initializer for the property animator, you do not pass in the animations block; these must be added with an `addAnimations(_:)` call."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-curve-providers")
        let animationExampleView = AnimationExampleView(withComponents: [.redSquare])
        let square = animationExampleView.redSquares.first!
        
        var startAction, resetAction: ExampleViewControllerButtonAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let timingParameters = UISpringTimingParameters(dampingRatio: 4.0, initialVelocity: CGVector(dx: 1, dy: 1))
            let propertyAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: timingParameters)
            propertyAnimator.addAnimations {
                square.alpha = 0
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = ExampleViewControllerButtonAction(buttonTitle: "Start", actionBlock: {
            startAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.startAnimation()
        })
        
        resetAction = ExampleViewControllerButtonAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = false
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.alpha = 1
            square.transform = CGAffineTransform.identity
        })
        
        let cell = ExampleViewCell(title: sectionTitle, description: description, onTapAction: {
            let actions = [startAction!, resetAction!]
            let animationSection = ExampleViewController(title: sectionTitle, description: description, sampleCode: sampleCode, animationExampleView: animationExampleView, actions: actions)
            self.navigationController?.pushViewController(animationSection, animated: true)
        })
        
        return cell
    }
}
