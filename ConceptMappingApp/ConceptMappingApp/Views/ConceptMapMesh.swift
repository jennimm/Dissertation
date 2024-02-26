//
//  ConceptMapMesh.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 18/11/2022.
//

import SwiftUI

struct ConceptMapMesh: View {
    @State var width: Double
    @State var height: Double
    @State var maxW: Double = 500
    @State var maxH: Double = 1000
    @State var minW: Double = 0
    @State var minH: Double = 0
    @State private var contentSize: CGSize = .zero
    @StateObject var concepts : AddNode
    @StateObject var feedback: AddFeedback
    @State private var presentAlert = false
    
    @State private var scale = 0.8
    @State private var lastScale = 0.6
    @State private var deltaChange = 0.0
    private let minScale = 0.3
    private let maxScale = 1.2
    var newXLocation : Double = 0
    
    var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                changeScale(from: state)
            }
            .onEnded { state in
                validateScales()
                lastScale = 1.0
            }
    }

    var body: some View {
        ScrollView ([.vertical]) {
                ZStack {
                    ForEach(Array(concepts.relationships.indices), id: \.self) { pos_j in
                        ForEach(Array(concepts.relationships.enumerated()), id: \.element) { index, item in

                            if item.pair == concepts.relationships[pos_j].pair {
                                // MARK: check arrow works
                                
                                Path { path in
                                    path.move(to: CGPoint(x: concepts.nodes[concepts.relationships[pos_j].pair[0]].posx, y: concepts.nodes[concepts.relationships[pos_j].pair[0]].posy))
                                    path.addLine(to: CGPoint(x: concepts.nodes[concepts.relationships[pos_j].pair[1]].posx, y: concepts.nodes[concepts.relationships[pos_j].pair[1]].posy))
                                    path.closeSubpath()
                                }
                                .stroke(concepts.relationships[pos_j].isSelected ? Color("concept-dark-green") : Color("concept-blue"), lineWidth: concepts.relationships[pos_j].isSelected ? 7 : 5)
                                .scaleEffect(scale)
                                .onTapGesture(perform: {
                                    if concepts.deleteMode {
                                        for (index, element) in concepts.relationships.enumerated() {
                                            if element.pair == concepts.relationships[pos_j].pair {
                                                concepts.relationships[index].isSelected = concepts.relationships[index].isSelected ? false : true
                                                concepts.relationshipsToDelete.append(element.pair)
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                    ForEach(Array(concepts.nodes.indices), id: \.self) { i in
                        ConceptBuilderView(node: concepts, feedback: feedback, node_id: i, changedConcept: concepts.changedConcept)
                            .position(x: concepts.nodes[i].posx, y: concepts.nodes[i].posy)
                            .offset(x: concepts.nodes[i].offset.width, y: concepts.nodes[i].offset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { movement in
                                        concepts.nodes[i].offset = movement.translation
                                    }
                                    .onEnded { movement in
                                        withAnimation(.spring()) {
                                            // MARK: Checking Concept Node is within the boundaries
                                            concepts.nodes[i].posx = movement.location.x
                                            concepts.nodes[i].posy = movement.location.y
                                            if movement.location.y > maxH {
                                                maxH = movement.location.y + (concepts.nodes[i].height / 2)
                                            }
                                            if movement.location.y < minH {
                                                minH = movement.location.y - (concepts.nodes[i].height / 2)
                                            }
                                            concepts.nodes[i].offset = .zero
                                        }
                                    })
                            .gesture(LongPressGesture(minimumDuration: 0.5)
                                .onEnded { value in
                                    concepts.nodes[i].changeColour.toggle()
                                })
                            .alert("Change the Colour of the Concept Node", isPresented: $concepts.nodes[i].changeColour) {
                                Button("Blue") {concepts.nodes[i].colour = "concept-light-blue"}
                                Button("Pink") {concepts.nodes[i].colour = "concept-p"}
                                Button("Yellow") {concepts.nodes[i].colour = "concept-yellow"}
                            }
                            .scaleEffect(scale)
                            .onTapGesture {
                                concepts.save()
                                if concepts.deleteMode {
                                    concepts.nodes[i].isSelected = concepts.nodes[i].isSelected ? false : true
                                    concepts.conceptsToDelete.append(i)
                                }
                                if concepts.relationshipMode {
                                    concepts.nodes[i].isSelected = concepts.nodes[i].isSelected ? false : true
                                }
                                if concepts.relationshipMode {
                                    if concepts.relationshipsToAdd.count == 2 {
                                        concepts.nodes[concepts.relationshipsToAdd[0]].isSelected = false
                                        concepts.relationshipsToAdd.remove(at: 0)
                                        concepts.relationshipsToAdd.append(i)
                                        print("relationship added")
                                    } else {
                                        concepts.relationshipsToAdd.append(i)
                                    }
                                }
                            }
                    }
                }
                .frame(width: width, height: maxH - minH)
        }
        .gesture(zoomGesture)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    // create feedback
                    if concepts.nodes[concepts.changedConcept].title == "" {
                        // do nothing
                    } else {
                        var inputCheck = ResponseCategorisation(changedConcept: concepts.changedConcept)
                        let result = inputCheck.findCorrespondingConcept(user_concept: concepts.nodes[concepts.changedConcept])
                        let user_concept = result.0
                        let expert_concept = result.1
                        let full_expert_concept = result.4
                        let user_count = result.2
                        let expert_count = result.3
                        let exp_concepts = result.5
                        
                        let category = inputCheck.determineCategory(user_concept: user_concept, expert_concept: expert_concept, user_count: user_count, expert_count: expert_count)
                        print("___________")
                        print(category)
                        print(expert_concept)
                        print("___________")
                        
                        var expert_struct = exp_concepts[0]
                        for con in exp_concepts {
                            if con.concept.lowercased() == full_expert_concept {
                                expert_struct = con
                            }
                        }
                        feedback.savedUserModel.user_model = feedback.savedUserModel.updateCategorisation(response: category)
                        
                        feedback.FirstLayer(response: category, user_input: concepts.nodes[concepts.changedConcept].title, expert_concept: full_expert_concept, exp_concept: expert_struct)
                    }
                }
                .frame(alignment: .trailing)
            }
        }
        .overlay(
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "plus.magnifyingglass")
                        Slider(value: $scale, in: minScale...maxScale)
                            .tint(Color("concept-blue"))
                    }
                    .foregroundColor(Color("concept-blue"))
                    .frame(width: width * 0.8)
                }
                if feedback.showFeedback {
                    FeedbackPopUp(feedback: feedback, width: width * 0.9, height: height * 0.6)
                        .padding()
                }
                if feedback.showErrors {
                    ErrorPopUp(feedback: feedback, width: width * 0.9, height: height * 0.6)
                        .padding()
                }
                if feedback.showPerformance {
                    InterimPerformance(feedback: feedback, width: width * 0.9, height: height * 0.6)
                        .padding()
                }
            }
        )
        .background(Color("concept-white"))
        .onTapGesture{
             do {
                 var data: [String] = []
                 for i in Array(concepts.nodes.indices) {
                     data.append(concepts.nodes[i].title)
                 }
                 print(data)
             }
        }
    }
    
    func changeScale(from state: MagnificationGesture.Value) {
        deltaChange = state / lastScale
        scale *= deltaChange
        lastScale = state
    }
    
    func getMinScaleAllowed() -> CGFloat {
        return max(scale, minScale)
    }
    
    func getMaxScaleAllowed() -> CGFloat {
        return min(scale, maxScale)
    }
    
    func validateScales() {
        scale = getMinScaleAllowed()
        scale = getMaxScaleAllowed()
    }
}

struct ConceptMapMesh_Previews: PreviewProvider {
    static var previews: some View {
        ConceptMapMesh(width: 200, height: 500, concepts: AddNode(), feedback: AddFeedback())
    }
}
