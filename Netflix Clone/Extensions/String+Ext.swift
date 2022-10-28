//
//  String+Ext.swift
//  Netflix Clone
//
//  Created by mac on 26/10/22.
//

import Foundation

extension String {
    func captilizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
