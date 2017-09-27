
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
    }
}

extension PropertyAnimatorViewController {
    func createBasicsSection() -> DemoSectionView {
        let sectionTitle = "Basics"
        let description = "Property animators work largely the same way as block-based animations, though give us the ability to start, pause, resume, reverse, scrub, and otherwise dynamically modify animations by keeping reference to the animator.\n\nThey have four main init methods, each with their own level of customization. The simplest is the `init(duration: curve: animations:)` initializer."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-basics")
        let animatingView = self.createRedSquare()
        
        var propertyAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: {
            animatingView.alpha = 0
            animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        
        let startAction = DemoSectionViewAction(buttonTitle: "Animate", actionBlock: {
            propertyAnimator.startAnimation()
        })
        
        let pauseAction = DemoSectionViewAction(buttonTitle: "Pause", actionBlock: {
            propertyAnimator.pauseAnimation()
        })
        
        let resetAction = DemoSectionViewAction(buttonTitle: "Reset", actionBlock: {
            propertyAnimator.stopAnimation(true)
            propertyAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: {
                animatingView.alpha = 0
                animatingView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            animatingView.alpha = 1
            animatingView.transform = CGAffineTransform.identity
        })
        
        let actions = [startAction, pauseAction, resetAction]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createStatesSection() -> DemoSectionView {
        let sectionTitle = "States"
        let description = "Property animators have three states: `inactive`, `active`, and `stopped`. They begin in the `inactive` state, move to the active state when `startAnimation` is called, and, after the animation completes, moves back to the `inactive` state. Pausing the animation doesn't affect its state - it will still be in the `active` state. An animator that reaches its `inactive` state is considered finished and can't be animated any further unless its `pausesOnCompletion` property is `true`, which allows it to still be reversed or scrubbed once finished.\n\nThe `stopped` state is a peculiar case. To stop an animation, you call `stopAnimation`. Stopping an animation means that it won’t be continuable; that it’s done. `stopAnimation` takes a boolean value determining whether it should finish immediately (clear the animation stack and set the view’s animating properties to the current visible values) and go immediately to the `inactive` state or whether it should wait for you to manually call `finishAnimation`. While waiting for you to manually finish the animation, it will be in the `stopped` state.\n\nThe advantage of manually calling `finishAnimation` is that you can specificy whether the animation finishes by setting the view's animating properties to their current values, its starting values from before the animation, or the values expected at the end of the animation."
        let sampleCode = self.stringFromCodeSampleFile(named: "property-animator-states")
        let (animatingView, square, label) = self.createViewWithSquareAndLabel()
        
        var startAction, pauseAction, stopAction, finishAction, resetAction: DemoSectionViewAction?
        
        func createPropertyAnimator() -> UIViewPropertyAnimator {
            let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
                square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
            propertyAnimator.addCompletion { _ in
                label.text = "State: inactive"
                startAction?.button?.isEnabled = false
                pauseAction?.button?.isEnabled = false
                stopAction?.button?.isEnabled = false
                finishAction?.button?.isEnabled = false
                resetAction?.button?.isEnabled = true
            }
            return propertyAnimator
        }
        
        var propertyAnimator = createPropertyAnimator()
        label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
        
        startAction = DemoSectionViewAction(buttonTitle: "Start/Resume", actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = true
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.startAnimation()
            label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        pauseAction = DemoSectionViewAction(buttonTitle: "Pause", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = true
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = true
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.pauseAnimation()
            label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        stopAction = DemoSectionViewAction(buttonTitle: "Stop", startsEnabled: false, actionBlock: {
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = true
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.stopAnimation(false) //don't immediately finish
            label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        finishAction = DemoSectionViewAction(buttonTitle: "Finish", startsEnabled: false, actionBlock: {
            guard propertyAnimator.state == .stopped else { return }
            
            startAction?.button?.isEnabled = false
            pauseAction?.button?.isEnabled = false
            stopAction?.button?.isEnabled = false
            finishAction?.button?.isEnabled = false
            resetAction?.button?.isEnabled = true
            
            propertyAnimator.finishAnimation(at: .current)
            label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
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
            label.text = "State: \(self.string(forPropertyAnimatorState: propertyAnimator.state))"
        })
        
        let actions = [startAction!, pauseAction!, stopAction!, finishAction!, resetAction!]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func createReverseSection() -> DemoSectionView {
        let sectionTitle = "Reversing"
        let description = "Property animators work largely the same way as block-based animations, though give us the ability to start, stop, pause, resume, reverse, scrub, and dynamically modify animations by keeping reference to the animator."
        let sampleCode = self.stringFromCodeSampleFile(named: "animate-transform")
        let (animatingView, square, label) = self.createViewWithSquareAndLabel()
        label.text = "Direction: normal (shrinking)"
        
        let propertyAnimator = UIViewPropertyAnimator(duration: 5.0, dampingRatio: 0.7, animations: {
            square.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        propertyAnimator.pausesOnCompletion = true
        
        let startAction = DemoSectionViewAction(buttonTitle: "Start", actionBlock: {
            propertyAnimator.startAnimation()
        })
        
        let changeDirectionAction = DemoSectionViewAction(buttonTitle: "Change direction", actionBlock: {
            propertyAnimator.isReversed = !propertyAnimator.isReversed
            label.text = (propertyAnimator.isReversed) ? "Direction: reversed (growing)" : "Direction: normal (shrinking)"
        })
        
        let actions = [startAction, changeDirectionAction]
        let animationSection = DemoSectionView(title: sectionTitle, description: description, sampleCode: sampleCode, animatingView: animatingView, actions: actions)
        return animationSection
    }
    
    func string(forPropertyAnimatorState state: UIViewAnimatingState) -> String {
        switch state {
            case .active: return "active"
            case .inactive: return "inactive"
            case .stopped: return "stopped"
        }
    }
}
