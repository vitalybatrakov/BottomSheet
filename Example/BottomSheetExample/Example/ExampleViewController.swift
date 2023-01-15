import SnapKit
import UIKit

final class ExampleViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: nil)
        title.text = "Title"
        return title
    }()
    
    private let subtitleLabel: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: nil)
        title.text = "Subtitle"
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let title = UILabel()
        title.font = .preferredFont(forTextStyle: .body, compatibleWith: nil)
        title.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        title.numberOfLines = 0
        return title
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.addArrangedSubview(descriptionLabel)
    }
}
