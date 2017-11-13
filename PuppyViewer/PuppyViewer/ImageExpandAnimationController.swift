import UIKit

class ImageExpandAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private var listImage: UIImageView
    private var detailImage: UIImageView
    
    private var blurView = UIVisualEffectView()
    private var animatingImage = UIImageView()
    
    required init(listImage: UIImageView, detailImage: UIImageView) {
        self.listImage = listImage
        self.detailImage = detailImage
        
        self.animatingImage.image = self.listImage.image
        self.animatingImage.clipsToBounds = self.listImage.clipsToBounds
        self.animatingImage.layer.cornerRadius = self.listImage.layer.cornerRadius
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        // if the list image is in the view hierarchy of the view controller we're
        // transitioning from, then we're transitioning to the detail view
        let isTransitioningToDetail = listImage.isDescendant(of: fromVC.view)
        
        // presentation of detail
        if isTransitioningToDetail {
            // setup the blur view frame and add to container view
            self.blurView.frame = containerView.frame
            containerView.addSubview(blurView)
            
            // set the toVC's frame to its final frame, add to container view, set alpha to 0,
            // and make sure it has laid out its views based on its constraints
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            toVC.view.layoutIfNeeded()
            
            // set the animating image's frame to the list image's frame and add to container
            let listImageFrame = self.listImage.convert(self.listImage.bounds, to: containerView)
            self.animatingImage.frame = listImageFrame
            containerView.addSubview(animatingImage)
            
            // the list and detail images aren't going to move so their frame data is always correct.
            // So, to make sure there isn't two static images just sitting there, hide them.
            self.detailImage.alpha = 0
            self.listImage.alpha = 0
            
            // animate the list image's frame to the detail image's frame, set the blur view's
            // effect to a dark blur, and animate the toVC's alpha to 1
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                let detailImageFrame = self.detailImage.convert(self.detailImage.bounds, to: containerView)
                self.animatingImage.frame = detailImageFrame
                self.blurView.effect = UIBlurEffect(style: .dark)
                toVC.view.alpha = 1
            }) { completed in
                transitionContext.completeTransition(completed)
            }
        }
            
            // dismissal back to list
        else {
            // everything's already in place for dismissal - just animate the detail VC's
            // alpha to 0, animate the animating image to the list image
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                fromVC.view.alpha = 0
                let listImageFrame = self.listImage.convert(self.listImage.bounds, to: containerView)
                self.animatingImage.frame = listImageFrame
                self.blurView.effect = nil
            }, completion: { completed in
                // now that we're all done the animations, make sure to show the original images
                // again and remove the animating view from the hierarchy
                self.detailImage.alpha = 1
                self.listImage.alpha = 1
                self.animatingImage.removeFromSuperview()
                
                transitionContext.completeTransition(completed)
            })
        }
    }
}


