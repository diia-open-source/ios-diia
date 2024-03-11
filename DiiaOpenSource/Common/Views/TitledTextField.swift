import UIKit
import DiiaUIComponents
import DiiaCommonTypes

// swiftlint:disable all

/**
 A beautiful and flexible textfield implementation with support for title label, error message and placeholder.
 */
open class TitledTextField: UITextField {
    /**
     A Boolean value that determines if the language displayed is LTR.
     Default value set automatically from the application language settings.
     */
    @objc open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
           updateTextAligment()
        }
    }

    fileprivate func updateTextAligment() {
        if isLTRLanguage {
            textAlignment = .left
            titleLabel.textAlignment = .left
        } else {
            textAlignment = .right
            titleLabel.textAlignment = .right
        }
    }

    // MARK: Animation timing

    /// The value of the title appearing duration
    @objc dynamic open var titleFadeInDuration: TimeInterval = 0.2
    /// The value of the title disappearing duration
    @objc dynamic open var titleFadeOutDuration: TimeInterval = 0.3

    // MARK: Colors

    fileprivate var cachedTextColor: UIColor?

    /// A UIColor value that determines the text color of the editable text
    override open var textColor: UIColor? {
        set {
            cachedTextColor = newValue
            updateControl(false)
        }
        get {
            return cachedTextColor
        }
    }

    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable dynamic open var placeholderColor: UIColor = UIColor.black {
        didSet {
            updatePlaceholder()
        }
    }

    /// A UIFont value that determines text color of the placeholder label
    @objc dynamic open var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }

    fileprivate func updatePlaceholder() {
        let placeholder = placeholderText
        guard let font = placeholderFont ?? font else {
            return
        }
        let color = isEnabled ? hasErrorMessage ? errorColor : placeholderColor : disabledColor
        let text = editingOrSelected ? "" : placeholder
        #if swift(>=4.2)
            attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [
                    NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font
                ]
            )
        #elseif swift(>=4.0)
            attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [
                    NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font
                ]
            )
        #else
            attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
            )
        #endif
    }

    /// A UIFont value that determines the text font of the title label
    @objc dynamic open var titleFont: UIFont = FontBook.textFieldTitle {
        didSet {
            updateTitleLabel()
        }
    }

    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable dynamic open var titleColor: UIColor = UIColor.black {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable dynamic open var lineColor: UIColor = UIColor.black {
        didSet {
            updateLineView()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when the error message is not `nil`
    @IBInspectable dynamic open var errorColor: UIColor = UIColor.black {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the line when error message is not `nil`
    var lineErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the text when error message is not `nil`
    var textErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the title label when error message is not `nil`
    var titleErrorColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    /// A UIColor value that determines the color used for the title label and line when text field is disabled
    var disabledColor: UIColor = UIColor(white: 0.88, alpha: 1.0) {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    /// A UIColor value that determines the text color of the title label when editing
    var selectedTitleColor: UIColor = UIColor.black {
        didSet {
            updateTitleColor()
        }
    }

    /// A UIColor value that determines the color of the line in a selected state
    var selectedLineColor: UIColor = UIColor.black {
        didSet {
            updateLineView()
        }
    }

    // MARK: Line height

    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable dynamic open var lineHeight: CGFloat = 2 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    var selectedLineHeight: CGFloat = 2 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    // MARK: Border
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable dynamic open
    var isBordered: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var leftBorderValue: CGFloat = 10
    
    var leftBorder: CGFloat {
        return isBordered ? leftBorderValue : 0
    }
    
    // MARK: View components

    /// The internal `UIView` to display the line below the text input.
    open var lineView: UIView!

    /// The internal `UILabel` that displays the selected, deselected title or error message based on the current state.
    open var titleLabel: UILabel!

    // MARK: Properties

    var placeholderText: String = ""
    /**
    The formatter used before displaying content in the title label.
    This can be the `title`, `selectedTitle` or the `errorMessage`.
    The default implementation converts the text to uppercase.
    */
    open var titleFormatter: ((String) -> String) = { (text: String) -> String in
        return text
    }

    /**
     Identifies whether the text object should hide the text being entered.
     */
    override open var isSecureTextEntry: Bool {
        set {
            super.isSecureTextEntry = newValue
        }
        get {
            return super.isSecureTextEntry
        }
    }

    /// A String value for the error message to display.
    var errorMessage: String? {
        didSet {
            updateControl(true)
            updatePlaceholder()
        }
    }

    /// The backing property for the highlighted property
    fileprivate var _highlighted: Bool = false

    /**
     A Boolean value that determines whether the receiver is highlighted.
     When changing this value, highlighting will be done with animation
     */
    override open var isHighlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            updateTitleColor()
            updateLineView()
        }
    }

    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage: Bool {
        return errorMessage != nil && errorMessage != ""
    }

    /// The text content of the textfield
    override open var text: String? {
        didSet {
            updateControl(false)
        }
    }

    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    open override var placeholder: String? {
        didSet {
            setNeedsDisplay()
            placeholderText = placeholder ?? ""
            updatePlaceholder()
            updateTitleLabel()
        }
    }

    /// The String to display when the textfield is editing and the input is not empty.
    var selectedTitle: String? {
        didSet {
            updateControl()
        }
    }

    /// The String to display when the textfield is not editing and the input is not empty.
    var title: String? {
        didSet {
            updateControl()
        }
    }

    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            updateControl(true)
        }
    }

    // MARK: - Initializers

    /**
    Initializes the control
    - parameter frame the frame of the control
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }

    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }

    fileprivate final func privateInit() {
        borderStyle = .none
        createTitleLabel()
        createLineView()
        updateColors()
        addEditingChangedObserver()
        updateTextAligment()
    }

    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(TitledTextField.editingChanged), for: .editingChanged)
    }

    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged() {
        updateControl(true)
        updateTitleLabel(true)
    }

    // MARK: create components

    fileprivate func createTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = titleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = titleColor

        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }

    fileprivate func createLineView() {

        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            if (!isBordered) {
                configureDefaultLineHeight()
            }
        }

        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }

    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * self.lineHeight
    }

    // MARK: Responder handling

    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
    */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updatePlaceholder()
        updateControl(true)
        return result
    }

    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updatePlaceholder()
        updateControl(true)
        return result
    }

    /// update colors when is enabled changed
    override open var isEnabled: Bool {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    // MARK: - View updates

    fileprivate func updateControl(_ animated: Bool = false) {
        updateTitleLabel(animated)
        updateColors()
        if !isBordered {
            updateLineView()
        }
    }

    fileprivate func updateLineView() {
        guard let lineView = lineView else {
            return
        }

        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
        updateLineColor()
    }

    // MARK: - Color updates

    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        updateLineColor()
        updateTitleColor()
        updateTextColor()
    }

    fileprivate func updateLineColor() {
        guard let lineView = lineView else {
            return
        }

        if !isEnabled {
            lineView.backgroundColor = disabledColor
        } else if hasErrorMessage {
            lineView.backgroundColor = lineErrorColor ?? errorColor
        } else {
            lineView.backgroundColor = editingOrSelected ? selectedLineColor : lineColor
        }
    }

    fileprivate func updateTitleColor() {
        guard let titleLabel = titleLabel else {
            return
        }

        if !isEnabled {
            titleLabel.textColor = disabledColor
        } else if hasErrorMessage {
            titleLabel.textColor = titleErrorColor ?? errorColor
        } else {
            if editingOrSelected || isHighlighted {
                titleLabel.textColor = selectedTitleColor
            } else {
                titleLabel.textColor = titleColor
            }
        }
    }

    fileprivate func updateTextColor() {
        if !isEnabled {
            super.textColor = disabledColor
        } else if hasErrorMessage {
            super.textColor = textErrorColor ?? errorColor
        } else {
            super.textColor = cachedTextColor
        }
    }

    // MARK: - Title handling

    fileprivate func updateTitleLabel(_ animated: Bool = false) {
        guard let titleLabel = titleLabel else {
            return
        }

        var titleText: String?
        if hasErrorMessage {
            titleText = titleFormatter(errorMessage!)
        } else {
            if editingOrSelected {
                titleText = selectedTitleOrTitlePlaceholder()
            } else {
                titleText = titleOrPlaceholder()
            }
        }
        titleLabel.text = titleText
        titleLabel.font = titleFont

        updateTitleVisibility(animated)
    }

    fileprivate var _titleVisible: Bool = false

    /*
    *   Set this value to make the title visible
    */
    open func setTitleVisible(
        _ titleVisible: Bool,
        animated: Bool = false,
        animationCompletion: ((_ completed: Bool) -> Void)? = nil
    ) {
        if _titleVisible == titleVisible {
            return
        }
        _titleVisible = titleVisible
        updateTitleColor()
        updateTitleVisibility(animated, completion: animationCompletion)
    }

    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return hasText || isEditing || hasErrorMessage || _titleVisible
    }

    fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
        let updateBlock: Callback = {
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            #if swift(>=4.2)
                let animationOptions: UIView.AnimationOptions = .curveEaseOut
            #else
                let animationOptions: UIViewAnimationOptions = .curveEaseOut
            #endif
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationOptions,
                           animations: { updateBlock() },
                           completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }

    // MARK: - UITextField text/placeholder positioning overrides

    /**
    Calculate the rectangle for the textfield when it is not being edited
    - parameter bounds: The current bounds of the field
    - returns: The rectangle that the textfield should render in
    */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x+leftBorder,
            y: titleHeight-selectedLineHeight,
            width: superRect.size.width-leftBorder,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let titleHeight = self.titleHeight()

        let rect = CGRect(
            x: superRect.origin.x+leftBorder,
            y: titleHeight-selectedLineHeight,
            width: superRect.size.width-leftBorder,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
        return rect
    }

    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: leftBorder,
            y: titleHeight()-selectedLineHeight,
            width: bounds.size.width-leftBorder,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }

    // MARK: - Positioning Overrides

    /**
    Calculate the bounds for the title label. Override to create a custom size title field.
    - parameter bounds: The current bounds of the title
    - parameter editing: True if the control is selected or highlighted
    - returns: The rectangle that the title label should render in
    */
    open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: leftBorder, y: 0, width: bounds.size.width - leftBorder, height: titleHeight())
        }
        return CGRect(x: leftBorder, y: titleHeight(), width: bounds.size.width-leftBorder, height: titleHeight())
    }

    /**
     Calculate the bounds for the bottom line of the control.
     Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }

    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }

    /**
     Calcualte the height of the textfield.
     - returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        guard let font = self.font else {
            return 0.0
        }

        return font.lineHeight + 7.0
    }

    // MARK: - Layout

    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()

        if isBordered {
            lineView.frame = CGRect.zero
            setNeedsDisplay()
        } else {
            lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
        }
        titleLabel.frame = titleLabelRectForBounds(bounds, editing: isTitleVisible())
    }

    /**
     Calculate the content size for auto layout

     - returns: the content size to be used for auto layout
     */
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: titleHeight() + textHeight())
    }

    // MARK: - Helpers

    fileprivate func titleOrPlaceholder() -> String? {
        let title = self.title ?? placeholderText
        return titleFormatter(title)
    }

    fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
        let title = self.errorMessage ?? self.selectedTitle ?? self.title ?? placeholderText
        return titleFormatter(title)
    }
    
    // MARK: - own graphic
    func pathForBorder() -> UIBezierPath {
        let pathLineHeight: CGFloat
        if !editingOrSelected {
            pathLineHeight = lineHeight
        } else {
            pathLineHeight = selectedLineHeight
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: titleHeight()/2, width: bounds.width, height: bounds.height-titleHeight()/2), cornerRadius: 5)

        let another = UIBezierPath(roundedRect: CGRect(x: pathLineHeight, y: titleHeight()/2+pathLineHeight, width: bounds.width-2*pathLineHeight, height: bounds.height-titleHeight()/2-2*pathLineHeight), cornerRadius: 5-pathLineHeight)
        path.append(another.reversing())
        
        if isTitleVisible() {
            let title = NSString(string: selectedTitleOrTitlePlaceholder() ?? "")
            let rect = title.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: titleFont], context: nil)
        
            let titleRect = CGRect(x: leftBorder-2, y: titleHeight()/2, width: rect.width+4, height: pathLineHeight)
            let titlePath = UIBezierPath(rect: titleRect)
            path.append(titlePath.reversing())
        }
        
        return path
    }
    
    func createBorderView() {
        let path = pathForBorder()
        let color: UIColor
        if !isEnabled {
            color = disabledColor
        } else if hasErrorMessage {
            color = lineErrorColor ?? errorColor
        } else {
            color = editingOrSelected ? selectedLineColor : lineColor
        }
        color.set()
        path.fill()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isBordered {
            createBorderView()
        }
    }
    
    // MARK: - Helper Methods
    func topInsetToBorder() -> CGFloat {
        if isBordered {
            return selectedLineHeight + titleFont.lineHeight/2
        }
        return 0
    }
}

// swiftlint:enable all
