import UIKit
import DiiaUIComponents

internal extension NibLoadable {
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil) // If you specify nil, this method looks for the nib file in the main bundle.
    }
}
