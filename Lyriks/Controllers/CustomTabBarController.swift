//
//  CustomTabBarController.swift
//  Lyriks
//
//  Created by Eduardo Pereira on 31/07/19.
//  Copyright © 2019 Eduardo Pereira. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = Color.gray
       
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name:"Silentina Movie", size: 12) ?? UIFont.preferredFont(forTextStyle: .title1)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        // Tab One
        
        let tabOne = ViewController()
        let image = UIImage(named: "home")
        let tabOneBarItem = UITabBarItem(title: "Discover", image: image, selectedImage: image)
        tabOne.tabBarItem = tabOneBarItem
        // Tab two
        let tabTwo = SearchViewController()
        let image2 = UIImage(named: "search")
        let tabTwoBarItem = UITabBarItem(title: "Search", image: image2, selectedImage: image2)
        tabTwo.tabBarItem = tabTwoBarItem
        // Tab two
        let tabThree = FavoritesViewController()
        let image3 = UIImage(named: "star")
        let tabThreeBarItem = UITabBarItem(title: "Favorite", image: image3, selectedImage: image3)
        tabThree.tabBarItem = tabThreeBarItem

        self.viewControllers = [tabOne,tabTwo,tabThree]
    
    }
    

}
