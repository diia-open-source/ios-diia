import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol DocumentsReorderingView: BaseView {}

final class DocumentsReorderingViewController: UIViewController, DocumentsReorderingView {
    
    // MARK: - Outlets
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var topView: TopNavigationBigView!
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var documentsCollectionView: UICollectionView!
    @IBOutlet private weak var documentsCollectionFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    var presenter: DocumentsReorderingAction!

    // MARK: - Init
    init() {
        super.init(nibName: DocumentsReorderingViewController.className, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    override func canGoBack() -> Bool {
        return false
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        backgroundImage.image = R.image.light_background.image
        setupTopView()
        setupCollectionView()
    }
    
    private func setupTopView() {
        topView.configure(
            viewModel: .init(
                title: R.Strings.document_reordering_title.localized(),
                backAction: { [weak self] in
                    self?.presenter.onBackTapped()
            })
        )
    }
    
    private func setupCollectionView() {
        documentsCollectionView.backgroundColor = .clear
        documentsCollectionView.alwaysBounceVertical = false
        
        documentsCollectionFlowLayout.minimumInteritemSpacing = Constants.interitemSpacing
        documentsCollectionFlowLayout.sectionInset = Constants.sectionInset
        documentsCollectionFlowLayout.estimatedItemSize = Constants.estimatedItemSize
        
        documentsCollectionView.register(cellType: DocumentReorderingCell.self)
        documentsCollectionView.dataSource = self
        documentsCollectionView.delegate = self

        documentsCollectionView.dragDelegate = self
        documentsCollectionView.dropDelegate = self
        documentsCollectionView.dragInteractionEnabled = true
    }
}

// MARK: - UICollectionView Protocols
extension DocumentsReorderingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DocumentReorderingCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = presenter.item(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }
}

// MARK: - Drag & Grop
extension DocumentsReorderingViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard destinationIndexPath != nil else { return .init(operation: .forbidden) }
        return .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
              let dragItem = coordinator.items.last?.dragItem,
              let startIndexPath = dragItem.localObject as? IndexPath
        else { return }
        
        collectionView.performBatchUpdates({ [weak self] in
            self?.presenter.moveItem(from: startIndexPath.row, toIndex: destinationIndexPath.row)
            collectionView.deleteItems(at: [startIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        })
        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
    }
}

// MARK: - Constants
extension DocumentsReorderingViewController {
    private enum Constants {
        static let estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 64)
        static let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        static let interitemSpacing: CGFloat = 8
    }
}
