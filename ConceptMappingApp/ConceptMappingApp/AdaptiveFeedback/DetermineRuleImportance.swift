//
//  ThresholdRuleImportance.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 03/03/2023.
//

import Foundation

class DetermineRuleImportance: ObservableObject {
    let userThreshold = 60.0
    
    func getRuleToUse() -> Int {
        // rule A = 0
        // rule B = 1
        let random_value = Double.random(in: 0.0...100.0)
        
        if random_value <= userThreshold {
            return 0
        }
        return 1
    }
}
