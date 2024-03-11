import UIKit
import DiiaUIComponents
import DiiaCommonTypes

final class TitleTableCell: BaseTableNibCell, NibLoadable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var onClickAction: Callback?
    
    // MARK: - Life
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onClickAction = nil
    }

    // MARK: - Setup
    func setupUI(font: UIFont = FontBook.bigText, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        titleLabel?.font = font
        titleLabel?.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        isUserInteractionEnabled = true        
    }
    
    // MARK: - Configuration
    func configure(viewModel: TitleCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = UIImage(named: viewModel.iconName)
        onClickAction = viewModel.action
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        onClickAction?()
    }
}
