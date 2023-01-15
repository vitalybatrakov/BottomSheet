import SnapKit
import UIKit

final class ViewController: UIViewController {
    
    private let delegate = BottomSheetTransitioningDelegate(configuration: .default)
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Show bottom sheet", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func didTapButton() {
        let vc = ExampleViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = delegate
        present(vc, animated: true)
    }
}

