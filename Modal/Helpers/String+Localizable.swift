//
//  String+Localizable.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import Foundation

extension String {
    static func localize(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
