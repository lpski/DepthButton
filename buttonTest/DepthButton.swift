//
//  DepthButton.swift
//  buttonTest
//
//  Created by Luke Porupski on 7/22/16.
//  Copyright © 2016 Luke Porupski. All rights reserved.
//

import UIKit

class DepthButton: UIButton {
    
    private var originalX: Int?
    private var originalY: Int?
    private var primaryBackground: UIColor?
    
    @IBInspectable var rotateOnTouch: Bool = true
    @IBInspectable var rotationModifier: CGFloat = 45 // higher = larger transformation on touches
    
    @IBInspectable var scaleOnTouch: Bool = true
    @IBInspectable var scalePercentage: CGFloat = 0.95
    
    
    
    
    //@IBInspectable var touchAnimationEnabled: Bool = true
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        super.touchesBegan(touches, withEvent: event)
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInView(self)
        
        transformFromTouchLocation(touchLocation)
        
    }
    
    private func transformFromTouchLocation(location: CGPoint){
        
        //identity which will hold x & y axis shifts
        var identity = CATransform3DIdentity
        identity.m34 = 1.0 / -500
        
        
        //gets absolute value of offset of touch from center of button
        let absXOffset = abs(self.bounds.width / 2 - location.x)
        let absYOffset = abs(self.bounds.height / 2 - location.y)
        
        if(self.rotateOnTouch == true){
            
            //indicates percentage of specified maxShiftAngle to shift on x axis based on y offset
            let xDegreeModifier = absYOffset / self.bounds.height / 2
            let xTrans = CATransform3DRotate(identity, xDegreeModifier * self.rotationModifier * CGFloat(M_PI) / 180.0, location.y < self.bounds.height / 2 ? 1.0 : -1.0, 0, 0)
            
            
            //indicates percentage of specified maxShiftAngle to shift on y axis based on x offset
            let yDegreeModifier = absXOffset / self.bounds.width / 2
            let yTrans = CATransform3DRotate(identity, yDegreeModifier * self.rotationModifier * CGFloat(M_PI) / 180.0, 0, location.x > self.bounds.width / 2 ? 1.0 : -1.0, 0)
            
            //concats two rotate transforms
            identity = CATransform3DConcat(xTrans, yTrans)
        }
        
        if(self.scaleOnTouch == true){
            let scaleTrans = CATransform3DScale(identity, self.scalePercentage, self.scalePercentage, 1.0)
            identity = CATransform3DConcat(identity, scaleTrans)
        }
        
        
        self.layer.transform = identity
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        self.layer.transform = CATransform3DIdentity
        
    }
    

}

