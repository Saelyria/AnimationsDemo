import UIKit

/**
 A view controller transition that expands a specified image to match the frame of the given
 destination image with a blurred background.
**/
class ImageExpandAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private var sourceVC: UIViewController
    private var sourceImage: UIImageView
    private var destinationVC: UIViewController
    private var destinationImage: UIImageView
    private var blurView = UIVisualEffectView()
    
    required init(sourceVC: UIViewController, sourceImage: UIImageView, destinationVC: UIViewController, destinationImage: UIImageView) {
        self.sourceVC = sourceVC
        self.sourceImage = sourceImage
        self.destinationVC = destinationVC
        self.destinationImage = destinationImage
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from),
            (toVC == destinationVC || toVC == sourceVC), (fromVC == destinationVC || fromVC == sourceVC) else {
                return
        }
        let isDismissal = (toVC == sourceVC)
        let containerView = transitionContext.containerView
        self.blurView.frame = containerView.frame
        
        if isDismissal {
            let animationImageView = UIImageView()
            containerView.addSubview(animationImageView)
            animationImageView.image = self.destinationImage.image
            animationImageView.frame = self.destinationImage.convert(self.destinationImage.bounds, to: containerView)
            
            destinationImage.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                fromVC.view.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    let finalImageFrame = self.sourceImage.convert(self.sourceImage.bounds, to: containerView)
                    animationImageView.frame = finalImageFrame
                    self.blurView.effect = nil
                }, completion: { completed in
                    self.sourceImage.alpha = 1
                    self.destinationImage.alpha = 1
                    animationImageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            })
        }
            
        else {
            containerView.addSubview(blurView)
            
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            
            let animationImageView = UIImageView()
            containerView.addSubview(animationImageView)
            animationImageView.image = self.sourceImage.image
            animationImageView.frame = self.sourceImage.convert(self.sourceImage.bounds, to: containerView)
            self.sourceImage.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                let finalImageFrame = self.destinationImage.convert(self.destinationImage.bounds, to: containerView)
                animationImageView.frame = finalImageFrame
                self.blurView.effect = UIBlurEffect(style: .dark)
            }) { (completed) in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    toVC.view.alpha = 1
                }, completion: { _ in
                    animationImageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
}
