//
//  EUITextField.swift
//  FishDay
//
//  Created by Water Flower on 11/3/20.
//  Copyright © 2020 Anas Sherif. All rights reserved.
//

import Foundation

class EUITextField: UITextField {

    override var textInputContextIdentifier: String? {""}

    var languageCode:String?{
        didSet{
            if self.isFirstResponder{
                self.resignFirstResponder();
                self.becomeFirstResponder();
            }
        }
    }

    override var textInputMode: UITextInputMode?{
        
        if let language_code = self.languageCode{
            for keyboard in UITextInputMode.activeInputModes {
                if let language = keyboard.primaryLanguage {
                    let locale = Locale.init(identifier: language);
                    if locale.languageCode == language_code {
                        return keyboard;
                    }
                }
            }
        }
        return super.textInputMode;
    }
}
