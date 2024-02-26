//
//  ConceptMenu.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 23/11/2022.
//

import SwiftUI

struct ConceptMenu: View {
    @StateObject var concepts : AddNode
    @StateObject var feedback : AddFeedback
    @StateObject var userNavigation: AddNavigation
    
    @State private var firstNodeAdded = false
    
    var body: some View {
        HStack {
            Button(action: {
                feedback.showErrors = true
            }, label: {
                HStack {
                    Text("Errors: ")
                    Text(String(feedback.savedUserModel.user_model.numErrors))
                }
            })
            Spacer()
            Button(action: {
                concepts.deleteMode = concepts.deleteMode ? false : true
                concepts.labelRelationship = concepts.labelRelationship ? true : false
                
                for (index, _) in concepts.nodes.enumerated() {
                    concepts.nodes[index].isSelected = false
                }
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(Color("concept-blue"))
            })
            Spacer()
            Button(action: {
                concepts.relationshipMode = concepts.relationshipMode ? false : true
                concepts.labelRelationship = concepts.labelRelationship ? true : false
                
                for (index, _) in concepts.nodes.enumerated() {
                    concepts.nodes[index].isSelected = false
                }
            }, label: {
                Image(systemName: "line.diagonal.arrow")
                    .foregroundColor(Color("concept-blue"))
            })
            Spacer()
            Button(action: {
                concepts.addNewNode(title: "", colour: "concept-p")
                userNavigation.addNode()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(Color("concept-blue"))
            })
        }
        .padding(.top, 4)
    }
}

struct ConceptMenu_Previews: PreviewProvider {
    static var previews: some View {
        ConceptMenu(concepts: AddNode(), feedback: AddFeedback(), userNavigation: AddNavigation())
    }
}
