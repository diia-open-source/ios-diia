import UIKit
import DiiaMVPModule
import DiiaUIComponents

class DriverReplacementStubModule: BaseModule {
    func viewController() -> UIViewController {
        return DriverReplacementStubViewController()
    }
}

class DriverReplacementStubViewController: UIViewController, BaseView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        setupTitleLabel()
        setupTopNavView()
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = Constants.titleText
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupTopNavView() {
        let topNavigatonView = TopNavigationView()
        topNavigatonView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
        topNavigatonView.setupOnContext(callback: nil)
        
        view.addSubview(topNavigatonView)
        topNavigatonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topNavigatonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topNavigatonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigatonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension DriverReplacementStubViewController {
    private enum Constants {
        static let titleText = "DriverReplacementStubModule"
    }
}
