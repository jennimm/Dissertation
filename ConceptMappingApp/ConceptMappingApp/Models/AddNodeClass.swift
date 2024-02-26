//
//  ConceptNodes.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 06/12/2022.
//

import Foundation

class AddNode: ObservableObject {
    @Published var nodes : [Node] = []
    @Published var relationships: [Relationship] = []
    @Published var nodeTitles: [String] = []
    @Published var deleteMode = false
    @Published var relationshipMode = false
    @Published var labelRelationship = true
    @Published var conceptsToDelete : [Int] = []
    @Published var relationshipsToDelete : [[Int]] = []
    @Published var relationshipsToAdd : [Int] = []
    @Published var changedConcept = 0
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "nodes") {
           if let decoded = try? JSONDecoder().decode([Node].self, from: data) {
                nodes = decoded
                
            } else {
                nodes = []
            }
        }
        
        if let data1 = UserDefaults.standard.data(forKey: "relationships") {
           if let decoded = try? JSONDecoder().decode([Relationship].self, from: data1) {
                relationships = decoded
            } else {
                relationships = []
            }
        }
        for (index, _) in nodes.enumerated() {
            nodes[index].isSelected = false
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(nodes) {
            UserDefaults.standard.set(encoded, forKey: "nodes")
        }
        if let encode = try? JSONEncoder().encode(relationships) {
            UserDefaults.standard.set(encode, forKey: "relationships")
        }
        print("Saved")
    }
    
    func addNewNode(title: String, colour: String) {
        nodes.append(Node(title: title, isSelected: false, width: 120, height: 70, posx: 100, posy: 100, offset: CGSize.zero, colour: colour, relations: [], changeColour: false))
        save()
        nodeTitles.append(title)
    }
    
    func removeNode(id: Int) {
        var indices : [[Int]] = []
        var ids: [Int] = []
        var count = 0
        for relationship in relationships {
            print(relationship)
            if relationship.pair.contains(id) {
                indices.append(relationship.pair)
                ids.append(count)
            }
            count = count + 1
        }
        ids.sort()
        ids = ids.reversed()
        indices = indices.reversed()
        
        if ids.count > 0 {
            for item in ids {
                relationships.remove(at: item)
            }
        }
        
        
        if nodeTitles.count >= id && nodeTitles.count > 0 {
            let string_index = nodeTitles.firstIndex(of: nodes[id].title)
            if string_index != nil {
                nodeTitles.remove(at: string_index!)
            }
        }
        nodes.remove(at: id)
        for (index, element) in relationships.enumerated() {
            if element.pair[0] > id {
                relationships[index].pair[0] = relationships[index].pair[0] - 1
            }
            if element.pair[1] > id {
                relationships[index].pair[1] = relationships[index].pair[1] - 1
            }
        }
        
        save()
    }
    
    func removeRelationship(relation: [Int]) {
        var indices : [[Int]] = []
        var ids: [Int] = []
        var count = 0
        for relationship in relationships {
            if relationship.pair == relation {
                indices.append(relationship.pair)
                ids.append(count)
            }
            count = count + 1
        }
        ids = ids.reversed()
        indices = indices.reversed()
        for item in ids {
            relationships.remove(at: item)
        }
        
        findIndexOfRelation(nodes: nodes, relation: relation)
        findIndexOfRelation(nodes: nodes, relation: relation)
    }
    
    func addNewRelationship(nodeA: Int, nodeB: Int) {
        relationships.append(Relationship(pair: [nodeA, nodeB], isSelected: false, label: ""))
        save()
        nodes[nodeA].relations.append([nodeA, nodeB])
        nodes[nodeB].relations.append([nodeA, nodeB])
    }
    
    func findIndexOfRelation(nodes: [Node], relation: [Int]) {
        var index = -1
        var counter = 0
        for relationship in nodes[relation[0]].relations {
            if relationship == relation {
                index = counter
            }
            if relationship == relation.reversed() {
                index = counter
            }
            counter += 1
        }
        if index != -1 {
            self.nodes[relation[0]].relations.remove(at: index)
        }
    }
}
