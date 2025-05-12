import UIKit
import DiiaAuthorizationPinCode
import DiiaAuthorization
import DiiaCommonTypes

// MARK: - Default Authorization
extension BiometryRequestViewModel {
    static func `default`(authFlow: AuthFlow) -> BiometryRequestViewModel {
        let biometryType = BiometryHelper.biometricType()
        
        let title = biometryType == .face
            ? R.Strings.authorization_biometry_face_id_title.localized()
            : R.Strings.authorization_biometry_touch_id_title.localized()
        
        let description = biometryType == .face
            ? R.Strings.authorization_biometry_face_id_description.localized()
            : R.Strings.authorization_biometry_touch_id_description.localized()
        
        let icon = biometryType == .face
            ? R.image.faceId.image
            : R.image.fingerprint.image
        
        return BiometryRequestViewModel(
            title: title,
            description: description,
            icon: icon,
            authFlow: authFlow,
            completionHandler: { (isAllowed, _) in
                StoreHelper.instance.save(isAllowed, type: Bool.self, forKey: .isBiometryEnabled)
                
                switch ServicesProvider.shared.authService.authState {
                case .userAuth:
                    AppRouter.instance.open(module: MainTabBarModule(), needPincode: false, asRoot: true)
                    AppRouter.instance.didFinishStartingWithPincode = true
                case .notAuthorized, .serviceAuth:
                    break
                }
            }
        )
    }
}
