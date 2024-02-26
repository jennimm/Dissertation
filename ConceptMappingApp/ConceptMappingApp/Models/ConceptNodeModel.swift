//
//  ConceptNodeModel.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 18/11/2022.
//

import Foundation

struct Node: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var isSelected: Bool
    
    var width: Double
    var height: Double
    var posx: Double
    var posy: Double
    var offset: CGSize
    var colour: String
    
    var relations: [[Int]]
    var changeColour: Bool
    
    init(title: String, isSelected: Bool, width: Double, height: Double, posx: Double, posy: Double, offset: CGSize, colour: String, relations: [[Int]], changeColour: Bool) {
        self.title = title
        self.isSelected = isSelected
        self.width = width
        self.height = height
        self.posx = posx
        self.posy = posy
        self.offset = offset
        self.colour = colour
        self.relations = relations
        self.changeColour = changeColour
    }
}

// code found https://stackoverflow.com/questions/67974656/stored-property-type-cgpoint-does-not-conform-to-protocol-hashable
extension CGSize : Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }
}
