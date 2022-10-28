//
//  ViewController.swift
//  Netflix Clone
//
//  Created by mac on 24/10/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        
    }
    
    func configureTabBar() {
        
        let homeNC      = UINavigationController(rootViewController: HomeViewController())
        let topSearchNC = UINavigationController(rootViewController: SearchViewController())
        let upcomingNC  = UINavigationController(rootViewController: UpcomingViewController())
        let downloadNC  = UINavigationController(rootViewController: DownloadsViewController())
        
        
        homeNC.tabBarItem.image         = TabBarImages.homeNcImg
        topSearchNC.tabBarItem.image    = TabBarImages.topSearchImg
        upcomingNC.tabBarItem.image     = TabBarImages.upcomingImg
        downloadNC.tabBarItem.image     = TabBarImages.downloadImg
        
        homeNC.title        = "Home"
        topSearchNC.title   = "Top Search"
        upcomingNC.title    = "Upcoming"
        downloadNC.title    = "Downloads"
        
        UITabBar.appearance().tintColor = .systemGreen
        
        setViewControllers([homeNC, topSearchNC, upcomingNC, downloadNC], animated: true)
    }
}

enum TabBarImages {
    static let homeNcImg = UIImage(systemName: "house.circle")
    static let topSearchImg = UIImage(systemName: "magnifyingglass.circle")
    static let downloadImg =  UIImage(systemName: "arrow.down.circle")
    static let upcomingImg = UIImage(systemName: "play.circle")
}
