//
//  PerformanceFeedback.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 05/03/2023.
//

import SwiftUI

struct PerformanceFeedback: View {
    @State var userModel: UserProfile
    @State var feedback: AddFeedback
    
    @State var knowledgeLevel = "Low"
    @State var tfuType = "Images & examples"
    @State var tfuOrEtrqValue = "Hints & questions"
    @State var crOrErValue = "Explanations"
    
    var knowledge = ["Low", "Mediocore", "High"]
    var tfuTypes = ["Images & examples", "Definitions & keywords"]
    var tfuOrEtrq = ["Hints & questions", "Reviewing material"]
    var crOrEr = ["Explanations", "Correct/ incorrect"]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Please fill out your preferences below.")
            HStack {
                Text("Knowledge Level: ")
                Picker("Knowledge Level: ", selection: $knowledgeLevel) {
                    ForEach(knowledge, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
            }
            Group {
                Text("When learning, do you prefer images and examples or definitions and keywords?")
                Picker("", selection: $tfuType) {
                    ForEach(tfuTypes, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                Text("Do you prefer hints and questions for guidance, or reviewing learning material?")
                Picker("", selection: $tfuOrEtrqValue) {
                    ForEach(tfuOrEtrq, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                Text("When you have gone wrong, do you prefer \n explanations as to why you went wrong \n or do you just want to know if you are correct?")
                    .scaledToFill()
                Picker("", selection: $crOrErValue) {
                    ForEach(crOrEr, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
            }
            Button(action: {
                feedback.showAlert = false
                var int_knowledge = 0
                if knowledgeLevel == "Low" {
                    int_knowledge = 0
                } else if knowledgeLevel == "Mediocore" {
                    int_knowledge = 1
                } else {
                    int_knowledge = 2
                }
                
                var int_tfuType = 0
                if tfuType == "Exploratory" {
                    int_tfuType = 0
                } else {
                    int_tfuType = 1
                }
                
                var int_tfuOrEtrq = 0
                if tfuOrEtrqValue == "Hints & questions" {
                    int_tfuOrEtrq = 0
                } else {
                    int_tfuOrEtrq = 1
                }
                
                var int_crOrErValue = 0
                if crOrErValue == "Explanations" {
                    int_crOrErValue = 1
                } else {
                    int_crOrErValue = 0
                }
                
                let user_model = UserModel(knowledgeLevel: int_knowledge, tfuOrEtrq: int_tfuOrEtrq, crOrEr: int_crOrErValue, exploratoryOrExplanatory: int_tfuType, numErrors: 0, numIncomplete: 0, numInaccurate: 0, numInaccurateSuperfluous: 0, numIncompleteInaccurate: 0, numCompleteAccurate: 0, numTimesCRUsed: 0, relationshipsAdded: [])
                
                userModel.updateUserModel(user_m: user_model)
                feedback.saveUserModel(user_m: user_model)
            }) {
                Text("Done")
                    .padding()
            }
            Spacer()
        }
        .multilineTextAlignment(.center)
        .background(Color("concept-light-blue"))
    }
}

struct PerformanceFeedback_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceFeedback(userModel: UserProfile(), feedback: AddFeedback())
    }
}
