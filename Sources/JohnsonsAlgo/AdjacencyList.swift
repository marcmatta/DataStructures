//
//  AdjacencyList.swift
//  AFN-Magical-Record-Example
//
//  Created by marc matta on 12/3/15.
//  Copyright © 2015 Cocoa Star Apps. All rights reserved.
//

import Foundation

public typealias AdjacencyMatrix = Array<Array<Bool>>
//public typealias AdjacencyList = Array<Array<Int>>

/**
 * Calculates the adjacency-list for a given adjacency-matrix.
 *
 *
 * @author Frank Meyer, web@normalisiert.de
 * @version 1.0, 26.08.2006
 *
 */
public class AdjacencyList {
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
        var list = [Array<Int>](repeating: [], count: adjacencyMatrix.count)
        
        for i in 0..<adjacencyMatrix.count {
            var v = [Int]()
            for j in 0..<adjacencyMatrix[i].count{
                if (adjacencyMatrix[i][j]) {
                    v.append(j)
                }
            }
            
            list[i] = [Int](repeating: 0, count:v.count)
            for j in 0..<v.count {
                let in_ = v[j]
                list[i][j] = in_
            }
        }
        
        return list;
    }
}
