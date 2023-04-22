import UIKit

final class OverlayView: UIView {
    
    private let presentingView: UIView
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return presentingView.hitTest(point, with: event)
        }
        return hitView
    }
}
