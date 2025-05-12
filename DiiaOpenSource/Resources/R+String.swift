import Foundation

enum R {
    enum Strings: String {
        // MARK: - Accessibility
        case general_accessibility_close
        case auth_accessibility_start_person_data
        case auth_accessibility_start_checkmark
        case main_screen_accessibility_top_qr_scanner_button
        case main_screen_accessibility_bottom_bar_cell_active
        case main_screen_accessibility_bottom_bar_cell_inactive
        case main_screen_accessibility_bottom_bar_cell_tabulation
        
        // MARK: - General
        case general_cancel
        case general_problem_ok
        case general_confirm
        case general_loading
        case general_template_text_copied
        case general_phone_uuid
        case general_app_version
        
        // MARK: - Authorization
        case authorization_welcome
        case authorization_authorization
        case authorization_biometry_face_id_title
        case authorization_biometry_face_id_description
        case authorization_biometry_touch_id_title
        case authorization_biometry_touch_id_description
        case authorization_forget
        case authorization_triple_error
        case authorization_repeat
        case authorization_authorize
        case authorization_info
        case authorization_read_please
        case authorization_personal_data_message
        case authorization_enter_pin_title
        case authorization_dont_remember_pin
        case authorization_new_pin_details
        case authorization_repeat_pin_details
        case authorization_methods_title
        case authorization_data_processing_agreement
        
        // MARK: - DocumentsGeneral
        case document_general_verification_failure
        case document_reordering_title
        case document_general_date_template
        case document_reordering_docs_number_small
        case document_reordering_docs_number_big
        
        // MARK: - Menu
        case menu_notifications
        case menu_diia_id
        case menu_diia_id_history
        case menu_update
        case menu_active_sessions
        case menu_faq
        case menu_support
        case menu_title_settings
        case menu_change_pin
        case menu_allow_touch_id
        case menu_allow_face_id
        case menu_copy_uid
        case menu_logout
        case menu_logout_title
        case menu_logout_message
        case menu_logout_cancel
        case menu_change_pin_success_emoji
        case menu_change_pin_success_title
        case menu_change_pin_success_description
        case menu_change_pin_thank
        
        // MARK: - Settings
        case settings_docs_order

        // MARK: - Main
        case main_screen_feed
        case main_screen_services
        case main_screen_menu
        case main_screen_documents
        
        // MARK: - QRCodeScanner
        case photo_problem
        case photo_problem_description
        case permissions_camera_not_granted
        case permissions_camera_settings
        case permissions_settings
        case permissions_exit
        case qr_incorrect_code
        
        // MARK: - DocumentsCopyRequest
        case doc_copy_title
        
        // MARK: - DriverLicense
        case driver_document_name
        
        // MARK: - Communication
        case communication_bot_not_available
        case communication_messenger_not_installed
        case communication_wants_open
        case communication_wants_open_named
        case communication_open_cancel
        case communication_open_accept
        
        // MARK: - User identification
        case user_identification_start_title
        case user_identification_start_details
        
        // MARK: - Errors
        case error_no_internet
        
        // MARK: - Feed
        case feed_ticker_label
        case feed_qr_title
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.main, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.main, comment: "")
            return String(format: localized, arguments)
        }
    }
}
