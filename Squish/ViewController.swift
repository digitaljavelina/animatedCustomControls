//
//  ViewController.swift
//  Squish
//
//  Created by mike on 4/29/15.
//  Copyright (c) 2015 Dangerous Kittens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let menuItemImage = UIImage(named: "bg-menuitem")!
    let menuItemImagePressed = UIImage(named: "bg-menuitem-highlighted")!
    let starImage = UIImage(named: "icon-star")!
    
    let starMenuItem1 = SquishyControlItem(backgroundImage: menuItemImage, highlightedImage: menuItemImagePressed, contentImage: starImage, highlightedContentImage:nil)
    
    let menus = [starMenuItem1]
    
    let startItem = SquishyControlItem(backgroundImage: UIImage(named: "bg-addbutton"), highlightedImage: UIImage(named: "bg-addbutton-highlighted"), contentImage: UIImage(named: "icon-plus"), highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
    let menu = SquishyControl(frame: view.bounds, startItem: startItem, optionMenus: menus)
    
    view.addSubview(menu)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }  
}

