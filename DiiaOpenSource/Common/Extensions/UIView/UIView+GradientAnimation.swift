import UIKit

public extension UIView {

    private struct ConstantsContainer {
        static let gradientPower: CGFloat = 1.5
        static let maxAlpha = 1.0
        static let minAlpha = 0.6
    }

    private enum StateAnimation {
        case delay
        case increase
        case decrease
    }

    @objc func setRadialGradient() {
        self.backgroundColor = .white
      let greenColorsGradient = [UIColor(red: 116.0/255.0, green: 164.0/255.0, blue: 247.0/255.0, alpha: 0.68).cgColor, UIColor(red: 116.0/255.0, green: 164.0/255.0, blue: 247.0/255.0, alpha: 0).cgColor]
      
         let redColorsGradient = [UIColor(red: 223.0/255.0, green: 144.0/255.0, blue: 222.0/255.0, alpha: 0.68).cgColor, UIColor(red: 223.0/255.0, green: 144.0/255.0, blue: 222.0/255.0, alpha: 0).cgColor]
         
         let blueColorsGradient = [UIColor(red: 243.0/255.0, green: 190.0/255.0, blue: 129.0/255.0, alpha: 0.68).cgColor, UIColor(red: 243.0/255.0, green: 190.0/255.0, blue: 129.0/255.0, alpha: 0).cgColor]
      
        self.radialGradientBackground(startPoint: CGPoint(x: 1.0, y: 1.0), endPoint: CGPoint(x: 0, y: 0), colors: blueColorsGradient, finishLocation: 1.3, statesAnimation: [.delay, .increase, .decrease], duration: 1.2)

        self.radialGradientBackground(startPoint: CGPoint(x: 1.0, y: 0.0), endPoint: CGPoint(x: 0.0, y: 1.0), colors: redColorsGradient, finishLocation: 1.2, statesAnimation: [.decrease, .delay, .increase], duration: 1.2)

      self.radialGradientBackground(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1, y: 1), colors: greenColorsGradient, finishLocation: 1.0, statesAnimation: [.increase, .decrease, .delay], duration: 1.2)
    }

    private func radialGradientBackground(startPoint: CGPoint, endPoint: CGPoint, colors: [CGColor], finishLocation: Double = 1.0, statesAnimation: [StateAnimation], duration: CFTimeInterval) {

        // Create New Gradient Layer
        let radialGradientLayer: CAGradientLayer = CAGradientLayer()

        // Feed in Parameters
        radialGradientLayer.frame = self.frame
        radialGradientLayer.colors = colors
        radialGradientLayer.type = .radial
        radialGradientLayer.startPoint = startPoint
        radialGradientLayer.endPoint = CGPoint(x: ConstantsContainer.gradientPower * endPoint.x, y: ConstantsContainer.gradientPower * endPoint.y)
        radialGradientLayer.locations = [0.0, NSNumber(value: finishLocation)]

        // Create animation
        let firstAnimation = createAnimation(state: statesAnimation[0], duration: duration)

        let secondAnimation = createAnimation(state: statesAnimation[1], duration: duration, beginTime: 1 / 3 * duration)

        let thirdAnimation = createAnimation(state: statesAnimation[2], duration: duration, beginTime: 2 / 3 * duration)

        // Create animation group
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [firstAnimation, secondAnimation, thirdAnimation]
        animationGroup.duration = firstAnimation.duration + secondAnimation.duration + thirdAnimation.duration
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: .linear)
        animationGroup.repeatCount = Float.infinity
        radialGradientLayer.add(animationGroup, forKey: "animateGradient")
        self.layer.insertSublayer(radialGradientLayer, at: 0)
    }

    private func createAnimation(state: StateAnimation, duration: CFTimeInterval, beginTime: CFTimeInterval = 0) -> CABasicAnimation {
        var startValue: Double
        var finishValue: Double

        switch state {
        case .delay:
            startValue = ConstantsContainer.minAlpha
            finishValue = ConstantsContainer.minAlpha
        case .increase:
            startValue = ConstantsContainer.minAlpha
            finishValue = ConstantsContainer.maxAlpha
        case .decrease:
            startValue = ConstantsContainer.maxAlpha
            finishValue = ConstantsContainer.minAlpha
        }

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = startValue
        animation.toValue = finishValue
        animation.duration = duration / 3
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.beginTime = beginTime
        return animation
    }
}
