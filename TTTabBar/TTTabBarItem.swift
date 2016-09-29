//
//  TabBarItem.swift
//  Octoly
//
//  Created by Adrien on 08/03/16.
//  Copyright © 2016 Octoly. All rights reserved.
//

import UIKit
import TTTabBar

class TabBarItem: TTTabBarItem {
    
    var line:UIView?
    var name:String?
    var label:UILabel?
    
    override init(viewController: UIViewController) {
        super.init(viewController: viewController)
        
        super.offsetY = 0
        super.offsetBottom = 0
        
        self.backgroundColor = MENU_BACKGROUND_COLOR
        
        self.line = UIView()
        self.line?.backgroundColor = HIGLIGHT_BACKGROUND_COLOR
        self.addSubview(self.line!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func unselectItem() {
        self.backgroundColor = MENU_BACKGROUND_COLOR
        self.line?.alpha = 0
    }
    
    internal func selectItem() {
        self.backgroundColor = MENU_ACTIVE_BACKGROUND_COLOR
        self.line?.alpha = 1
    }
    
    internal func updateWidth() {
        self.frame = CGRect(x: self.frame.origin.x-1, y: 0, width: self.frame.width+2, height: MENU_HEIGHT)
        self.line?.frame = CGRect(x: 0, y: self.frame.height - MENU_LINE_HEIGHT, width: self.frame.width, height: MENU_LINE_HEIGHT)
        self.label?.frame = CGRect(x: 40, y: 8, width: 16, height: 16)
    }
    
    func hideNew() {
        self.label?.alpha = 0
    }
    
    func setItem(_ name:String) {
        
        self.name = name
        
        if (self.name == "inbox") {
            
            label = UILabel()
            label?.textAlignment = .center
            label?.textColor = WHITE
            label?.font = UIFont.boldSystemFont(ofSize: 9)
            label?.backgroundColor = HIGLIGHT_BACKGROUND_COLOR
            label?.layer.cornerRadius = 6
            label?.layer.masksToBounds = true
            label?.alpha = 0
            self.addSubview(self.label!)
        }
    }
    
    func setBubble(_ name: String, bubble:Int) {
        
        if (self.name == name) {
            
            if (bubble > 0) {
                label?.text = String(format:"%d",bubble)
                label?.alpha = 1
            } else {
                label?.alpha = 0
            }
        }
    }
}
