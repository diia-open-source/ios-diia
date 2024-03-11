import UIKit
import DiiaUIComponents

struct DocReorderingCellViewModel {
    let documentItem: DocReorderingCellInfoViewModel
    let multipleDocItem: MultipleDocReorderingViewModel?
    
    init(documentItem: DocReorderingCellInfoViewModel,
         multipleDocItem: MultipleDocReorderingViewModel? = nil
    ) {
        self.documentItem = documentItem
        self.multipleDocItem = multipleDocItem
    }
}

class DocumentReorderingCell: UICollectionViewCell, Reusable {
    private let contentStackView = UIStackView.create(views: [])
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        return super.systemLayoutSizeFitting(
            CGSize(width: targetSize.width, height: CGFloat.greatestFiniteMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: DocReorderingCellViewModel) {
        contentStackView.safelyRemoveArrangedSubviews()
        
        let documentView = DocReorderingCellInfoView()
        documentView.configure(with: viewModel.documentItem)
        contentStackView.addArrangedSubview(documentView)
        
        guard let multipleDocItem = viewModel.multipleDocItem else { return }
        let multipleDocView = MultipleDocReorderingView()
        multipleDocView.configure(with: multipleDocItem)
        contentStackView.addArrangedSubviews([separator(), multipleDocView])
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        addSubview(contentStackView)
        contentStackView.fillSuperview()
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
    
    private func separator() -> UIView {
        let view = UIView().withHeight(Constants.separatorHeight)
        view.backgroundColor = Constants.separatorColor
        return view
    }
}

// MARK: - Constants
extension DocumentReorderingCell {
    private enum Constants {
        static let backgroundColor: UIColor = .white.withAlphaComponent(0.4)
        static let separatorColor: UIColor = .black.withAlphaComponent(0.07)
        static let separatorHeight: CGFloat = 1
        static let cornerRadius: CGFloat = 24
    }
}
