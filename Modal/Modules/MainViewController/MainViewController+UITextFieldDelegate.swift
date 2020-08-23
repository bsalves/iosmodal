//
//  MainViewController+UITextFieldDelegate.swift
//  Modal
//
//  Created by Bruno Alves on 21/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Transfor in search trigger
        
        textField.resignFirstResponder()
        if let newText = textField.text {
            var values = items.value
            values.append(newText)
            items.accept(values)
            textField.text = nil
        }
        return true
    }
}
