import UIKit

@IBDesignable
final class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { self.layer.borderWidth = borderWidth }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet { self.layer.borderColor = borderColor.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {
        setBackgroundColor(self.backgroundColor ?? .black, for: .normal)
    }
}
