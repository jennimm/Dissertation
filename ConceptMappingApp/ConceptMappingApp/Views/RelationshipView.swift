//
//  RelationshipView.swift
//  ConceptMappingApp
//
//  Created by pos_jennifer on 05/02/2023.
//

import SwiftUI

struct RelationshipView: View {
    @StateObject var concepts : AddNode
    var pos_j : Int
    var index : Int
    
    @State private var presentAlert = false
    @State private var username: String = "."
    
    
    @FocusState private var focusField: Field?
    private enum Field: Int {
        case changingConcept
    }
    
    var body: some View {
        VStack {
            Path { path in
                path.move(to: CGPoint(x: concepts.nodes[concepts.relationships[pos_j].pair[0]].posx, y: concepts.nodes[concepts.relationships[pos_j].pair[0]].posy))
                path.addLine(to: CGPoint(x: concepts.nodes[concepts.relationships[pos_j].pair[1]].posx, y: concepts.nodes[concepts.relationships[pos_j].pair[1]].posy))
                path.closeSubpath()
            }
            .stroke(concepts.relationships[pos_j].isSelected ? Color("concept-dark-green") : Color("concept-blue"), lineWidth: concepts.relationships[pos_j].isSelected ? 5 : 3)
            .overlay (
                VStack {
                    Button(username) {
                                presentAlert = true
                            }
                            .alert("Enter relationship label", isPresented: $presentAlert, actions: {
                                TextField("Label", text: $username)
                            
                                Button("Done", action: {
                                    presentAlert = false
                                })
                                Button("Cancel", role: .cancel, action: {})
                            })
                            .foregroundColor(.black)
                            .position(x: (concepts.nodes[concepts.relationships[pos_j].pair[0]].posx + concepts.nodes[concepts.relationships[pos_j].pair[1]].posx)/2, y: ((concepts.nodes[concepts.relationships[pos_j].pair[0]].posy + concepts.nodes[concepts.relationships[pos_j].pair[1]].posy)/2 + 10))
                }
            )
        }
    }
}


struct RelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipView(concepts: AddNode(), pos_j: 1, index: 0)
    }
}
