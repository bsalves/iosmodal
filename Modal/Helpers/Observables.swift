//
//  Observables.swift
//  Modal
//
//  Created by Bruno Alves on 20/08/20.
//  Copyright © 2020 Bruno Alves. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Observables {
    class func keyboardHeight() -> Observable<CGFloat> {
        return Observable
                .from([
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                        .map { notification -> CGFloat in
                            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                        },
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                        .map { _ -> CGFloat in
                            0
                        }
                ])
                .merge()
    }
}
