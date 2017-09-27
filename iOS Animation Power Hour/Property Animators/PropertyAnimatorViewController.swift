
import UIKit

class PropertyAnimatorViewController: UIViewController {
    var sections = [DemoSectionView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Property Animators"
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
        
        let basicsSection = self.createBasicsSection()
        self.sections.append(basicsSection)
        stackView.addArrangedSubview(basicsSection)
        
        let statesSection = self.createStatesSection()
        self.sections.append(statesSection)
        stackView.addArrangedSubview(statesSection)
        
        let reversedSection = self.createReverseSection()
        self.sections.append(reversedSection)
        stackView.addArrangedSubview(reversedSection)
    }
}

extension PropertyAnimatorViewController {
    func createBasicsSection() -> DemoSectionView {
        let sectionTitle = "Basics"
        let description = "Property animators work largely the same way as block-based animations, though give us the ability to start, pause, resume, reverse, scrub, and otherwise dynamically modify animations by keeping reference to the animator.\n\nThey have four main init methods, each with their own level of customization. The simplest is the `init(duration: curve: animations:)` initializer."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-basics")
        let animatingView = self.createRedSquare()
        
        var startAction, pauseAction, resetAction: DemoSectionViewAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: {
                animatingView.alpha = 0
                animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.addCompletion({_ in
                startAction?.button?.isEnabled = false
                pauseAction?.button?.isEnabled = false
                resetAction?.button?.isEnabled = true
            })
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = DemoSectionViewAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            propertyAnimator.startAnimation()
        })
        
        pauseAction = DemoSectionViewAction(buttonTitle: "Pause", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            propertyAnimator.pauseAnimation()
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = false
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            animatingView.alpha = 1
            animatingView.transform = CGAffineTransform.identity
        })
        
        let actions = [startAction!, pauseAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createStatesSection() -> DemoSectionView {
        let sectionTitle = "States"
        let description = "Property animators have three states: `inactive`, `active`, and `stopped`. They begin in the `inactive` state, move to the active state when `startAnimation` is called, and, after the animation completes, moves back to the `inactive` state. Pausing the animation doesn't affect its state - it will still be in the `active` state. An animator that reaches its `inactive` state is considered finished and can't be animated any further unless its `pausesOnCompletion` property is `true`, which allows it to still be reversed or scrubbed once finished.\n\nThe `stopped` state is a peculiar case. To stop an animation, you call `stopAnimation`. Stopping an animation means that it won’t be continuable; that it’s done. `stopAnimation` takes a boolean value determining whether it should finish immediately (clear the animation stack and set the view’s animating properties to the current visible values) and go immediately to the `inactive` state or whether it should wait for you to manually call `finishAnimation`. While waiting for you to manually finish the animation, it will be in the `stopped` state.\n\nThe advantage of manually calling `finishAnimation` is that you can specificy whether the animation finishes by setting the view's animating properties to their current values, its starting values from before the animation, or the values expected at the end of the animation.\n\nThere is also the animator's `isRunning` property, which is effectively a fourth state. This is `true` when the animation is actually animating, and `false` when paused, stopped, or inactive."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-states")
        let (animatingView, square, label) = self.createViewWithSquareAndLabel()
        
        var startAction, pauseAction, stopAction, finishAction, resetAction: DemoSectionViewAction?
        
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
        
        startAction = DemoSectionViewAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = true
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.startAnimation()
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        pauseAction = DemoSectionViewAction(buttonTitle: "Pause", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.pauseAnimation()
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        stopAction = DemoSectionViewAction(buttonTitle: "Stop", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.stopAnimation(false) //don't immediately finish
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        finishAction = DemoSectionViewAction(buttonTitle: "Finish", startsEnabled: false, actionBlock: {
            guard propertyAnimator.state == .stopped else { return }
            
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.finishAnimation(at: .current)
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = false
            
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            label.text = "State: \(string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        let actions = [startAction!, pauseAction!, stopAction!, finishAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createReverseSection() -> DemoSectionView {
        let sectionTitle = "Reversing"
        let description = "Getting a property animator to reverse its animation is as simple as settings it `isReversed` property to `true`. This can effectively be repeated forever if `isReversed` is inversed and `startAnimation` is called whenever the animation reaches the beginning/end. `pausesOnCompletion` should be set to `true` as well so that when the animation finishes for the first time, it pauses instead of entering its `inactive` state so it can continue to be used. There is currently no API to add a callback for when a property animator reaches its beginning/end points (added completion blocks are only called when it reaches its `inactive` state and finishes), so an infinitely repeating animation would be better done with a block animation.\n\nNote with the example that if the animation reaches one of its ends, it will pause (as expected with `pausesOnCompletion = true`), meaning that 'Start/Resume' will have to be called again at these points."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let (animatingView, square, label) = self.createViewWithSquareAndLabel()
        label.text = "isInversed = false (shrinking)"
        
        var startAction, changeDirectionAction, resetAction: DemoSectionViewAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.pausesOnCompletion = true
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = DemoSectionViewAction(buttonTitle: "Start/Resume", actionBlock: {
            propertyAnimator.startAnimation()
        })
        
        changeDirectionAction = DemoSectionViewAction(buttonTitle: "Change direction", actionBlock: {
            propertyAnimator.isReversed = !propertyAnimator.isReversed
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        let actions = [startAction!, changeDirectionAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createScrubbingSection() -> DemoSectionView {
        let sectionTitle = "Scrubbing"
        let description = "One of the most powerful features of property animators is scrubbing. It allows us to, while the animation is in flight, change the current point of the animation (in turn setting the properties being animated to their values at that point in the animation). This is done by setting the `fractionComplete` property to a decimal value between `0` and `1`, where `0` is the start of the animation and `1` is the end."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let (animatingView, square, label) = self.createViewWithSquareAndLabel()
        label.text = "isInversed = false (shrinking)"
        
        var startAction, changeDirectionAction, resetAction: DemoSectionViewAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.pausesOnCompletion = true
            return propertyAnimator
        }
        var propertyAnimator = createPropertyAnimator()
        
        startAction = DemoSectionViewAction(buttonTitle: "Start/Resume", actionBlock: {
            propertyAnimator.startAnimation()
        })
        
        changeDirectionAction = DemoSectionViewAction(buttonTitle: "Change direction", actionBlock: {
            propertyAnimator.isReversed = !propertyAnimator.isReversed
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        resetAction = DemoSectionViewAction(buttonTitle: "Reset", startsEnabled: false, actionBlock: {
            propertyAnimator.stopAnimation(true)
            propertyAnimator = createPropertyAnimator()
            square.transform = CGAffineTransform.identity
            label.text = (propertyAnimator.isReversed) ? "isInversed = true (growing)" : "isInversed = false (shrinking)"
        })
        
        let actions = [startAction!, changeDirectionAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
}
