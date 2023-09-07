//
//  Collection+Extension.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index]
        }
    }
}

extension MutableCollection where Self: RangeReplaceableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index]
        }
        set {
            guard indices.contains(index), let newValue = newValue else { return }
            self[index] = newValue
        }
    }
}
