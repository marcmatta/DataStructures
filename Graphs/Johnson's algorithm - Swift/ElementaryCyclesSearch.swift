//
//  ElementaryCyclesSearch.swift
//  AFN-Magical-Record-Example
//
//  Created by marc matta on 12/3/15.
//  Copyright © 2015 Cocoa Star Apps. All rights reserved.
//

import Foundation

/**
* Searchs all elementary cycles in a given directed graph. The implementation
* is independent from the concrete objects that represent the graphnodes, it
* just needs an array of the objects representing the nodes the graph
* and an adjacency-matrix of type boolean, representing the edges of the
* graph. It then calculates based on the adjacency-matrix the elementary
* cycles and returns a list, which contains lists itself with the objects of the
* concrete graphnodes-implementation. Each of these lists represents an
* elementary cycle.<br><br>
*
* The implementation uses the algorithm of Donald B. Johnson for the search of
* the elementary cycles. For a description of the algorithm see:<br>
* Donald B. Johnson: Finding All the Elementary Circuits of a Directed Graph.
* SIAM Journal on Computing. Volumne 4, Nr. 1 (1975), pp. 77-84.<br><br>
*
* The algorithm of Johnson is based on the search for strong connected
* components in a graph. For a description of this part see:<br>
* Robert Tarjan: Depth-first search and linear graph algorithms. In: SIAM
* Journal on Computing. Volume 1, Nr. 2 (1972), pp. 146-160.<br>
*
* @author Frank Meyer, web_at_normalisiert_dot_de
* @version 1.2, 22.03.2009
*
*/

@objc public class ElementaryCyclesSearch : NSObject {
    /** List of cycles */
    private var cycles : Array<Array<AnyObject>>?
    
    /** Adjacency-list of graph */
    private var adjList : Array<Array<Int>>
    
    /** Graphnodes */
    private var graphNodes : Array<AnyObject>
    
    /** Blocked nodes, used by the algorithm of Johnson */
    private var blocked : Array<Bool>?
    
    /** B-Lists, used by the algorithm of Johnson */
    private var B : Array<Array<Int>>?
    
    /** Stack for nodes, used by the algorithm of Johnson */
    private var stack : Array<Int>?
    
    /**
    * Constructor.
    *
    * @param matrix adjacency-matrix of the graph
    * @param graphNodes array of the graphnodes of the graph; this is used to
    * build sets of the elementary cycles containing the objects of the original
    * graph-representation
    */
    init(matrix: Array<Array<Bool>>, graphNodes: Array<AnyObject>) {
        self.graphNodes = graphNodes;
        self.adjList = AdjacencyList.getAdjacencyList(adjacencyMatrix: matrix);
    }
    
    /**
    * Returns List::List::Object with the Lists of nodes of all elementary
    * cycles in the graph.
    *
    * @return List::List::Object with the Lists of the elementary cycles.
    */
    func getElementaryCycles() -> Array<Array<AnyObject>> {
        self.cycles = Array<Array<AnyObject>>()
        self.blocked = [Bool](repeating:false, count:self.adjList.count)
        self.B = [Array<Int>](repeating: [], count: self.adjList.count)
        self.stack = [Int]()
        
        let sccs = StrongConnectedComponents(adjList: self.adjList)
        var s = 0
        
        while(true) {
            let sccResult = sccs.getAdjacencyList(node: s)
            if let result = sccResult {
                let scc = result.adjList
                s = result.lowestNodeId
                for j in 0..<scc.count{
                    self.blocked![j] = false
                    self.B![j] = [Int]()
                }
                
                findCycles(v: s, s: s, adjList: scc)
                s = s + 1
            }else {
                break
            }
        }
        
        return self.cycles!
    }
    
    /**
    * Calculates the cycles containing a given node in a strongly connected
    * component. The method calls itself recursivly.
    *
    * @param v
    * @param s
    * @param adjList adjacency-list with the subgraph of the strongly
    * connected component s is part of.
    * @return true, if cycle found; false otherwise
    */
    func findCycles(v: Int, s: Int, adjList:Array<Array<Int>> ) -> Bool {
        var f = false;
        self.stack?.append(v)
        self.blocked![v] = true;
    
        for i in 0..<adjList[v].count {
            let w = adjList[v][i]
            // found cycle
            if (w == s) {
				var cycle = Array<AnyObject>()
				for j in 0..<self.stack!.count {
                    let index = self.stack![j]
                    cycle.append(self.graphNodes[index])
				}
				self.cycles?.append(cycle);
				f = true;
            } else if (!self.blocked![w]) {
                if (findCycles(v: w, s: s, adjList: adjList)) {
                    f = true;
				}
            }
        }
    
        if (f) {
            unblock(node: v)
        } else {
            for i in 0..<adjList[v].count {
				let w = adjList[v][i]
				if (!self.B![w].contains(v)) {
                    self.B![w].append(v)
				}
            }
        }
    
        let indexToRemove = self.stack!.index(of: v)
        if let index = indexToRemove {
            self.stack!.remove(at: index)
        }
        return f
    }
    
    /**
    * Unblocks recursivly all blocked nodes, starting with a given node.
    *
    * @param node node to unblock
    */
    func unblock(node: Int) {
        self.blocked![node] = false
        var Bnode = self.B![node]
        while (Bnode.count > 0) {
            let w = Bnode.first!
            Bnode.remove(at:0)
            if (self.blocked![w]) {
                self.unblock(node: w)
            }
        }
    }
}
