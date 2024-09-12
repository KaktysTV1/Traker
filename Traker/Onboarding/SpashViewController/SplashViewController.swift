import Foundation
import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private Properties:
    private let firstLaunchStorage = FirstLaunchStorage.shared
    private var wasLaunchedBefore: Bool = FirstLaunchStorage().wasLaunchedBefore
    
    private lazy var imageView: UIImageView = {
        let logo = UIImage(named: "praktikumLogo")
        let image = UIImageView(image: logo)
        image.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(image)
        
        return image
    }()
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .YPBlue
        setupConstraints()
        checkIfFirstLaunch()
    }
    
    // MARK: - Private Methods:
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 91),
            imageView.heightAnchor.constraint(equalToConstant: 94)
        ])
    }
    
    private func checkIfFirstLaunch() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Не удалось инициализировать SceneDelegate")
        }
        
        if firstLaunchStorage.wasLaunchedBefore == false {
            sceneDelegate.window?.rootViewController = OnboardingViewController()
            firstLaunchStorage.wasLaunchedBefore = true
        } else {
            sceneDelegate.window?.rootViewController = TabBarViewController()
        }
    }
}
