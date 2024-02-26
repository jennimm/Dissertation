//
//  ConceptBuilderView.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 11/11/2022.
//

import SwiftUI

struct ConceptBuilderView: View {
    @State private var firstConceptTextAdded = false
    
    @ObservedObject var node: AddNode
    @StateObject var feedback: AddFeedback
    
    @FocusState private var focusField: Field?
    private enum Field: Int {
        case changingConcept
    }
    
    var node_id: Int
    @State var changedConcept: Int
    var outlineColour = ["concept-p": "concept-d-pink", "concept-light-blue": "concept-dark-blue", "concept-yellow": "concept-dark-yellow"]
    
    var body: some View {
        VStack {
            // MARK: User presses enter to confirm concept text
            if node_id < node.nodes.count {
                Ellipse()
                    .fill(Color(node.nodes[node_id].colour))
                    .overlay(
                        Ellipse()
                            .stroke(node.nodes[node_id].isSelected ? Color("concept-dark-green") : Color(outlineColour[node.nodes[node_id].colour] ?? "concept-light-blue"), lineWidth: node.nodes[node_id].isSelected ? 5 : 3)
                    )
                    .overlay(
                            TextField("Add Concept:", text: $node.nodes[node_id].title, axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 10))
                                .lineLimit(3)
                                .frame(width: 110, height: 60)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .focused($focusField, equals: .changingConcept)
                                .onChange(of: node.nodes[node_id].title) { _ in
                                    node.changedConcept = node.nodes.firstIndex(of: node.nodes[node_id]) ?? -1
                                }
                                .disabled(node.relationshipMode == true || node.deleteMode == true)
                        
                    )
                    .frame(width: node.nodes[node_id].width, height: node.nodes[node_id].height, alignment: .center)
            }
        }
    }
}

struct ConceptBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ConceptBuilderView(node: AddNode(), feedback: AddFeedback(), node_id: 0, changedConcept: 0)
    }
}
