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
        textField.resignFirstResponder()
        return true
    }
}
