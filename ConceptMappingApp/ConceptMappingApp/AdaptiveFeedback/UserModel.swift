//
//  UserModel.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 07/02/2023.
//

// To what extent can users contribute to the adaptive feedback process to improve cognitive behaviours in concept mapping?
// the learner model

import Foundation

struct UserModel {
    
    var knowledgeLevel: Int // low 0, mediocore 1, high 2
    var tfuOrEtrq: Int // 0 tfu, 1 etrq
    var crOrEr: Int // 0 cr, 1 er
    var exploratoryOrExplanatory: Int // 0 eploratory, 1 explanatory
    
    var numErrors: Int
    var numIncomplete: Int
    var numInaccurate: Int
    var numInaccurateSuperfluous: Int
    var numIncompleteInaccurate: Int
    var numCompleteAccurate: Int
    
    var numTimesCRUsed: Int
    
    var relationshipsAdded: [Date]
}


class UserProfile: ObservableObject {
    @Published var user_model = UserModel(knowledgeLevel: 1, tfuOrEtrq: 0, crOrEr: 1, exploratoryOrExplanatory: 1, numErrors: 0, numIncomplete: 0, numInaccurate: 0, numInaccurateSuperfluous: 0, numIncompleteInaccurate: 0, numCompleteAccurate: 0, numTimesCRUsed: 0, relationshipsAdded: [])
    
    func updateUserModel(user_m: UserModel) {
        user_model = user_m
    }
    
    func updateCategorisation(response: ResponseCategorisationValues) -> UserModel {
        if response == .InComplete {
            user_model.numIncomplete += 1
            user_model.numErrors += 1
        } else if response == .CompleteAccurate {
            user_model.numCompleteAccurate += 1
        } else if response == .InAccurateSuperfluous {
            user_model.numInaccurateSuperfluous += 1
            user_model.numErrors += 1
        } else if response == .InAccurate {
            user_model.numInaccurate += 1
            user_model.numErrors += 1
        } else if response == .InCompleteInAccurate {
            user_model.numIncompleteInaccurate += 1
            user_model.numErrors += 1
        }
        updateKnowledgeLevel()
        return user_model
    }
    
    func updateKnowledgeLevel() {
        // 78 expert concepts
        if user_model.numCompleteAccurate <= 10 {
            user_model.knowledgeLevel = 0
        } else if user_model.numCompleteAccurate < 15 && user_model.numCompleteAccurate > 10{
            user_model.knowledgeLevel = 1
        } else {
            user_model.knowledgeLevel = 2
        }
    }
}
