//
//  PaddingTextField.swift
//  TV Shows
//
//  Created by Infinum on 18.07.2021..
//

import Foundation
import UIKit

@IBDesignable
class PaddingTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let width = 20
        let x = Int(bounds.width) - width - Int(inset)
        let rightViewBounds = CGRect(x: x, y: 0, width: width, height: width)
        return rightViewBounds
    }

}
