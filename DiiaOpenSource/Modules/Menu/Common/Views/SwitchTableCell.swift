import UIKit
import DiiaUIComponents

final class SwitchTableCell: BaseTableNibCell, NibLoadable {

    // MARK: - Outlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    
    // MARK: - Properties
    private var viewModel: SwitchIconedViewModel?
    private var isOnObservation: NSKeyValueObservation?

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = FontBook.bigText
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isOnObservation = nil
        viewModel = nil
    }
    
    deinit {
        isOnObservation = nil
        viewModel = nil
    }
    
    // MARK: - Configuration
    private func setupSubviews() {
        switcher.addTarget(self, action: #selector(switcherChanged(_:)), for: .valueChanged)
    }
    
    func configure(with viewModel: SwitchIconedViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = UIImage(named: viewModel.iconName)
        
        isOnObservation = viewModel.observe(\.isOn, onChange: { [weak self] (newValue) in
            guard let self = self else { return }
            
            onMainQueue { self.switcher.setOn(newValue, animated: true) }
        })
        
        self.viewModel = viewModel
    }
    
    // MARK: - Actions
    @objc private func switcherChanged(_ sender: UISwitch) {
        viewModel?.isOn = sender.isOn
    }
}
