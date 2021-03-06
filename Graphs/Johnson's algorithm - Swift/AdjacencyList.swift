//
//  AdjacencyList.swift
//  AFN-Magical-Record-Example
//
//  Created by marc matta on 12/3/15.
//  Copyright © 2015 Cocoa Star Apps. All rights reserved.
//

import Foundation

/**
 * Calculates the adjacency-list for a given adjacency-matrix.
 *
 *
 * @author Frank Meyer, web@normalisiert.de
 * @version 1.0, 26.08.2006
 *
 */
@objc public class AdjacencyList : NSObject {
    /**
     * Calculates a adjacency-list for a given array of an adjacency-matrix.
     *
     * @param adjacencyMatrix array with the adjacency-matrix that represents
     * the graph
     * @return int[][]-array of the adjacency-list of given nodes. The first
     * dimension in the array represents the same node as in the given
     * adjacency, the second dimension represents the indicies of those nodes,
     * that are direct successornodes of the node.
     */
    class func getAdjacencyList( adjacencyMatrix: Array<Array<Bool>>) -> Array<Array<Int>> {
        var list = [Array<Int>](count: adjacencyMatrix.count, repeatedValue: [])
        
        for var i = 0; i < adjacencyMatrix.count; ++i {
            var v = [Int]()
            for var j = 0; j < adjacencyMatrix[i].count; ++j {
                if (adjacencyMatrix[i][j]) {
                    v.append(j)
                }
            }
            
            list[i] = [Int](count:v.count, repeatedValue: 0)
            for var j = 0; j < v.count; ++j {
                let in_ = v[j]
                list[i][j] = in_
            }
        }
        
        return list;
    }
}