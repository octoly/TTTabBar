//
//  TabBar.swift
//  Octoly
//
//  Created by Adrien on 08/03/16.
//  Copyright © 2016 Octoly. All rights reserved.
//

import UIKit
import TTTabBar

class TabBar: TTTabBar {
    
    var tabbars:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        super.view.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBubble(_:)), name: NSNotification.Name(rawValue: "updateBubble"), object: nil)
        
        super.tabBarHeight = MENU_HEIGHT
        super.spaceBetweenTabs = 0
        
        let nav1 = UINavigationController()
        nav1.viewControllers = [ProductsController()]
        
        let item1 = TabBarItem(viewController:nav1)
        item1.image = UIImage(named: "menu-home")
        item1.setItem("home")
        
        let item2 = TabBarItem(viewController:OrdersController())
        item2.image = UIImage(named: "menu-orders")
        item2.setItem("orders")
        
        let nav3 = UINavigationController()
        nav3.viewControllers = [InboxController()]
        
        let item3 = TabBarItem(viewController:nav3)
        item3.image = UIImage(named: "menu-inbox")
        item3.setItem("inbox")
        
        let nav4 = UINavigationController()
        nav4.viewControllers = [BlogController()]
        
        let item4 = TabBarItem(viewController:nav4)
        item4.image = UIImage(named: "menu-magazine")
        item4.setItem("magazine")
        
        let nav5 = UINavigationController()
        nav5.viewControllers = [SettingsController()]
        
        let item5 = TabBarItem(viewController:nav5)
        item5.image = UIImage(named: "menu-account")
        item5.setItem("account")
        
        self.tabBackgroundColor = MENU_BACKGROUND_COLOR
        self.tabBarItems = [item1, item2, item3, item4, item5]
        self.updateTabBarView()
        self.updateItemsWidth()
    }
    
    override func ttTabBar(tabBar: TTTabBar, shouldChangeTab tabBarItem: TTTabBarItem) -> Bool {
        
        let tb = tabBar as! TabBar
        let tbitem = tabBarItem as! TabBarItem
        
        for item in tb.tabBarItems {
            let i = item as! TabBarItem
            i.unselectItem()
        }
        
        tbitem.selectItem()
        return true
    }
    
    func updateItemsWidth() -> Void {
        
        for item in self.tabBarItems {
            let i = item as! TabBarItem
            i.updateWidth()
        }
    }
    
    func updateBubble(_ notification:Foundation.Notification) -> Void {
        
        let userInfo:Dictionary<String, String> = (notification as NSNotification).userInfo as! Dictionary<String, String>
        
        for item in self.tabBarItems {
            let i = item as! TabBarItem
            if (i.name == userInfo["item"]) {
                i.setBubble(i.name!, bubble: Int(userInfo["bubble"]!)!)
            }
        }
    }
}
