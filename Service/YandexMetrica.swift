import Foundation
import YandexMobileMetrica

final class YandexMetrica {
    // MARK: - Properties:
    static let shared = YandexMetrica()

    // MARK: - Methods:
    private init() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "da3b5e6b-80c7-4986-bb72-ef1fbf4ced53") else {
            return
        }
        YMMYandexMetrica.activate(with: configuration)
    }

    func sendReport(about event: String, and item: String?, on screen: String) {
        let params: [AnyHashable: Any] = ["event": event, "item": item ?? "", "screen": screen]
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@")
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
