import UIKit
import DiiaUIComponents

struct SelectableIconTitleViewModel {
    let icon: UIImage
    let title: String
    let selectedIcon: UIImage
}

class MainTabCollectionCell: BaseCollectionNibCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var iconView: UIImageView!
    @IBOutlet weak private var iconViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var vm: SelectableIconTitleViewModel?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = FontBook.tabBarTitle
        iconViewHeightConstraint.constant = Constants.iconHeight
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    func setSelected(isSelected: Bool) {
        guard let vm = vm else {
            return
        }
        iconView.image = isSelected ? vm.selectedIcon : vm.icon
    }
    
    func configureAccessibility(isSelected: Bool, currentValue: Int, totalValue: Int) {
        guard let viewModel = vm else { return }
        self.accessibilityLabel = isSelected ? R.Strings.main_screen_accessibility_bottom_bar_cell_active.formattedLocalized(arguments: viewModel.title) : R.Strings.main_screen_accessibility_bottom_bar_cell_inactive.formattedLocalized(arguments: viewModel.title)
        self.accessibilityHint = R.Strings.main_screen_accessibility_bottom_bar_cell_tabulation.formattedLocalized(arguments: "\(currentValue)", "\(totalValue)")
    }
    
    func configure(with viewModel: SelectableIconTitleViewModel) {
        vm = viewModel
        titleLabel.setTextWithCurrentAttributes(text: viewModel.title)
        iconView.image = viewModel.icon
    }
    
    // MARK: - Public Methods
    private func setupAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityTraits = .none
    }
}

// MARK: - Constants
extension MainTabCollectionCell {
    private enum Constants {
        static var iconHeight: CGFloat {
            switch UIScreen.main.bounds.width {
            case 414, 428, 430: return 26
            default: return 24
            }
        }
    }
}
