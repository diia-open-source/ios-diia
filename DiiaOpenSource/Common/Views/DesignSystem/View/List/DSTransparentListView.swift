import UIKit
import DiiaUIComponents

class DSTransparentListView: BaseCodeView {
    private let stackView = UIStackView.create(views: [])
    
    override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(width: Constants.separatorHeight, color: UIColor(AppConstants.Colors.white))
        addSubview(stackView)
        stackView.fillSuperview(padding: Constants.stackInsets)
    }
    
    // MARK: - Public Methods
    func configure(viewModel: DSListViewModel) {
        stackView.safelyRemoveArrangedSubviews()
        if let title = viewModel.title {
            addTitleView(title)
            addSeparator()
        }
        for item in viewModel.items {
            addListItemView(with: item)
        }
    }
    
    // MARK: - Private Methods
    private func addListItemView(with viewModel: DSListItemViewModel) {
        let itemView = DSListItemView()
        itemView.configure(viewModel: viewModel)
        itemView.setupUI(stackPadding: Constants.itemInsets)
        stackView.addArrangedSubview(itemView)
    }
    
    private func addTitleView(_ title: String) {
        let descriptionLabel = BoxView(subview: UILabel().withParameters(font: FontBook.usualFont))
        descriptionLabel.subview.text = title
        descriptionLabel.withConstraints(insets: Constants.titleInsets)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addSeparator() {
        let separator = UIView().withHeight(Constants.separatorHeight)
        separator.backgroundColor = UIColor(AppConstants.Colors.white)
        stackView.addArrangedSubview(separator)
    }
}

// MARK: - Constants
extension DSTransparentListView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let titleInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let itemInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 0, right: 16)
        static let separatorHeight: CGFloat = 1
        static let stackInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
