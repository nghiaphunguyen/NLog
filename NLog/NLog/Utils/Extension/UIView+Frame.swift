//
//  UIView+Frame.swift
//
//  Created by Nghia Nguyen on 6/11/15.
//  Copyright (c) 2015 knacker. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRectMake(newValue, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, newValue, self.frame.size.width, self.frame.size.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.size.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newValue)
        }
    }
    
    // MARK: Associate with other view
    func alignTopView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.y = view.y + view.height + offset
        return self
    }
    
    func alignLeadingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.x = view.x + view.width + offset
        return self
    }
    
    func alignTrailingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.x = view.x - self.width + offset
        return self
    }
    
    func alignBottomView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.y = view.y - self.height + offset
        return self
    }
    
    func centerVerticalView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPointMake(self.center.x, view.center.y + offset)
        return self
    }
    
    func centerHorizontalView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPointMake(view.center.x + offset, self.center.y)
        return self
    }
    
    // MARK: Pin with parent
    func pinTopView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.y = view.y + offset

        return self
    }
    
    func pinBottomView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.y = view.y + view.height - self.height + offset
        
        return self
    }
    
    func pinLeadingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.x = view.x + offset
        
        return self
    }
    
    func pinTrailingView(view: UIView, offset: CGFloat = 0) -> UIView {
        self.x = view.x + view.width - self.width + offset
        
        return self
    }
}
