import UIKit

public struct BottomSheetConfiguration {
    
    // MARK: Internal properties
    
    public let showPullBar: Bool
    public let tapToDismissEnabled: Bool
    public let panToDismissEnaled: Bool
    public let cornerRadius: CGFloat
    public let overlayColor: UIColor
    
    /// present/dismiss animation duration
    public let animationDuration: TimeInterval
    
    /// The damping ratio for the spring animation as it approaches its quiescent state.
    /// To smoothly decelerate the animation without oscillation, use a value of 1.
    /// Employ a damping ratio closer to zero to increase oscillation.
    public let dampingRatio: Double
    
    /// Fraction part of transition completed interactively required to dismiss transition
    /// Value range is 0...1
    public let dismissThreshold: CGFloat
    
    public init(showPullBar: Bool,
                tapToDismissEnabled: Bool,
                panToDismissEnaled: Bool,
                cornerRadius: CGFloat,
                overlayColor: UIColor,
                animationDuration: TimeInterval,
                dampingRatio: Double,
                dismissThreshold: CGFloat) {
        self.showPullBar = showPullBar
        self.tapToDismissEnabled = tapToDismissEnabled
        self.panToDismissEnaled = panToDismissEnaled
        self.cornerRadius = cornerRadius
        self.overlayColor = overlayColor
        self.animationDuration = animationDuration
        self.dampingRatio = dampingRatio
        self.dismissThreshold = dismissThreshold
    }
    
    // MARK: Configurations
    
    public static let `default` = BottomSheetConfiguration(
        showPullBar: true,
        tapToDismissEnabled: true,
        panToDismissEnaled: true,
        cornerRadius: 16,
        overlayColor: .black.withAlphaComponent(0.3),
        animationDuration: 0.5,
        dampingRatio: 0.9,
        dismissThreshold: 0.3
    )
}
