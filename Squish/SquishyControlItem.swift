//
//  SquishyControlItem.swift
//  Squish
//
//  Created by mike on 4/29/15.
//  Copyright (c) 2015 Dangerous Kittens. All rights reserved.
//

import UIKit

protocol SquishyControlItemDelegate {
  func SquishyControlItemTouchesBegan(item: SquishyControlItem)
  func SquishyControlItemTouchesEnd(item:SquishyControlItem)
}

public class SquishyControlItem: UIView {
  
  var contentImageView: UIImageView?
  var backgroundImageView: UIImageView?
  var startPoint: CGPoint?
  var endPoint: CGPoint?
  var nearPoint: CGPoint?
  var farPoint: CGPoint?
  var isHighlighted: Bool!
  var delegate: SquishyControlItemDelegate!
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
  }
 
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  convenience init(backgroundImage bimage:UIImage!, highlightedImage himage:UIImage?, contentImage cimage:UIImage?, highlightedContentImage hcimage:UIImage?) {
    
    self.init(frame: CGRectZero)
    userInteractionEnabled = true
    backgroundImageView = UIImageView(image: bimage)
    backgroundImageView?.highlightedImage = himage
    contentImageView = UIImageView(image: cimage)
    contentImageView?.highlightedImage = hcimage
    
    bounds=CGRect(x: 0, y: 0, width: bimage.size.width, height: bimage.size.height);
    
    if let imageView = contentImageView {
      let width = imageView.image?.size.width
      let height = imageView.image?.size.height
      
      imageView.frame = CGRect(x: (bounds.size.width/2 - width!/2),y: (bounds.size.height/2 - height!/2),width: width!, height: height!)
    }
    
    backgroundImageView!.addSubview(contentImageView!)
    self.addSubview(backgroundImageView!)
  }
}
