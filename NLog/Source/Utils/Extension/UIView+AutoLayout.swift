//
//  UIView+AutoLayout.swift
//
//  Created by Nghia Nguyen on 5/26/15.
//

import UIKit

extension UIView {
    //MARK: set width and height
    func nk_widthConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: multiplier, constant: constant)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_heightConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: multiplier, constant: constant)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_widthConstraint(_ width: CGFloat, relation: NSLayoutRelation = .equal) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 0, constant: width)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_heightConstraint(_ height: CGFloat, relation: NSLayoutRelation = .equal) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 0, constant: height)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    //MARK: set constraints
    
    func nk_centerXConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_centerYConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignTopConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignBottomConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignTrailingConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_alignLeadingConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    //MARK: pin constraints
    
    func nk_pinTopConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinBottomConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinLeadingConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
    
    func nk_pinTrailingConstraintView( _ view: UIView? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0) -> UIView {
        var view = view
        
        if view == nil {
            guard let superview = self.superview else {
                return self
            }
            
            view = superview
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant: offset)
        
        self.superview?.addConstraint(constraint)
        
        return self
    }
}
