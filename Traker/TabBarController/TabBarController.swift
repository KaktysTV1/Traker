import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarsBorder()
        setupTabs()
    }

    // MARK: - Private methods:
    private func setupTabs() {
        let trackersNavigationViewController = UINavigationController(rootViewController: TrackersViewController())
        let statsNavigationViewController = UINavigationController(rootViewController: StatisticsViewController())

        trackersNavigationViewController.tabBarItem.title = L10n.Localizable.Title.trackers
        trackersNavigationViewController.tabBarItem.image = UIImage(named: "record")
        statsNavigationViewController.tabBarItem.title = L10n.Localizable.Title.statistics
        statsNavigationViewController.tabBarItem.image = UIImage(named: "statistics")

        self.setViewControllers(
            [trackersNavigationViewController, statsNavigationViewController],
            animated: true)
    }

    private func setTabBarsBorder() {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = .YPGray
        tabBar.addSubview(lineView)
        tabBar.clipsToBounds = true
    }
}
