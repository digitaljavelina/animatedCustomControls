//
//  SquishyControl.swift
//  Squish
//
//  Created by mike on 4/29/15.
//  Copyright (c) 2015 Dangerous Kittens. All rights reserved.
//

import UIKit

protocol SquishyControlDelegate {
  func squishyControlSelected(menu: SquishyControl, didSelectIndex idx: Int)
}

public class SquishyControl: UIView {
    
    var timer: NSTimer?
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    backgroundColor = UIColor.whiteColor()
  }
  
  convenience init(frame: CGRect!, startItem: SquishyControlItem?, optionMenus aMenusArray:[SquishyControlItem]?) {
    self.init(frame: frame)
    
    backgroundColor = UIColor.whiteColor()
    
    menuWholeAngle = CGFloat(M_PI * 2.0)
    startPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2)
    expandRotation = -CGFloat(M_PI * 2)
    closeRotation = CGFloat(M_PI * 2)
    animationDuration = 0.5
    expandRotateAnimationDuration = 2.0
    closeRotateAnimationDuration = 1.0
    startMenuAnimationDuration = 0.2
    rotateAddButton = true
    
    nearRadius = 100.0
    endRadius = 120
    farRadius = 140
    
    menusArray = aMenusArray!
    
    motionState = State.Close
    
    startButton = startItem!
    startButton.center = startPoint
    addSubview(startButton)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    addGestureRecognizer(tapRecognizer)
    
    startButton.delegate = self
  }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        handleTap()
    }
  
  enum State {
    case Close            // Intial state
    case Expand
  }
  
  var delegate: SquishyControlDelegate!
  
  var menuWholeAngle: CGFloat!
  var expandRotation: CGFloat!
  var closeRotation: CGFloat!
  var animationDuration: CGFloat!
  var expandRotateAnimationDuration: CGFloat!
  var closeRotateAnimationDuration: CGFloat!
  var startMenuAnimationDuration: CGFloat!
  var rotateAddButton: Bool!
  
  var nearRadius: CGFloat!
  var endRadius: CGFloat!
  var farRadius: CGFloat!
  
  var motionState: State?
  
  var _menusArray: [SquishyControlItem] = []
  
  var menusArray = [SquishyControlItem]() {
    didSet {
      for view in subviews {
        if view.tag >= 1000 {
          view.removeFromSuperview()
        }
      }
    }
  }
  
  var startPoint: CGPoint = CGPointZero {
    didSet {
      startButton.center = startPoint
    }
  }
  
  var _startButton: SquishyControlItem = SquishyControlItem(frame: CGRectZero)
  
  var startButton: SquishyControlItem {
    get {
      return _startButton
    }
    set {
      _startButton = newValue
    }
  }
    
    public func handleTap() {
        var state = motionState!
        var degreesPerRadians: CGFloat = 57.3
        var selector: Selector?
        
        var angle: CGFloat = 225.0
        
        switch state {
            case .Close:
            motionState = State.Expand
            angle = angle/degreesPerRadians
            selector = "expand"
            
        case .Expand:
            motionState = State.Close
            angle = 0.0
            selector = "close"
        }
        
        if let rotateAddButton = rotateAddButton {
            UIView.animateWithDuration(Double(startMenuAnimationDuration!), animations: { () -> Void in
                self.startButton.transform = CGAffineTransformMakeRotation(angle)
            })
        }
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: selector!, userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    public func setMenu() {
        let count: Int = menusArray.count
        var denominator: Int?
        
        for (index, value) in enumerate(menusArray) {
            var item = menusArray[index]
            item.tag = 1000 + index
            item.startPoint = startPoint
            
            //avoid overlap
            if (menuWholeAngle >= CGFloat(M_PI) * 2) {
                menuWholeAngle = menuWholeAngle! - menuWholeAngle! / CGFloat(count)
            }
            
            if count == 1 {
                denominator = 1
            } else {
                denominator = count - 1
            }
            
            let temp1 = sinf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let temp2 = cosf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            
            //the final resting place
            let i1 = Float(endRadius) * temp1
            let i2 = Float(endRadius) * temp2
            item.endPoint = CGPoint(x: startPoint.x + CGFloat(i1), y: startPoint.y - CGFloat(i2))
            
            //the nearest part of the bounce to the center
            let j1 = Float(nearRadius) * temp1
            let j2 = Float(nearRadius) * temp2
            item.nearPoint = CGPoint(x: startPoint.x + CGFloat(j1), y: startPoint.y - CGFloat(j2))
            
            //the furthest point of the bounce from the center
            let k1 = Float(farRadius) * temp1
            let k2 = Float(farRadius) * temp2
            item.farPoint = CGPoint(x: startPoint.x + CGFloat(k1), y: startPoint.y - CGFloat(k2))
            
            item.center = item.startPoint!
            item.delegate = self
            
            insertSubview(item, belowSubview: startButton)
        }
    }
}

extension SquishyControl: SquishyControlItemDelegate {
    public func SquishyControlItemTouchesBegan(item: SquishyControlItem) {
        if item == startButton {
            handleTap()
        }
    }
    
    public func SquishyControlItemTouchesEnd(item: SquishyControlItem) {
        if item == startButton {
            return
        }
    }
}
