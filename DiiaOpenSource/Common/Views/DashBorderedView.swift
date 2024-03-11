import UIKit
import DiiaUIComponents

class DashBorderedView: BaseCodeView {
    
    // MARK: - Properties
    private var dashBorder: CAShapeLayer?
    private var lineWidth: CGFloat
    private var borderColor: UIColor
    private var dashPattern: [NSNumber]
    private var cornerRadius: CGFloat
    
    // MARK: - Init
    init(
        frame: CGRect,
        lineWidth: CGFloat,
        borderColor: UIColor,
        dashPattern: [NSNumber],
        cornerRadius: CGFloat
    ) {
        self.lineWidth = lineWidth
        self.borderColor = borderColor
        self.dashPattern = dashPattern
        self.cornerRadius = cornerRadius
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lineWidth = Constants.defaultLineWidth
        self.borderColor = Constants.defaultBorderColor
        self.dashPattern = Constants.defaultDashPattern
        self.cornerRadius = Constants.defaultCornerRadius
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dashBorder?.removeFromSuperlayer()
        
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = lineWidth
        dashBorder.strokeColor = borderColor.cgColor
        dashBorder.lineDashPattern = dashPattern
        dashBorder.frame = bounds
        dashBorder.fillColor = UIColor.clear.cgColor
        
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        
        layer.addSublayer(dashBorder)
        
        self.dashBorder = dashBorder
    }
}

private extension DashBorderedView {
    enum Constants {
        static let defaultLineWidth: CGFloat = 4
        static let defaultBorderColor: UIColor = UIColor("#B3B3B3")
        static let defaultDashPattern: [NSNumber] = [6, 4]
        static let defaultCornerRadius: CGFloat = 2
    }
}
