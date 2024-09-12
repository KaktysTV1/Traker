import UIKit

final class OnboardingViewController: UIPageViewController {
    // MARK: - Private Properties:
    private lazy var pages: [UIViewController] = {
        let firstPage = FirstPageViewController()
        let secondPage = SecondPageViewController()
        
        return [firstPage, secondPage]
    }()
    
    private lazy var wowButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle(L10n.Localizable.Button.wowTechnology, for: .normal)
        button.backgroundColor = .YPOnlyBlack
        button.tintColor = .YPOnlyWhite
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(wowButtonTapped), for: .touchUpInside)
        self.view.addSubview(button)
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = .YPBlack
        pageControl.pageIndicatorTintColor = .YPGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        
        return pageControl
    }()
    
    // MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setUpConstraints()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    // MARK: - Methods:
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            wowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wowButton.heightAnchor.constraint(equalToConstant: 60),
            wowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: wowButton.topAnchor, constant: -24)
        ])
    }
    
    // MARK: - Objc-Methods:
    @objc private func wowButtonTapped() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            fatalError("Не удалось получить текущее окно")
        }
        window.rootViewController = TabBarViewController()
    }
}
// MARK: - UIPageViewControllerDataSource:
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
