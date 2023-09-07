//
//  GameViewModel.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation

class GameViewModel {
    // MARK: - Constants
    let totalDestinationCount: Int = 4
    
    // MARK: - Properties
    var selectedIndex = 0
    
    // MARK: - Dependencies
    private let sessionService: SessionService
    
    // MARK: - Initializer
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
}

extension GameViewModel {
    func hasNext() -> Bool {
        return selectedIndex < totalDestinationCount - 1
    }
    
    func hasPrev() -> Bool {
        return selectedIndex > 0
    }
    
    func moveToNext() {
        guard hasNext() else { return }
        selectedIndex += 1
    }
    
    func moveToPrev() {
        guard hasPrev() else { return }
        selectedIndex -= 1
    }
    
    func didFinish() {}
}
