//
//  SCCResi;.swift
//  AFN-Magical-Record-Example
//
//  Created by marc matta on 12/3/15.
//  Copyright © 2015 Cocoa Star Apps. All rights reserved.
//

import Foundation

public class SCCResult {
    var nodeIDsOfSCC : Set<Int>
    var adjList : Array<Array<Int>>
    var lowestNodeId : Int
    
    init(adjList: Array<Array<Int>>, lowestNodeId: Int) {
        self.adjList = adjList
        self.lowestNodeId = lowestNodeId
        nodeIDsOfSCC = []
        for index in lowestNodeId..<adjList.count {
            if (adjList[index].count > 0) {
                self.nodeIDsOfSCC.insert(index)
            }
        }
    }
}
