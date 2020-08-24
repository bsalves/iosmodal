//
//  MainNavigationController.swift
//  Modal
//
//  Created by Bruno Alves on 19/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        self.setViewControllers([initialViewController], animated: false)
    }
}
