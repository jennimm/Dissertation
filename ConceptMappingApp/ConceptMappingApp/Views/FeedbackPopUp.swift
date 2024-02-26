//
//  FeedbackPopUp.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 05/01/2023.
//

import SwiftUI

struct FeedbackPopUp: View {
    @State private var okClicked = false
    @State private var noClicked = false
    @State private var keywords = ""
    
    @StateObject var feedback: AddFeedback
    @State var width: Double
    @State var height: Double
    
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geom in
                VStack {
                    HStack {
                        Text(feedback.feedbackToAdd.title)
                            .foregroundColor(Color("concept-blue"))
                            .font(.system(size: 16))
                            .padding(.leading, 10)
                            .lineLimit(nil)
                            .bold()
                        Spacer()
                        Image(systemName: "star.bubble")
                            .padding(.trailing)
                    }
                    Text(feedback.feedbackToAdd.feedback)
                        .foregroundColor(Color("concept-blue"))
                        .font(.system(size: 13))
                        .lineLimit(nil)
                        .padding(.leading, 5)
                    
                    if feedback.feedbackToAdd.image != "" {
                        Image(feedback.feedbackToAdd.image)
                            .resizable()
                            .frame(width: 300, height: 200)
                    }
                    HStack {
                        Spacer()
                        if feedback.currentLayer != 3 {
                            Button(action: {
                                okClicked = false
                                feedback.showFeedback = false
                                feedback.resetLayers()
                            }, label: {
                                Text("No")
                                    .foregroundColor(Color("concept-blue"))
                                    .bold(noClicked ? true : false)
                                    .frame(width: 80, height: 15)
                            })
                            .padding()
                            .border(Color("concept-dark-blue"), width: 2)
                            .background(Color("concept-light-blue"))
                        }
                        
                        Button(action: {
                            feedback.showFeedback = false
                            okClicked = okClicked ? false : true
                            noClicked = false
                            feedback.callNextLayer()
                        }, label: {
                            if feedback.currentLayer != 3 {
                                Text("Yes")
                                    .foregroundColor(Color("concept-blue"))
                                    .bold(okClicked ? true : false)
                                    .frame(width: 80, height: 15)
                            } else {
                                Text("Okay")
                                    .foregroundColor(Color("concept-blue"))
                                    .bold(okClicked ? true : false)
                                    .frame(width: 80, height: 15)
                            }
                            
                        })
                        .padding()
                        .border(Color("concept-dark-blue"), width: 2)
                        .background(Color("concept-light-blue"))
                        Spacer()
                    }
                }
                .frame(width: width, height: height)
                .background(Color("concept-light-pink"))
                .border(Color("concept-dark-blue"), width: 2)
            }
        }
    }
}

struct FeedbackPopUp_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackPopUp(feedback: AddFeedback(), width: 200, height: 500)
    }
}
