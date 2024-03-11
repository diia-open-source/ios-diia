import UIKit
import DiiaUIComponents

final class DSImageNameResolver: DSImageNameProvider {
    
    static let instance = DSImageNameResolver()
    
    func imageForCode(imageCode: String?) -> UIImage? {
        guard let imageCode = imageCode else { return nil }
        return UIImage(named: "DS_" + imageCode) ?? UIImage(named: "ds_" + imageCode) ?? R.image.ds_placeholder.image
    }
    
    func imageNameForCode(imageCode: String) -> String {
        return "DS_" + imageCode
    }
}
