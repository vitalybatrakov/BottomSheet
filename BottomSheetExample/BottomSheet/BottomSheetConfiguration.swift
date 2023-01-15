import UIKit

struct BottomSheetConfiguration {
    
    // MARK: Internal properties
    
    let showPullBar: Bool
    let tapToDismissEnabled: Bool
    let panToDismissEnaled: Bool
    let cornerRadius: CGFloat
    let overlayColor: UIColor
    
    /// present/dismiss animation duration
    let animationDuration: TimeInterval
    
    /// The damping ratio for the spring animation as it approaches its quiescent state.
    /// To smoothly decelerate the animation without oscillation, use a value of 1.
    /// Employ a damping ratio closer to zero to increase oscillation.
    let dampingRatio: Double
    
    /// Fraction part of transition completed interactively required to dismiss transition
    /// Value range is 0...1
    let dismissThreshold: CGFloat
    
    // MARK: Configurations
    
    static let `default` = BottomSheetConfiguration(
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
