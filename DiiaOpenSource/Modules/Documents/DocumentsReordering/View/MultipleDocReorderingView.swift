import UIKit
import DiiaCommonTypes
import DiiaUIComponents

// MARK: - View Model
struct MultipleDocReorderingViewModel {
    let leftIcon: UIImage?
    let title: String
    let rightIcon: UIImage?
    let touchAction: Callback?
    
    init(leftIcon: UIImage?, numberOfDocuments: Int, rightIcon: UIImage?, touchAction: Callback?) {
        self.leftIcon = leftIcon
        self.title = (numberOfDocuments <= 4) ? R.Strings.document_reordering_docs_number_small.formattedLocalized(arguments: String(numberOfDocuments)) : R.Strings.document_reordering_docs_number_big.formattedLocalized(arguments: String(numberOfDocuments))
        self.rightIcon = rightIcon
        self.touchAction = touchAction
    }
}

// MARK: - View
class MultipleDocReorderingView: BaseCodeView {
    private let leftImage: UIImageView = UIImageView().withSize(Constants.imageSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let rightImage: UIImageView = UIImageView().withSize(Constants.imageSize)
    
    private var viewModel: MultipleDocReorderingViewModel?
    
    // MARK: - Life Cycle
    override func setupSubviews() {
        hstack(leftImage,
               titleLabel,
               rightImage,
               spacing: Constants.defaultSpacing,
               alignment: .center,
               padding: Constants.paddings)
        
        setupUI()
        addTapGestureRecognizer()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: MultipleDocReorderingViewModel) {
        self.viewModel = viewModel
        leftImage.isHidden = viewModel.leftIcon == nil
        leftImage.image = viewModel.leftIcon
        
        titleLabel.text = viewModel.title
        
        leftImage.isHidden = viewModel.leftIcon == nil
        rightImage.image = viewModel.rightIcon
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
    }

    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.touchAction?()
    }
}

// MARK: - Constants
extension MultipleDocReorderingView {
    private enum Constants {
        static let imageSize = CGSize(width: 24, height: 24)
        static let defaultSpacing: CGFloat = 16
        static let paddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
