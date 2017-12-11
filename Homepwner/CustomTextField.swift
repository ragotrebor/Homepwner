//
//  CustomTextField.swift
//  Homepwner
//
//  Created by Roberto García on 10-12-17.
//  Copyright © 2017 Roberto García. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func becomeFirstResponder() -> Bool {
        self.borderStyle = .line
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.borderStyle = .roundedRect
        
        return super.resignFirstResponder()
    }

}
