//
//  TutoringFeedback.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 07/02/2023.
//

import Foundation

struct TutoringFeedback {
    func ExplanationOfResponse(correct: String, userResponse: ResponseCategorisationValues) -> String {
        var explanation = ""
        var reason = ""
        
        if correct == "correct" {
            explanation = "Your concept is correct because you have explained the concept correctly and in the right context. Also, you have used the correct key words and technical language."
            // included all key words, correct context, all relationships included
        } else {
            // missing relationship, missing keywords, incorrect context
            if userResponse == .InComplete {
                reason = "you are missing some of the keywords in the concept."
            } else if userResponse == .InAccurate {
                reason = "you are using some keywords in the wrong context."
            } else if userResponse == .InCompleteInAccurate {
                reason = "you are missing some of the keywords and inaccurately using other keywords."
            } else {
                reason = "it is not clear what your concept means."
            }
            explanation = "Your concept is incorrect because " + reason
        }
        return explanation
    }
    
    func TFU1(userPreference: Int, exp_concept: ExpertConcept) -> (String, Bool, Bool) {
        var teachingUnitChosen = 0
        var userInputChosen = false
        // MARK: determine if user input decides which TFU unit is chosen
        let rule_to_use = DetermineRuleImportance().getRuleToUse()
        
        if rule_to_use == 0 {
            // MARK: determine if specific knowledge module is used
            userInputChosen = true
            if userPreference == 0 {
                // exploratory
                teachingUnitChosen = Int.random(in: 0..<2)
            } else {
                // explanatory
                teachingUnitChosen = Int.random(in: 2..<4)
            }
        } else {
            // randomly select a tfu unit
            teachingUnitChosen = Int.random(in: 0..<4)
        }
        
        // MARK: explanatory
        // def concept shown, all keywords, show in context to other relationships
        
        if teachingUnitChosen == 0 {
            // expert concept
            var expert = exp_concept.concept // 0
            expert = "The expert concept is: '" + expert + "'."
            return (expert, userInputChosen, false)
        } else if teachingUnitChosen == 1 {
            // expand on keywords
            var keywords = exp_concept.keywords // 1
            keywords = "Some of the concept keywords include: " + keywords
            return (keywords, userInputChosen, false)
        }
        
        // MARK: exploratory
        // image, example, similar concept/ problem
        
        // show image
        else if teachingUnitChosen == 2 {
            let image = exp_concept.image // 2
            return (image, userInputChosen, true)
        } else {
            // alternative answer
            var alternative = exp_concept.alternativeExample // 3
            alternative = "Another way of phrasing the concept is: '" + alternative + "'."
            return (alternative, userInputChosen, false)
        }
    }
    
    func TFU2(userPreference: Int, exp_concept: ExpertConcept, userDecision: Bool) -> String {
        // if userInput was used in previous TFU, also use here
        if userDecision {
            if userPreference == 1 {
                // MARK: explanatory
                let response = "Some related concepts are: " + exp_concept.linkedRelations
                return response
                
                
            } else {
                // MARK: exploratory
                let response = "An example of the concept is: " + exp_concept.example
                return response
            }
        } else {
            let teachingUnitChosen = Int.random(in: 0..<2)
            if teachingUnitChosen == 0 {
                let response = "An example of the concept is: " + exp_concept.example
                return response
            }
            let response = "Some related concepts are: " + exp_concept.linkedRelations
            return response
        }
    }
}
