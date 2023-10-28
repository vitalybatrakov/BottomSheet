import UIKit

final class KeyboardObserver {
    
    private var onKeyboardShow: ((CGFloat) -> Void)?
    private var onKeyboardHide: (() -> Void)?
    
    public init() {
        registerKeyboardNotifications()
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    public func subscribe(
        onKeyboardShow: @escaping (CGFloat) -> Void,
        onKeyboardHide: @escaping () -> Void
    ) {
        self.onKeyboardShow = onKeyboardShow
        self.onKeyboardHide = onKeyboardHide
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
        
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        onKeyboardShow?(keyboardFrame.height)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        onKeyboardHide?()
    }
}
