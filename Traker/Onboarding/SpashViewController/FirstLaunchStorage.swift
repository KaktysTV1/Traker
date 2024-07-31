import Foundation

final class FirstLaunchStorage {
    // MARK: - Properties:
    static let shared = FirstLaunchStorage()
    var wasLaunchedBefore: Bool {
        get {
            userDefaults.bool(forKey: "firstLaunch")
        }
        set {
            userDefaults.setValue(newValue, forKey: "firstLaunch")
        }
    }
    
    // MARK: - Private properties:
    private var userDefaults = UserDefaults.standard
    
    // MARK: - Methods:
    func cleanUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys))
    }
}

