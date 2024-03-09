//
//  Array+Extension.swift
//  FalconX
//
//  Created by Ajaya Mati on 09/03/24.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}
