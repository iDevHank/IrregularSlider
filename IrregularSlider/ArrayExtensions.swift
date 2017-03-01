//
//  ArrayExtensions.swift
//  IrregularSlider
//
//  Created by Hank on 28/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    internal func indexOfLeftPointInAscendingArray(for value: Element) -> Int {
        for (i, element) in zip(indices, self) {
            if value > element {
                continue
            } else {
                return index(before: i)
            }
        }
        return -1
    }
}
