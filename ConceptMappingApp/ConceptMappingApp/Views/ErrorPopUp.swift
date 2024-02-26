//
//  ErrorPopUp.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 08/03/2023.
//

import SwiftUI

struct ErrorPopUp: View {
    @StateObject var feedback: AddFeedback
    @State var width: Double
    @State var height: Double
    
    var body: some View {

        VStack {
            VStack {
                Text("You have made a total of " + String(feedback.savedUserModel.user_model.numErrors) + " errors.")
                
                Text("You have made: " + String(feedback.savedUserModel.user_model.numInaccurate) + " inaccurate errors.")
                Text("You have made: " + String(feedback.savedUserModel.user_model.numIncomplete) + " incomplete errors.")
                Text("You have made: " + String(feedback.savedUserModel.user_model.numIncompleteInaccurate) + " incomplete and inaccurate errors.")
                Text("You have made: " + String(feedback.savedUserModel.user_model.numInaccurateSuperfluous) + " super inaccurate errors.")
                
                Text("You have made: " + String(feedback.savedUserModel.user_model.numCompleteAccurate) + " correct concepts.")
                Button(action: {
                    feedback.showErrors = false
                }) {
                    Text("Done")
                        .padding()
                }
            }
            .frame(width: width, height: height * 1.2)
            .background(Color("concept-yellow"))
            .border(Color("concept-dark-blue"), width: 2)
            .multilineTextAlignment(.center)
            
        }
    }
}

struct ErrorPopUp_Previews: PreviewProvider {
    static var previews: some View {
        ErrorPopUp(feedback: AddFeedback(), width: 200, height: 300)
    }
}
