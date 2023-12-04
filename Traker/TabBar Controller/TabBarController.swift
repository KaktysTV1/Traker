//
//  TabBarController.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 28.11.2023.
//

import UIKit

func createTrakerViewController() -> UINavigationController {
    let trakerViewController = TrackersViewController()
    trakerViewController.title = "Трекеры"
    trakerViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrakItem"), tag: 1)
    return UINavigationController(rootViewController: trakerViewController)
}

func createStaticticViewController() -> UINavigationController {
    let statisticViewController = StatisticViewController()
    statisticViewController.title = "Статистика"
    statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticItem"), tag: 2)
    return UINavigationController(rootViewController: statisticViewController)
}

func createTabBarController() -> UITabBarController {
    let tabBarController = UITabBarController()
    UITabBar.appearance().backgroundColor = UIColor(named: "White")
    tabBarController.viewControllers = [createTrakerViewController(), createStaticticViewController()]
    return tabBarController
}
