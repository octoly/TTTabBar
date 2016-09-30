//
//  TTTabBarItem.swift
//  Tutton
//
//  Created by Eduardo Iglesias on 3/6/15.
//  Copyright (c) 2015 CreApps. All rights reserved.
//

import UIKit

open class TTTabBarItem: UIButton {
    
    public var offsetY: CGFloat = 0 //Offset from Top Y
    public var offsetBottom: CGFloat = 0 //Offset from Bottom, like margin
    
    public var image: UIImage?
    public var selectedImage: UIImage?
    public var viewController: UIViewController?
    
    //If is a button, set to yes
    public var isButton = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    open override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    //Init with default size
    public init(image: UIImage?, selected: UIImage?) {
        super.init(frame: CGRect(x:0, y:0, width:0, height: 44))
        self.setImage(image, for: UIControlState.normal)
        self.image = image
        self.selectedImage = selected
    }
    
    public init(viewController: UIViewController) {
        super.init(frame: CGRect(x:0, y:0, width:0, height: 44))
        self.viewController = viewController
    }
}
