//
//  ContentView.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 11/11/2022.
//

import SwiftUI
import PDFKit

struct ContentView: View {    
    @StateObject var concepts = AddNode()
    @StateObject var feedback = AddFeedback()
    @StateObject var userModel = UserProfile()
    @StateObject var userNavigation = AddNavigation()
    @State private var showTextbook = false
    @State var document: PDFDocument
    @State var page: Int
    let pdfViewer: PDFKitView
    @State var timer = Date.now
    
    init() {
      let coloredAppearance = UINavigationBarAppearance()
      coloredAppearance.configureWithOpaqueBackground()
      coloredAppearance.backgroundColor = UIColor(Color("concept-light-pink"))
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color("concept-blue"))]
      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color("concept-blue"))]
      
      UINavigationBar.appearance().standardAppearance = coloredAppearance
      UINavigationBar.appearance().compactAppearance = coloredAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        _document = State(initialValue: PDFDocument())
        _page = State(initialValue: 0)
        
        if let url = Bundle.main.url(forResource: "Lipsum", withExtension: "pdf"),
        let docData = try? Data(contentsOf: url) {
            self.pdfViewer = PDFKitView(data: docData)
       } else {
           self.pdfViewer = PDFKitView(data: Data())
        }
        
    }
    
    let NC = NotificationCenter.default
    
    var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            Button(action: {
                                print(userNavigation.navigation)
                                print(userNavigation.navigation.pageChanges)
                                print(userModel.user_model.relationshipsAdded)
                            }, label: {
                                Image(systemName: "square.and.arrow.down")
                            })
                            .padding(.trailing, 190)
                            Text("Textbook:")
                                .foregroundColor(Color("concept-blue"))
                            Toggle("", isOn: $showTextbook)
                                .tint(Color("concept-blue"))
                        }
                        .padding(5)
                        VStack {
                            // MARK: Data textbook
                            if showTextbook {
                                //PDFKitView(pdfDocument: $document, page: $page, data: docData)
                                pdfViewer
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color("concept-purple"))
                                    }
                                    .frame(height: geometry.size.height * 0.35)
                                    .onReceive(NC.publisher(for: .PDFViewPageChanged)) { _ in
                                        if let thePage = pdfViewer.pdfView.currentPage,
                                           let ndx = pdfViewer.pdfView.document?.index(for: thePage), userNavigation.currentPage != ndx {
                                            userNavigation.currentPage = ndx
                                            
                                            let diff = Date.now.timeIntervalSince(timer)
                                            if diff > 5 {
                                                userNavigation.navigation.pageChanges.append(userNavigation.currentPage)
                                                userNavigation.navigation.timeChanges.append(Date.now)
                                                timer = Date.now
                                            }
                                        }
                                    }
                            }
                            
                            // MARK: Concept Menu Options
                            ConceptMenu(concepts: concepts, feedback: feedback, userNavigation: userNavigation)
                                .padding([.leading, .trailing], 5)
                            
                            // MARK: Deleting Nodes and Relationships
                            if concepts.deleteMode && concepts.nodes.count > 0 && !concepts.relationshipMode {
                                Text("Select the nodes to delete by tapping them.")
                                    .foregroundColor(Color("concept-blue"))
                                Button(action: {
                                    for relation in concepts.relationshipsToDelete {
                                        concepts.removeRelationship(relation: relation)
                                    }
                                    concepts.relationshipsToDelete = []
                                    
                                    concepts.conceptsToDelete.sort()
                                    concepts.conceptsToDelete.reverse()
                                    for concept in concepts.conceptsToDelete {
                                        concepts.removeNode(id: concept)
                                    }
                                    concepts.conceptsToDelete = []
                                    concepts.deleteMode = false
                                }, label: {
                                    Text("Delete")
                                        .foregroundColor(Color("concept-red"))
                                })
                                .disabled(concepts.conceptsToDelete.count == 0)
                            }
                            // MARK: Adding a Relationship Between Two Nodes
                            if concepts.relationshipMode && concepts.nodes.count > 0 && !concepts.deleteMode{
                                Text("Select the two nodes to join by tapping them.")
                                Button(action: {
                                    if concepts.relationshipsToAdd.count == 2 {
                                        concepts.addNewRelationship(nodeA: concepts.relationshipsToAdd[0], nodeB: concepts.relationshipsToAdd[1])
                                        concepts.relationshipMode = false
                                        concepts.nodes[concepts.relationshipsToAdd[0]].isSelected = false
                                        concepts.nodes[concepts.relationshipsToAdd[1]].isSelected = false
                                        concepts.relationshipsToAdd = []
                                        userModel.user_model.relationshipsAdded.append(Date.now)
                                    } else {
                                        concepts.relationshipMode = false
                                        concepts.relationshipsToAdd = []
                                    }
                                    
                                }, label: {
                                    Text("Add Relation")
                                        .foregroundColor(Color("concept-red"))
                                })
                            }
                            
                            
                            // MARK: Concept Building Area
                            ConceptMapMesh(width: geometry.size.width, height: geometry.size.height , concepts: concepts, feedback: feedback)
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                .navigationTitle("Build A Concept Map")
                .navigationBarTitleDisplayMode(.large)
                .background(Color("concept-light-pink"))
            }
        .popover(isPresented: $feedback.showAlert)
        {
            PerformanceFeedback(userModel: userModel, feedback: feedback)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
