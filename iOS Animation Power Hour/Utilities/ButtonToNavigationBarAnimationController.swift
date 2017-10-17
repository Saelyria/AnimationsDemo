
import UIKit

class ButtonToNavigationBarAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private var button: UIButton
    private var shouldBlur: Bool
    
    required init(button: UIButton, shouldBlur: Bool = true) {
        self.button = button
        self.shouldBlur = shouldBlur
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        if ((toVC as? UINavigationController) != nil) && self.button.isDescendant(of: fromVC.view) {
            let navController = toVC as! UINavigationController
            
            let navBarColor = navController.navigationBar.barTintColor ?? UIColor.white
            navController.view.frame = transitionContext.finalFrame(for: navController)
            navController.view.transform = CGAffineTransform(translationX: 0, y: -navController.view.frame.size.height)
            containerView.addSubview(navController.view)
            
            let animatedHeader = UIView(frame: self.button.frame)
            animatedHeader.backgroundColor = self.button.backgroundColor
            animatedHeader.layer.cornerRadius = self.button.layer.cornerRadius
            animatedHeader.alpha = 0
            containerView.addSubview(animatedHeader)
            animatedHeader.frame = self.button.convert(self.button.bounds, to: containerView)
            
            let blurView = UIVisualEffectView(frame: containerView.frame)
            if shouldBlur {
                containerView.addSubview(blurView)
                containerView.sendSubview(toBack: blurView)
            }
            
            let duration = self.transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: duration*0.05, delay: 0.0, options: .curveEaseInOut, animations: {
                animatedHeader.alpha = 1
            }) { (_) in
                self.button.isHidden = true
                animatedHeader.addCornerRadiusAnimation(from: animatedHeader.layer.cornerRadius, to: 0, duration: duration*0.2)
                UIView.animate(withDuration: duration*0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
                    if self.shouldBlur {
                        blurView.effect = UIBlurEffect(style: .dark)
                    }
                    let headerFrame = CGRect(x: 0, y: 0, width: transitionContext.finalFrame(for: navController).size.width, height: 64)
                    animatedHeader.frame = headerFrame
                }) { (_) in
                    UIView.animate(withDuration: duration*0.2, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                        animatedHeader.backgroundColor = navBarColor
                        navController.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    }) { (_) in
                        UIView.animate(withDuration: duration*0.1, delay: 0.0, options: .curveEaseOut, animations: {
                            animatedHeader.alpha = 0
                        }) { (_) in
                            self.button.isHidden = false
                            blurView.removeFromSuperview()
                            animatedHeader.removeFromSuperview()
                            transitionContext.completeTransition(true)
                        }
                    }
                }
            }
        }
            
        else {
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            toVC.view.transform = CGAffineTransform(translationX: 0, y: toVC.view.frame.size.height)
            containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                toVC.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}

extension UIView {
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = to
    }
}

