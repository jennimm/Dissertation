//
//  DataNavigationPathModel.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 09/03/2023.
//

import Foundation

struct NavigationPath {
    var startTime: Date = Date.now
    var nodesAdded: [Date] = []
    var pageChanges: [Int] = []
    var timeChanges: [Date] = []
    
    mutating func updateNode() -> [Date] {
        nodesAdded.append(Date.now)
        return nodesAdded
    }
}

