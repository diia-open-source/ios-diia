import UIKit
import DiiaCommonTypes
import DiiaUIComponents

class BorderedCheckmarksViewModel {
    let checkmarks: [CheckmarkViewModel]
    var onClick: Callback?
    
    init(checkmarks: [CheckmarkViewModel]) {
        self.checkmarks = checkmarks
    }
}

/// design_system_code: checkboxBorderedMlc
class BorderedCheckmarksView: BaseCodeView {
    private lazy var contentStackView = UIStackView.create(views: [], spacing: Constants.stackSpacing, in: self, padding: Constants.stackPadding)
    
    override func setupSubviews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
    }
    
    // MARK: - Public methods
    func configure(with viewModel: BorderedCheckmarksViewModel) {
        contentStackView.safelyRemoveArrangedSubviews()
        viewModel.checkmarks.forEach { checkmark in
            let checkmarkView = CheckmarkView()
            checkmarkView.configure(text: checkmark.text, isChecked: checkmark.isChecked) { isChecked in
                checkmark.isChecked = isChecked
                viewModel.onClick?()
            }
            checkmarkView.accessibilityIdentifier = checkmark.componentId
            contentStackView.addArrangedSubview(checkmarkView)
        }
    }
}

extension BorderedCheckmarksView {
    private enum Constants {
        static let stackPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let stackSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .white
    }
}
