import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

public final class ActionSheetV2Module: BaseModule {
    private let view: ActionSheetV2ViewController
    
    public init(actions: [Action]) {
        view = ActionSheetV2ViewController()
        view.actions = actions
        view.lastAction = Action(title: R.Strings.general_accessibility_close.localized(), iconName: nil, callback: {})
    }
    
    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .actionSheet
        return vc
    }
}

class ActionSheetV2ViewController: UIViewController, ChildSubcontroller {
    
    // MARK: - Properties
    weak var container: ContainerProtocol?
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let listView = DSWhiteColoredListView()
    private let lastButton = ActionButton()
    
    var actions: [Action] = [] {
        didSet {
            updateViews()
        }
    }
    
    var lastAction: Action = Action(title: nil, iconName: R.image.clear.name, callback: {}) {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Private Methods
    private func setupSubviews() {
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        view.addSubview(containerView)
        containerView.backgroundColor = .clear
        containerView.anchor(top: nil,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: .zero,
                                            left: Constants.spacing,
                                            bottom: Constants.spacing,
                                            right: Constants.spacing
                                           )
        )
                
        containerView.addSubview(lastButton)
        lastButton.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
        configureButton(button: lastButton)
        
        containerView.addSubview(scrollView)
        scrollView.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: lastButton.topAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: Constants.smallSpacing, left: .zero, bottom: Constants.smallSpacing, right: .zero))
        
        scrollView.addSubview(listView)
        listView.fillSuperview()
        listView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor)
        
        let stackHeightConstraint = listView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        stackHeightConstraint.priority = .defaultLow
        stackHeightConstraint.isActive = true
        
        containerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing).isActive = true
    }
    
    private func updateViews() {
        let list: DSListViewModel = .init(
            title: nil,
            items: actions.compactMap { item in
                return DSListItemViewModel(
                    leftBigIcon: item.image,
                    title: item.title ?? "",
                    onClick: { [weak self] in
                        item.callback()
                        self?.close()
                    })
            })
        
        listView.configure(viewModel: list)
        
        let newLastAction = Action(title: lastAction.title, image: lastAction.image, callback: { [weak self] in
            self?.close()
            self?.lastAction.callback()
        })
        lastButton.action = newLastAction
        configureButton(button: lastButton)
        
        view.layoutIfNeeded()
    }
    
    private func configureButton(button: ActionButton) {
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontBook.bigText
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = .init(top: Constants.spacing,
                                         left: .zero,
                                         bottom: Constants.spacing,
                                         right: .zero)
        
        button.iconRenderingMode = .alwaysOriginal
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        if button.action?.image != nil {
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = .init(top: Constants.spacing,
                                           left: Constants.spacing,
                                           bottom: Constants.spacing,
                                           right: .zero)
            button.contentEdgeInsets = .init(top: Constants.spacing,
                                             left: Constants.spacing,
                                             bottom: Constants.spacing,
                                             right: -Constants.spacing)
        }
        
        button.backgroundColor = .white
        button.withHeight(Constants.buttonHeight)
        button.layer.cornerRadius = Constants.cornerRadius
    }
    
    // MARK: - Actions
    @objc private func close() {
        container?.close()
    }
}

// MARK: - Constants
extension ActionSheetV2ViewController {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 20
        static let buttonHeight: CGFloat = 58
        static let smallSpacing: CGFloat = spacing / 2
    }
}
