//
//  UIView+AutoLayout.swift
//
//  Created by Nghia Nguyen on 5/26/15.
//

import UIKit

extension UIView {
    //MARK: set width and height
    func nk_widthConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: multiplier, constant: constant)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_heightConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: multiplier, constant: constant)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_widthConstraint(width: CGFloat, relation: NSLayoutRelation = .Equal) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: width)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_heightConstraint(height: CGFloat, relation: NSLayoutRelation = .Equal) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: height)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    //MARK: set constraints
    
    func nk_centerXConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_centerYConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignTopConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignBottomConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignTrailingConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignLeadingConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    //MARK: pin constraints
    
    func nk_pinTopConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinBottomConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinLeadingConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinTrailingConstraintView(var view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
}