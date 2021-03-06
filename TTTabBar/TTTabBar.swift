//
//  TTTabBar.swift
//  Tutton
//
//  Created by Eduardo Iglesias on 3/6/15.
//  Copyright (c) 2015 Tutton. All rights reserved.
//

import UIKit

open class TTTabBar: UIViewController {
    
    private var detailView: UIView! //View that will show controllers
    public var activeTabBar: TTTabBarItem? //Active showing view Controller
    private var activeView: UIView? //Active showing view Controller
    private var tabBarView: UIView! //View of tabBar
    private var contentTabBarView : UIView! //Content, where background is render
    
    public var tabBarHidden = false
    
    //TabBar Items, which include VC
    public var tabBarItems: [TTTabBarItem] = []
    
    private let defaultTabBarHeight: CGFloat = 44
    private var initialTabBarHeight: CGFloat = 0
    
    //TabBar Custom
    public var tabBarHeight: CGFloat = 0 //Height of the TabBar, if a TTTabBarItem is bigger, will be over the tabBar
    public var defaultTabBarItem: TTTabBarItem!
    public var spaceBetweenTabs: CGFloat = 5
    public var tabBackgroundColor = UIColor.white
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //Defaults
        if (tabBarHeight == 0) {
            tabBarHeight = defaultTabBarHeight
        }
        
        initialTabBarHeight = tabBarHeight
        
        
        //Create the detailView
        detailView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-tabBarHeight))
        detailView.backgroundColor = UIColor.clear
        
        //Creat TabBar view
        tabBarView = UIView(frame: CGRectMake(0, self.view.frame.height-tabBarHeight, self.view.frame.width, tabBarHeight))
        contentTabBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, tabBarHeight))
        
        //defaults
        tabBarView.backgroundColor = UIColor.clear
        
        //Add subviews to mainView
        tabBarView.addSubview(contentTabBarView)
        self.view.addSubview(detailView)
        self.view.addSubview(tabBarView)
    }
    
    //Modify tabbar with custom options
    public func updateTabBarView() {
        
        //Update the detailView
        detailView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-tabBarHeight)
        
        //Update TabBar view
        tabBarView.frame = CGRectMake(0, self.view.frame.height-tabBarHeight, self.view.frame.width, tabBarHeight)
        
        //Verify that has defaultTabBar
        if (defaultTabBarItem) != nil {
            
        }else{
            if tabBarItems.count > 0 {
                defaultTabBarItem = tabBarItems[0]
            }
        }
        
        self.updateBackgroundColor(color: tabBackgroundColor)
        self.updateTabBarHeight()
        self.renderButtons()
    }
    
    private func updateBackgroundColor (color: UIColor) {
        contentTabBarView.backgroundColor = color
    }
    
    public func updateTabBarHeight() {
        for tabBarItem in tabBarItems {
            
            //if one button is greather default. Set the tabBarView greather
            if tabBarItem.frame.height + tabBarItem.offsetBottom > tabBarView.frame.height {
                tabBarHeight = tabBarItem.frame.height + tabBarItem.offsetBottom
                tabBarView.frame = CGRectMake(0, self.view.frame.height-tabBarHeight, self.view.frame.width, tabBarHeight)
                contentTabBarView.frame = CGRectMake(0, tabBarHeight-initialTabBarHeight, self.view.frame.width, initialTabBarHeight)
                
                
            }
        }
    }
    
    private func renderButtons() {
        
        //Get all TabBarItems and divide the width between
        let widthPerButton = (self.view.frame.width - spaceBetweenTabs*CGFloat(tabBarItems.count))/CGFloat(tabBarItems.count)
        
        //Add subview buttons to tabBar
        var tempX = spaceBetweenTabs //Start position of buttons, logical position
        for tabBarItem in tabBarItems {
            //Set images if has
            if let image = tabBarItem.image {
                tabBarItem.setImage(image, for: UIControl.State.normal)
            }
            
            if defaultTabBarItem == tabBarItem {
                //Load the default VC
                self.loadViewControllerFrom(tabBarItem: tabBarItem)
            }
            
            //Call action on touchUpInside
            tabBarItem.addTarget(self, action: #selector(self.tabBarItemClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            
            //if the height of the tabBarItem, is default (40), change to tabBarView height
            var newHeight = tabBarItem.frame.height
            if tabBarItem.frame.height == defaultTabBarHeight {
                newHeight = defaultTabBarHeight
            }
            
            //if width of tanBarItem is not 0, set the custom size
            var customWidth = widthPerButton
            var positionX = tempX
            if tabBarItem.frame.width > 0 {
                customWidth = tabBarItem.frame.width
                
                //New position of X
                //Center button on distance between buttons + custom width
                positionX = tempX + widthPerButton/2 - customWidth/2
            }
            
            //Modify frame of TabBarItems
            //- tabBarItem.offsetBottom
            let off = (tabBarView.frame.height - tabBarItem.frame.height) - tabBarItem.offsetBottom
            tabBarItem.frame = CGRectMake(positionX, tabBarItem.offsetY + off , customWidth, newHeight)
            tempX += widthPerButton+spaceBetweenTabs
            
            tabBarView.addSubview(tabBarItem)
        }
    }
    
    @objc public func tabBarItemClicked(sender: AnyObject) {
        if let tabBar = sender as? TTTabBarItem {
            self.loadViewControllerFrom(tabBarItem: tabBar)
        }
    }
    
    public func loadViewControllerFrom(tabBarItem: TTTabBarItem?) {
        if let item = tabBarItem {
            if !self.ttTabBar(tabBar: self, shouldChangeTab: item) {
                return
            }
            
            //if users click on the same tab that is active, return
            if activeTabBar != nil {
                if item == activeTabBar {
                    return
                }
            }
        }
        
        //Change image to the old tabBarItem to no selected
        if let tabBar = activeTabBar {
            
            self.ttTabBar(tabBar: self, tabWillDisappear: tabBar)
            if let image = tabBar.image {
                tabBar.setImage(image, for: UIControl.State.normal)
            }
            
            //Remove actual View
            if let vc = tabBar.viewController {
                vc.view.removeFromSuperview()
            }
            
            self.ttTabBar(tabBar: self, tabDidDisappear: tabBar)
        }
        
        if let view = activeView {
            view.removeFromSuperview()
        }
        
        if let item = tabBarItem {
            //Change image to the new tabBarItem to selected
            if let image = item.selectedImage {
                item.setImage(image, for: UIControl.State.normal)
            }
            
            
            //add VC to detailView
            if let vc = item.viewController {
                self.ttTabBar(tabBar: self, tabWillAppear: item)
                //set active bar
                activeTabBar = item
                
                vc.view.frame = self.detailView.bounds
                detailView.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
                
                self.ttTabBar(tabBar: self, tabDidAppear: item)
            }
        }
    }
    
    //IF you need to load an external view controller, that is not on the tab menu
    public func loadViewController(vc: UIViewController) {
        //Change image to the old tabBarItem to no selected
        if let tabBar = activeTabBar {
            self.ttTabBar(tabBar: self, tabWillDisappear: tabBar)
            if let image = tabBar.image {
                tabBar.setImage(image, for: UIControl.State.normal)
            }
            
            //Remove actual View
            if let vc = tabBar.viewController {
                vc.view.removeFromSuperview()
            }
            self.ttTabBar(tabBar: self, tabDidDisappear: tabBar)
        }
        
        if let view = activeView {
            view.removeFromSuperview()
        }
        
        //add VC to detailView
        //set active bar
        activeTabBar = nil
        activeView = vc.view
        
        vc.view.frame = self.detailView.bounds
        detailView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    // MARK: - Get Functions
    public func getActualController() -> UIViewController? {
        if let activeTab = activeTabBar {
            return activeTab.viewController
        }
        return nil
    }
    
    //MARK: hide/show tabBar
    public func hideTabBar(animated: Bool) {
        if !tabBarHidden  {
            UIView.animate(withDuration: 0.2) {
                self.tabBarView.frame.origin.y += self.tabBarView.frame.width
                self.detailView.frame.size.height = self.view.frame.height
            }
            tabBarHidden = true
        }
    }
    
    public func showTabBar(animated: Bool) {
        if tabBarHidden  {
            UIView.animate(withDuration: 0.2) {
                self.tabBarView.frame.origin.y -= self.tabBarView.frame.width
                self.detailView.frame.size.height -= self.contentTabBarView.frame.height
            }
            
            tabBarHidden = false
        }
        
    }
    
    // MARK: - Active TabBar
    public func isTabSelected(tab: TTTabBarItem) {
        if activeTabBar == tab {
            
        }
    }
    
    
    //MARK: overridable Func
    open func ttTabBar(tabBar: TTTabBar, shouldChangeTab tabBarItem: TTTabBarItem) -> Bool {
        if tabBarItem.isButton {
            self.ttTabBar(tabBar: tabBar, buttonHasBeenClicked: tabBarItem)
            return false
        }
        
        return true
    }
    
    open func ttTabBar(tabBar: TTTabBar, tabWillDisappear tabBarItem: TTTabBarItem) {
        
    }
    
    open func ttTabBar(tabBar: TTTabBar, tabDidDisappear tabBarItem: TTTabBarItem) {
        
    }
    
    open func ttTabBar(tabBar: TTTabBar, tabWillAppear tabBarItem: TTTabBarItem) {
        
    }
    
    open func ttTabBar(tabBar: TTTabBar, tabDidAppear tabBarItem: TTTabBarItem) {
        
    }
    
    open func ttTabBar(tabBar: TTTabBar, buttonHasBeenClicked tabBarItem: TTTabBarItem) {
        
    }
}
