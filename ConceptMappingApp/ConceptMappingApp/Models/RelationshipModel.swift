//
//  RelationshipModel.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 06/12/2022.
//

import Foundation

struct Relationship: Identifiable, Hashable, Codable {
    var id = UUID()
    var pair: [Int]
    var isSelected: Bool
    var label: String
    
    init(pair: [Int], isSelected: Bool, label: String) {
        self.pair = pair
        self.isSelected = isSelected
        self.label = label
    }
}
