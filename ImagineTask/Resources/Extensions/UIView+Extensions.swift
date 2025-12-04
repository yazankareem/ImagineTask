//
//  UIView+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

extension UIView {
    
    struct Constraints {
        var topAnchor:      NSLayoutConstraint?
        var leadingAnchor:  NSLayoutConstraint?
        var bottomAnchor:   NSLayoutConstraint?
        var trailingAnchor: NSLayoutConstraint?
        var widthAnchor:    NSLayoutConstraint?
        var heightAnchor:   NSLayoutConstraint?
        var centerXAnchor:  NSLayoutConstraint?
        var centerYAnchor:  NSLayoutConstraint?
        
        init() {
            topAnchor      = nil
            leadingAnchor  = nil
            bottomAnchor   = nil
            trailingAnchor = nil
            widthAnchor    = nil
            heightAnchor   = nil
            centerXAnchor  = nil
            centerYAnchor  = nil
        }
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var _topAnchor: NSLayoutConstraint?
        var _leadingAnchor: NSLayoutConstraint?
        var _bottomAnchor: NSLayoutConstraint?
        var _trailingAnchor: NSLayoutConstraint?
        var _widthAnchor: NSLayoutConstraint?
        var _heightAnchor: NSLayoutConstraint?
        var _centerXAnchor: NSLayoutConstraint?
        var _centerYAnchor: NSLayoutConstraint?
        var anchorsArr = [NSLayoutConstraint]()
        
        if let top = top {
            _topAnchor = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchorsArr.append(_topAnchor!)
        }
        
        if let leading = leading {
            _leadingAnchor = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchorsArr.append(_leadingAnchor!)
        }
        
        if let bottom = bottom {
            _bottomAnchor = bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom)
            anchorsArr.append(_bottomAnchor!)
        }
        
        if let trailing = trailing {
            _trailingAnchor = trailingAnchor.constraint(equalTo: trailing, constant: padding.right)
            anchorsArr.append(_trailingAnchor!)
        }
        
        if let centerX = centerX {
            _centerXAnchor = centerXAnchor.constraint(equalTo: centerX, constant: 0)
            anchorsArr.append(_centerXAnchor!)
        }
        
        if let centerY = centerY {
            _centerYAnchor = centerYAnchor.constraint(equalTo: centerY, constant: 0)
            anchorsArr.append(_centerYAnchor!)
        }
        
        if size.width != 0 {
            _widthAnchor = widthAnchor.constraint(equalToConstant: size.width)
            anchorsArr.append(_widthAnchor!)
        }
        
        if size.height != 0 {
            _heightAnchor = heightAnchor.constraint(equalToConstant: size.height)
            anchorsArr.append(_heightAnchor!)
        }
        
        NSLayoutConstraint.activate(anchorsArr)
    }
    
    func anchorStored(top: NSLayoutYAxisAnchor?,
                      leading: NSLayoutXAxisAnchor?,
                      bottom: NSLayoutYAxisAnchor?,
                      trailing: NSLayoutXAxisAnchor?,
                      centerX: NSLayoutXAxisAnchor? = nil,
                      centerY: NSLayoutYAxisAnchor? = nil,
                      padding: UIEdgeInsets = .zero,
                      size: CGSize = .zero) -> Constraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = Constraints()
        var anchorsArr = [NSLayoutConstraint]()
        
        if let top = top {
            constraints.topAnchor = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchorsArr.append(constraints.topAnchor!)
        }
        
        if let leading = leading {
            constraints.leadingAnchor = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchorsArr.append(constraints.leadingAnchor!)
        }
        
        if let bottom = bottom {
            constraints.bottomAnchor = bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom)
            anchorsArr.append(constraints.bottomAnchor!)
        }
        
        if let trailing = trailing {
            constraints.trailingAnchor = trailingAnchor.constraint(equalTo: trailing, constant: padding.right)
            anchorsArr.append(constraints.trailingAnchor!)
        }
        
        if let centerX = centerX {
            constraints.centerXAnchor = centerXAnchor.constraint(equalTo: centerX, constant: 0)
            anchorsArr.append(constraints.centerXAnchor!)
        }
        
        if let centerY = centerY {
            constraints.centerYAnchor = centerYAnchor.constraint(equalTo: centerY, constant: 0)
            anchorsArr.append(constraints.centerYAnchor!)
        }
        
        if size.width != 0 {
            constraints.widthAnchor = widthAnchor.constraint(equalToConstant: size.width)
            anchorsArr.append(constraints.widthAnchor!)
        }
        
        if size.height != 0 {
            constraints.heightAnchor = heightAnchor.constraint(equalToConstant: size.height)
            anchorsArr.append(constraints.heightAnchor!)
        }
        
        NSLayoutConstraint.activate(anchorsArr)
        return constraints
    }
    
    func anchorSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorToFill(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = self.topAnchor.constraint(equalTo: view.topAnchor)
        let leadingAnchor = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let bottomAnchor = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailingAnchor = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([topAnchor, leadingAnchor, bottomAnchor, trailingAnchor])
    }
    
    func addSubViewAtCenter(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
