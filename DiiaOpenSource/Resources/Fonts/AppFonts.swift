import UIKit
import DiiaUIComponents

struct AppMainFont: FontProtocol {
    
    private enum MainType: FontStyleProtocol {
        case regular
        case bold
        case light
        case medium
        
        func size(_ size: CGFloat) -> UIFont {
            let font: UIFont?
            
            switch self {
            case .regular: font = UIFont(name: "e-Ukraine-Regular", size: size)
            case .bold: font = UIFont(name: "e-Ukraine-Bold", size: size)
            case .light: font = UIFont(name: "e-Ukraine-Light", size: size)
            case .medium: font = UIFont(name: "e-Ukraine-Medium", size: size)
            }
            
            return font ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    var regular: FontStyleProtocol { MainType.regular }
    var bold: FontStyleProtocol { MainType.bold }
    var light: FontStyleProtocol { MainType.light }
    var medium: FontStyleProtocol { MainType.medium }
}

struct AppHeadingFont: FontProtocol {
    
    private enum HeadingType: FontStyleProtocol {
        case regular
        case light
        
        func size(_ size: CGFloat) -> UIFont {
            let font: UIFont?
            
            switch self {
            case .regular: font = UIFont(name: "e-UkraineHead-Regular", size: size)
            case .light: font = UIFont(name: "e-UkraineHead-Light", size: size)
            }
            
            return font ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    var regular: FontStyleProtocol { HeadingType.regular }
    var bold: FontStyleProtocol { HeadingType.regular }
    var light: FontStyleProtocol { HeadingType.light }
    var medium: FontStyleProtocol { HeadingType.regular }
}
