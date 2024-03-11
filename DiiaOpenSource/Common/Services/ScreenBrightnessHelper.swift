import UIKit
import DiiaCommonTypes

class ScreenBrightnessHelper: ScreenBrightnessServiceProtocol {
    
    // MARK: - Properties
    private var brightnessBeforeIncreasing: CGFloat?
    
    // MARK: - Singleton
    private init() { }
    
    static let shared = ScreenBrightnessHelper()
    
    // MARK: - Public Methods
    func increaseBrightness() {
        guard UIScreen.main.brightness != UIScreen.maxBrightness else { return }
        
        brightnessBeforeIncreasing = UIScreen.main.brightness
        UIScreen.main.setBrightness(to: UIScreen.maxBrightness)
    }
    
    func resetBrightness() {
        if let brightness = brightnessBeforeIncreasing {
            UIScreen.main.setBrightness(to: brightness)
        }
        brightnessBeforeIncreasing = nil
    }
}
