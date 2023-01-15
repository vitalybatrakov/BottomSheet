import UIKit

final class BottomSheetTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK: Internal properties
    
    /// `true` if the transition is for the presentation.
    /// `false` if the transition is for the dismissal.
    var isPresenting = true
    
    /// The progress of the dismiss animation.
    var dismissFractionComplete: CGFloat {
      dismissAnimator?.fractionComplete ?? .zero
    }
    
    // MARK: Private properties
    
    /// The interactive animator used for the dismiss transition.
    private var dismissAnimator: UIViewPropertyAnimator?
    
    /// The animator used for the presentation animation.
    private var presentationAnimator: UIViewPropertyAnimator?
    
    private let configuration: BottomSheetConfiguration
    
    private var animationDuration: TimeInterval {
        configuration.animationDuration
    }
    
    private var dampingRatio: Double {
        configuration.dampingRatio
    }
    
    // MARK: Init
    
    init(configuration: BottomSheetConfiguration) {
        self.configuration = configuration
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension BottomSheetTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    /// Will get called when the transition is not interactive to animate presenting or dismissing of the controller.
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    /// Will get called when the transition is interactive.
    func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        if isPresenting {
            return presentationAnimator(using: transitionContext)
        } else {
            return dismissAnimator(using: transitionContext)
        }
    }
    
    // MARK: Private methods
    
    private func presentationAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        presentationAnimator ?? createPresentationAnimator(using: transitionContext)
    }
    
    private func createPresentationAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to)
        else {
            return UIViewPropertyAnimator()
        }
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: dampingRatio
        )
        presentationAnimator = animator
        
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.frame.origin.y = transitionContext.containerView.frame.maxY
        transitionContext.containerView.addSubview(toView)
        
        animator.addAnimations {
            toView.frame = transitionContext.finalFrame(for: toViewController)
        }
        animator.addCompletion { [weak self] position in
            self?.presentationAnimator = nil
            
            guard case .end = position else {
                transitionContext.completeTransition(false)
                return
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
    
    private func dismissAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        dismissAnimator ?? createDismissAnimator(using: transitionContext)
    }
    
    private func createDismissAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return UIViewPropertyAnimator()
        }
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: dampingRatio
        )
        dismissAnimator = animator
        
        animator.addAnimations {
            fromView.frame.origin.y = fromView.frame.maxY
        }
        animator.addCompletion { [weak self] position in
            self?.dismissAnimator = nil
            
            guard case .end = position else {
                transitionContext.completeTransition(false)
                return
            }
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
}
