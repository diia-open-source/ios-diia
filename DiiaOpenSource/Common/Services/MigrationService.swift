import Foundation

final class MigrationService {
    
    private let fileManager = FileManager.default
    
    private enum Constants {
        static let documentsDirectory = "dsDocuments"
    }
    
    func migrateIfNeeded() {
        guard
            let oldFileDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let newFileDirectoryUrl = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else {
            return
        }
        
        do {
            if fileManager.fileExists(atPath: oldFileDirectoryUrl.appendingPathComponent(Constants.documentsDirectory).path) {
                try fileManager.moveItem(at: oldFileDirectoryUrl.appendingPathComponent(Constants.documentsDirectory),
                                         to: newFileDirectoryUrl.appendingPathComponent(Constants.documentsDirectory))
            }
        } catch let error {
            log("~~~> Error during migration: \(error)")
        }
    }
    
}
