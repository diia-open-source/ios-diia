import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol SettingsView: BaseView { }

final class SettingsViewController: UIViewController, SettingsView, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

	// MARK: - Properties
	var presenter: SettingsAction!

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        titleLabel.font = FontBook.smallHeadingFont
        titleLabel.text = R.Strings.menu_title_settings.localized()
        
        tableView.register(TitleTableCell.nib, forCellReuseIdentifier: TitleTableCell.reuseID)
        tableView.register(SwitchTableCell.nib, forCellReuseIdentifier: SwitchTableCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Private Methods
    @IBAction private func backButtonTapped() {
        presenter.onBackTapped()
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingVM = presenter.item(at: indexPath) else { return UITableViewCell() }
        
        switch settingVM {
        case .switched(let vm):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableCell.reuseID, for: indexPath) as? SwitchTableCell {
                cell.configure(with: vm)
                return cell
            }
        case .titled(let vm):
            if let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableCell.reuseID, for: indexPath) as? TitleTableCell {
                cell.configure(viewModel: vm)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let settingVM = presenter.item(at: indexPath) else { return Constants.cellHeight }
        switch settingVM {
        case .switched:
            return Constants.cellHeight
        case .titled:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - Constants
extension SettingsViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 65
    }
}
