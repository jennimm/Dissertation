//
//  InformativeFeedback.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 07/02/2023.
//

import Foundation

struct InformativeFeedback {
    
    func CorrectnessIncorrectnessOfResponse(userCategory: ResponseCategorisationValues) -> String {
        // MARK: Informs the user if the answer is correct or incorrect
        let correctTitle = "Your answer is correct. "
        let incorrectTitle = "Your answer is incorrect. "
        
        if userCategory == .CompleteAccurate {
            return correctTitle
        } else {
            return incorrectTitle
        }
    }
    
    func CorrectResponse(response: ResponseCategorisationValues, expertConcept: String) -> String {
        let answer = "The correct answer is: "
        return answer + expertConcept
    }
}
