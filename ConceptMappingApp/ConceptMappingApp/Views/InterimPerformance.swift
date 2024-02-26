//
//  InterimPerformance.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 08/03/2023.
//

import SwiftUI

struct InterimPerformance: View {
    @StateObject var feedback: AddFeedback
    @State var width: Double
    @State var height: Double
    
    @State var knowledgeLevel = "Low"
    @State var tfuType = "Images & examples"
    @State var tfuOrEtrqValue = "Hints & questions"
    @State var crOrErValue = "Explanations"
    
    var knowledge = ["Low", "Mediocore", "High"]
    var tfuTypes = ["Images & examples", "Definitions & keywords"]
    var tfuOrEtrq = ["Hints & questions", "Reviewing material"]
    var crOrEr = ["Explanations", "Correct/ incorrect"]
    
    var body: some View {
        ScrollView {
            VStack {
                if feedback.user_response == .CompleteAccurate {
                    Text("You have learned the concept: ")
                    Text(feedback.saved_expert_concept)
                        .lineLimit(nil)
                        .foregroundColor(Color("concept-dark-pink"))
                        .frame(width: width * 0.9, height: 50)
                }
                Text("You have been corrected " + String(feedback.savedUserModel.user_model.numTimesCRUsed) + " times, ")
                Text("with a total of " + String(feedback.savedUserModel.user_model.numErrors) + " errors made.")
                
                
                Group {
                    Text("When learning, do you prefer images and")
                    Text("examples or definitions and keywords?")
                    Picker("", selection: $tfuType) {
                        ForEach(tfuTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Group {
                    Text("Do you prefer hints and questions for ")
                    Text("guidance, or reviewing learning material?")
                    Picker("", selection: $tfuOrEtrqValue) {
                        ForEach(tfuOrEtrq, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Group {
                    Text("When you have gone wrong, do you prefer")
                    Text("explanations as to why you went wrong or ")
                    Text("do you just want to know if you are correct?")
                    Picker("", selection: $crOrErValue) {
                        ForEach(crOrEr, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Button(action: {
                    feedback.showPerformance = false
                    
                    var int_tfuType = 0
                    if tfuType == "Exploratory" {
                        int_tfuType = 0
                    } else {
                        int_tfuType = 1
                    }
                    feedback.savedUserModel.user_model.exploratoryOrExplanatory = int_tfuType
                    
                    var int_tfuOrEtrq = 0
                    if tfuOrEtrqValue == "Hints & questions" {
                        int_tfuOrEtrq = 0
                    } else {
                        int_tfuOrEtrq = 1
                    }
                    feedback.savedUserModel.user_model.tfuOrEtrq = int_tfuOrEtrq
                    
                    var int_crOrErValue = 0
                    if crOrErValue == "Explanations" {
                        int_crOrErValue = 1
                    } else {
                        int_crOrErValue = 0
                    }
                    feedback.savedUserModel.user_model.crOrEr = int_crOrErValue
                    
                }) {
                    Text("Done")
                        .padding()
                }
            }
            .frame(width: width, height: height * 1.25)
            .background(Color("concept-light-pink"))
            .border(Color("concept-dark-blue"), width: 2)
            .multilineTextAlignment(.center)
        }
    }
}

struct InterimPerformance_Previews: PreviewProvider {
    static var previews: some View {
        InterimPerformance(feedback: AddFeedback(), width: 200, height: 300)
    }
}
