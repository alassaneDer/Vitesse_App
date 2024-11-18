//
//  ToastUtility.swift
//  Vitesse
//
//  Created by Alassane Der on 08/09/2024.
//

import Foundation

class ToastUtility {
    func showTemporaryToast(after delay: TimeInterval, _ completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
}
