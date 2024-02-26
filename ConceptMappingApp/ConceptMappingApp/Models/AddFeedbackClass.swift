//
//  AddFeedbackClass.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 05/01/2023.
//

import Foundation

class AddFeedback: ObservableObject {
    @Published var feedbackToAdd : Feedback = Feedback(title: "", feedback: "", image: "")
    @Published var currentLayer = 0
    @Published var showFeedback = false
    @Published var showErrors = false
    @Published var showAlert = true
    @Published var showPerformance = false
    @Published var relationAdded = 0
    @Published var savedUserModel: UserProfile = UserProfile()
    @Published var userInputChosen = false
   
    
    var user_response: ResponseCategorisationValues = .NotApplicable
    var saved_user_input: String = ""
    var saved_expert_concept: String = ""
    var saved_exp_concept: ExpertConcept = ExpertConcept(id: 346, concept: "", image: "", example: "", alternativeExample: "", keywords: "", relationships: [], linkedRelations: "", difficulty: 0, learningOutcome: "")
    
    var tfu_called: Bool = false
    
    
    func addFeedback(title: String, feedback: String, image: String) {
        feedbackToAdd = Feedback(title: title, feedback: feedback, image: image)
    }
    
    func saveUserModel(user_m: UserModel) {
        savedUserModel.user_model = user_m
    }
    
    func callNextLayer() {
        currentLayer += 1
        
        if currentLayer == 2 {
            SecondLayerPartTwo(response: user_response, expert_concept: saved_user_input, knowledge_level: savedUserModel.user_model.knowledgeLevel, user_input: saved_expert_concept, exp_concept: saved_exp_concept)
        } else if currentLayer == 1 {
            if user_response == .CompleteAccurate {
                currentLayer += 2
                ThirdLayer(response: user_response, expert_concept: saved_expert_concept, knowledge_level: savedUserModel.user_model.knowledgeLevel)
            } else {
                SecondLayer(response: user_response, user_input: saved_user_input, expert_concept: saved_expert_concept, knowledge_level: savedUserModel.user_model.knowledgeLevel, exp_concept: saved_exp_concept)
            }
        } else if currentLayer == 3 {
            ThirdLayer(response: user_response, expert_concept: saved_expert_concept, knowledge_level: savedUserModel.user_model.knowledgeLevel)
        } else if currentLayer == 4 {
            FourthLayer(response: user_response)
        } else {
            resetLayers()
        }
    }
    
    func resetLayers() {
        currentLayer = 0
    }
    
    func FirstLayer(response: ResponseCategorisationValues, user_input: String, expert_concept: String, exp_concept: ExpertConcept) {
        user_response = response
        saved_user_input = user_input
        saved_expert_concept = expert_concept
        saved_exp_concept = exp_concept
        
        var title: String
        var feedback_info: String
        
        // The first layer aims to enable learners to rethink their beliefs and to get into a self-explanation process
        if response == .CompleteAccurate {
            // BeliefPromptRethinkWrite
            let reflectiveFeedback = ReflectiveFeedback()
            let components = reflectiveFeedback.BeliefPromtRethinkWrite(learnerBelief: user_input)

            title = components.0
            feedback_info = components.1
            showFeedback = true
            addFeedback(title: title, feedback: feedback_info, image: "")
            
        } else {
            // BeliefPromptRe-thinkWrite
            let reflectiveFeedback = ReflectiveFeedback()
            let components = reflectiveFeedback.BeliefPromtRethinkWrite(learnerBelief: user_input)
            // CIR
            let informativeFeedback = InformativeFeedback()
            let correction = informativeFeedback.CorrectnessIncorrectnessOfResponse(userCategory: response)
            
            title = components.0
            feedback_info = correction + "\n" + components.1
            showFeedback = true
            addFeedback(title: title, feedback: feedback_info, image: "")
        }
    }
    
    func SecondLayer(response: ResponseCategorisationValues, user_input: String, expert_concept: String, knowledge_level: Int, exp_concept: ExpertConcept) {
        // MARK: Adaptive Component
        
        // ETRQ + TFU <-- given for low knowledge level
        
        // if threshold = 0, no influence (normal version runs)
        // if threshold == low, randomly choose with selected likelihood of being picked
        if knowledge_level == 0 {
            tfu_called = true
            let reflectiveFeedback = ReflectiveFeedback()
            let components = reflectiveFeedback.ErrorTaskRelatedQuestion(response: response, learnersBelief: user_input, expertBelief: expert_concept)
            
            let tutoringFeedback = TutoringFeedback()
            let feedbackUnit = tutoringFeedback.TFU1(userPreference: savedUserModel.user_model.exploratoryOrExplanatory, exp_concept: exp_concept)
            var feedback = feedbackUnit.0
            userInputChosen = feedbackUnit.1
            let possible_image = feedbackUnit.2
            var image_name = ""
            if possible_image {
                image_name = feedback
                feedback = ""
            }
            showFeedback = true
            addFeedback(title: feedback, feedback: components, image: image_name)
            
        } else {
            let reflectiveFeedback = ReflectiveFeedback()
            let components = reflectiveFeedback.ErrorTaskRelatedQuestion(response: response, learnersBelief: user_input, expertBelief: expert_concept)
        
            showFeedback = true
            addFeedback(title: "Feedback: ", feedback: components, image: "")
        }
    }
    
    func SecondLayerPartTwo(response: ResponseCategorisationValues, expert_concept: String, knowledge_level: Int, user_input: String, exp_concept: ExpertConcept) {
        // MARK: Adaptive Component

        let correctness = determineCorrect(response: response)
        if tfu_called == true && correctness != "correct" {
            let reflectiveFeedback = ReflectiveFeedback()
            let components = reflectiveFeedback.ErrorTaskRelatedQuestion(response: response, learnersBelief: user_input, expertBelief: expert_concept)
            
            let tutoringFeedback = TutoringFeedback()
            let feedbackUnit = tutoringFeedback.TFU2(userPreference: savedUserModel.user_model.exploratoryOrExplanatory, exp_concept: exp_concept, userDecision: userInputChosen)

            showFeedback = true
            addFeedback(title: feedbackUnit, feedback: components, image: "")
        } else {
            callNextLayer()
        }
    }
    
    func ThirdLayer(response: ResponseCategorisationValues, expert_concept: String, knowledge_level: Int) {
        // MARK: Adaptive Component
        // depends on user's knowledge level
        
        // CR + ER
        if response == .CompleteAccurate {
            let correctness = determineCorrect(response: response)
            
            let tutoring = TutoringFeedback()
            let explanation = tutoring.ExplanationOfResponse(correct: correctness, userResponse: response)
            
            showFeedback = true
            addFeedback(title: "Feedback: ", feedback: explanation, image: "")
        
        } else if knowledge_level == 1 {
            savedUserModel.user_model.numTimesCRUsed += 1
            let informativeFeedback = InformativeFeedback()
            let correctResponse = informativeFeedback.CorrectResponse(response: response, expertConcept: expert_concept)
            
            showFeedback = true
            addFeedback(title: "Feedback: ", feedback: correctResponse, image: "")
        } else {
            savedUserModel.user_model.numTimesCRUsed += 1
            let correctness = determineCorrect(response: response)
            
            let informativeFeedback = InformativeFeedback()
            let correctResponse = informativeFeedback.CorrectResponse(response: response, expertConcept: expert_concept)
            
            let tutoring = TutoringFeedback()
            let explanation = tutoring.ExplanationOfResponse(correct: correctness, userResponse: response)
            
            showFeedback = true
            addFeedback(title: correctResponse, feedback: explanation, image: "")
        }
    }
    
    func FourthLayer(response: ResponseCategorisationValues) {
        resetLayers()
        showPerformance = true
    }
    
    func determineCorrect(response: ResponseCategorisationValues) -> String {
        if response == .CompleteAccurate {
            return "correct"
        } else {
            return "incorrect"
        }
    }
}

