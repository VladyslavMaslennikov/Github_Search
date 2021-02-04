//
//  TabBarController.swift
//  Github_Search
//
//  Created by Vladyslav on 03.02.2021.
//
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController")
        let historyController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        
        let item1 = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let item2 = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        searchController.tabBarItem = item1
        historyController.tabBarItem = item2
        viewControllers = [searchController, historyController]
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = .blue
    }

}
