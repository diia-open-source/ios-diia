
import UIKit
import DiiaUIComponents
import DiiaCommonTypes

class FeedOfflineModeConstructor {
    static func buildOfflineModel() -> DSConstructorModel {
        var welcomeTitle = R.Strings.authorization_welcome.localized()
        
        let buttonGroup = DSButtonIconRoundedGroupModel(
            items: [
                .init(btnIconRoundedMlc: .init(
                    label: R.Strings.feed_qr_title.localized(),
                    icon: Constants.qrIcon,
                    action: DSActionParameter(type: Constants.qrAction)))
            ])
        
        return DSConstructorModel(
            topGroup: [
                AnyCodable.dictionary([DSTopGroupViewBuilder.modelKey:
                                        AnyCodable.fromEncodable(encodable: DSTopGroupOrg(titleGroupMlc: .init(heroText: welcomeTitle)))])
            ],
            body: [
                AnyCodable.dictionary([DSButtonIconRoundedGroupBuilder.modelKey: AnyCodable.fromEncodable(encodable: buttonGroup)])
            ],
            bottomGroup: nil,
            ratingForm: nil
        )
    }
}

// MARK: - Constants
extension FeedOfflineModeConstructor {
    private enum Constants {
        static let whiteCardSmallIcon = "ellipseArrowRight"
        static let whiteCardDoubleIcon = "safetyLarge"
        
        static let qrIcon = "qrScanWhite"
        static let tridentIcon = "tridentWhite"
        static let targetIcon = "targetWhite"
        static let failedConnectionIcon = "failedConnection"

        static let blackCardAction = "invincibilityPoints"
        static let qrAction = "qr"
        static let dronesAction = "militaryDonation"
        static let failedConnectionAction = "failedConnection"
        static let militaryBondsAction = "militaryBonds"
        static let enemyTrackAction = "enemyTrack"
    }
}
