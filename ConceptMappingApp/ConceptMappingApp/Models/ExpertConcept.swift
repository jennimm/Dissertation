//
//  ExpertConcept.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 21/02/2023.
//

import Foundation

struct ExpertConcept {
    var id: Int
    var concept: String
    var image: String
    var example: String
    var alternativeExample: String
    var keywords: String
    var relationships: [[Int]]
    var linkedRelations: String
    
    var difficulty: Int
    var learningOutcome: String
}
