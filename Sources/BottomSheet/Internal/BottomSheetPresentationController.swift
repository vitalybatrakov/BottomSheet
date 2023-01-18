import UIKit

final class BottomSheetPresentationController: UIPresentationController {
    
    // MARK: Private properties
  
    /// The object that is managing the presentation and transition.
    private var transitioningDelegate: BottomSheetTransitioningDelegate? {
        presentedViewController.transitioningDelegate as? BottomSheetTransitioningDelegate
    }
    
    private let pullBarView: UIView = {
        let view = UIView()
        view.bounds.size = CGSize(width: 32, height: 4)
        view.backgroundColor = .systemFill
        return view
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = configuration.overlayColor
        if configuration.tapToDismissEnabled {
            let tapGR = UITapGestureRecognizer(target: self,
                                               action: #selector(didTapOverlayView))
            view.addGestureRecognizer(tapGR)
        }
        return view
    }()
  
    /// The pan gesture used to drag and interactively dismiss the sheet.
    private lazy var panGesture = UIPanGestureRecognizer(target: self,
                                                         action: #selector(pannedPresentedView))
    
    private var cornerRadius: CGFloat {
        configuration.cornerRadius
    }
    
    private var dismissThreshold: CGFloat {
        configuration.dismissThreshold
    }
    
    private let configuration: BottomSheetConfiguration
    
    // MARK: Init
    
    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        configuration: BottomSheetConfiguration
    ) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
  
    // MARK: UIPresentationController
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return super.frameOfPresentedViewInContainerView
        }
        /// The maximum height allowed for the sheet. We allow the sheet to reach the top safe area inset.
        let maximumHeight = containerView.frame.height - containerView.safeAreaInsets.top - containerView.safeAreaInsets.bottom
        
        let fittingSize = CGSize(width: containerView.bounds.width,
                                 height: UIView.layoutFittingCompressedSize.height)
        
        let presentedViewHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        /// The target height of the presented view.
        /// If the size of the of the presented view could not be computed, meaning its equal to zero, we default to the maximum height.
        let targetHeight = presentedViewHeight == .zero ? maximumHeight : presentedViewHeight
        /// Adjust the height of the view by adding the bottom safe area inset.
        let adjustedHeight = min(targetHeight, maximumHeight) + containerView.safeAreaInsets.bottom
        
        let targetSize = CGSize(width: containerView.frame.width, height: adjustedHeight)
        let targetOrigin = CGPoint(x: .zero, y: containerView.frame.maxY - targetSize.height)
        
        return CGRect(origin: targetOrigin, size: targetSize)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.addSubview(overlayView)
        presentedView?.addSubview(pullBarView)
        
        overlayView.alpha = 0
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.presentedView?.layer.cornerRadius = self.cornerRadius
            self.overlayView.alpha = 1
        })
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        setupLayout()
        setupPresentedViewInteraction()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.presentedView?.layer.cornerRadius = .zero
            self.overlayView.alpha = 0
        })
    }
    
    // MARK: Private methods

    private func setupLayout() {
        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return
        }
        overlayView.frame = containerView.bounds
        pullBarView.frame.origin.y = 8
        pullBarView.center.x = presentedView.center.x
        pullBarView.layer.cornerRadius = pullBarView.frame.height / 2
        presentedView.layer.cornerCurve = .continuous
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.additionalSafeAreaInsets.top = pullBarView.frame.maxY
    }
    
    private func setupPresentedViewInteraction() {
        guard let presentedView = presentedView else { return }
        presentedView.addGestureRecognizer(panGesture)
    }
    
    /// Triggers the dismiss transition in an interactive manner.
    /// - Parameter isInteractive: Whether the transition should be started interactively by the user.
    private func dismiss(interactively isInteractive: Bool) {
        transitioningDelegate?.transition.wantsInteractiveStart = isInteractive
        presentedViewController.dismiss(animated: true)
    }
    
    /// Updates the progress of the dismiss transition.
    /// - Parameter translation: The translation of the presented view used to calculate the progress.
    private func updateTransitionProgress(for translation: CGPoint) {
        guard
            let transitioningDelegate = transitioningDelegate,
            let presentedView = presentedView
        else {
            return
        }
        let adjustedHeight = presentedView.frame.height - translation.y
        let progress = 1 - (adjustedHeight / presentedView.frame.height)
        transitioningDelegate.transition.update(progress)
    }
    
    /// Finish or cancel the dimiss transition depending on current progress of dismiss transition
    private func handleEndedInteraction() {
        guard let transitioningDelegate = transitioningDelegate else {
            return
        }
        if transitioningDelegate.transition.dismissFractionComplete > dismissThreshold {
            transitioningDelegate.transition.finish()
        } else {
            transitioningDelegate.transition.cancel()
        }
    }
    
    @objc
    private func didTapOverlayView() {
        dismiss(interactively: false)
    }
    
    @objc
    private func pannedPresentedView(_ recognizer: UIPanGestureRecognizer) {
        guard let presentedView = presentedView else {
            return
        }
        switch recognizer.state {
        case .began:
            dismiss(interactively: true)
            
        case .changed:
            let translation = recognizer.translation(in: presentedView)
            updateTransitionProgress(for: translation)
            
        case .ended, .cancelled, .failed:
            handleEndedInteraction()
            
        case .possible:
            break
            
        @unknown default:
            break
        }
    }
}
