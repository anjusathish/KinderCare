//
//  ArrayExtension.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 20/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
