//
//  String+Validations.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
}
