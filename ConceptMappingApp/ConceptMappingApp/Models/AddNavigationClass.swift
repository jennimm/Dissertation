//
//  AddNavigationClass.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 10/03/2023.
//

import Foundation

class AddNavigation: ObservableObject {
    @Published var navigation : NavigationPath = NavigationPath()
    @Published var currentPage = 0
    
    func addNode() {
        let time = Date.now
        navigation.nodesAdded.append(time)
        navigation.pageChanges.append(currentPage-1)
        navigation.timeChanges.append(time)
        navigation.pageChanges.append(currentPage)
        navigation.timeChanges.append(time.addingTimeInterval(3))
    }
}
