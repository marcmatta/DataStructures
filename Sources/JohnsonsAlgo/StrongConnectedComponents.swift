//
//  StrongConnectedComponents.swift
//  AFN-Magical-Record-Example
//
//  Created by marc matta on 12/3/15.
//  Copyright © 2015 Cocoa Star Apps. All rights reserved.
//

import Foundation
/**
 * This is a helpclass for the search of all elementary cycles in a graph
 * with the algorithm of Johnson. For this it searches for strong connected
 * components, using the algorithm of Tarjan. The constructor gets an
 * adjacency-list of a graph. Based on this graph, it gets a nodenumber s,
 * for which it calculates the subgraph, containing all nodes
 * {s, s + 1, ..., n}, where n is the highest nodenumber in the original
 * graph (e.g. it builds a subgraph with all nodes with higher or same
 * nodenumbers like the given node s). It returns the strong connected
 * component of this subgraph which contains the lowest nodenumber of all
 * nodes in the subgraph.<br><br>
 *
 * For a description of the algorithm for calculating the strong connected
 * components see:<br>
 * Robert Tarjan: Depth-first search and linear graph algorithms. In: SIAM
 * Journal on Computing. Volume 1, Nr. 2 (1972), pp. 146-160.<br>
 * For a description of the algorithm for searching all elementary cycles in
 * a directed graph see:<br>
 * Donald B. Johnson: Finding All the Elementary Circuits of a Directed Graph.
 * SIAM Journal on Computing. Volumne 4, Nr. 1 (1975), pp. 77-84.<br><br>
 *
 * @author Frank Meyer, web_at_normalisiert_dot_de
 * @version 1.1, 22.03.2009
 *
 */
public class StrongConnectedComponents {
    /** Adjacency-list of original graph */
    private var adjListOriginal : Array<Array<Int>>
    
    /** Adjacency-list of currently viewed subgraph */
    private var adjList : Array<Array<Int>>?
    
    /** Helpattribute for finding scc's */
    private var visited : Array<Bool>?
    
    /** Helpattribute for finding scc's */
    private var stack : Array<Int>?
    
    /** Helpattribute for finding scc's */
    private var lowlink : Array<Int>?
    
    /** Helpattribute for finding scc's */
    private var number : Array<Int>?
    
    /** Helpattribute for finding scc's */
    private var sccCounter : Int = 0
    
    /** Helpattribute for finding scc's */
    private var currentSCCs : Array<Array<Int>>?
    
    /**
     * Constructor.
     *
     * @param adjList adjacency-list of the graph
     */
    init(adjList:Array<Array<Int>>){
        self.adjListOriginal = adjList
    }
    
    /**
     * This method returns the adjacency-structure of the strong connected
     * component with the least vertex in a subgraph of the original graph
     * induced by the nodes {s, s + 1, ..., n}, where s is a given node. Note
     * that trivial strong connected components with just one node will not
     * be returned.
     *
     * @param node node s
     * @return SCCResult with adjacency-structure of the strong
     * connected component; null, if no such component exists
     */
    func getAdjacencyList(node:Int) -> SCCResult? {
        self.visited = [Bool](repeating: false, count: self.adjListOriginal.count)
        self.lowlink = [Int](repeating: 0, count: self.adjListOriginal.count)
        self.number = [Int](repeating: 0, count: self.adjListOriginal.count)
        self.stack = Array<Int>()
        self.currentSCCs = Array<Array<Int>>()
        
        makeAdjListSubgraph(node: node)
        
        for i in node..<self.adjListOriginal.count {
            if (!self.visited![i]) {
                getStrongConnectedComponents(root: i)
                
                let nodes = getLowestIdComponent()
                if let n = nodes, (!n.contains(node) && !n.contains(node+1)) {
                    return getAdjacencyList(node: node+1)
                } else {
                    let adjacencyList = getAdjList(nodes: nodes)
                    if let ad = adjacencyList {
                        for j in 0..<self.adjListOriginal.count {
                            if (ad[j].count > 0){
                                return SCCResult(adjList: ad, lowestNodeId: j)
                            }
                            
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    /**
     * Builds the adjacency-list for a subgraph containing just nodes
     * >= a given index.
     *
     * @param node Node with lowest index in the subgraph
     */
    func makeAdjListSubgraph(node: Int) {
        self.adjList = Array<Array<Int>>(repeating:[], count:self.adjListOriginal.count)
        
        for i in node..<self.adjList!.count {
            var successors = Array<Int>()
            for j in 0..<self.adjListOriginal[i].count {
                if self.adjListOriginal[i][j] >= node {
                    successors.append(self.adjListOriginal[i][j]);
                }
            }
            
            if (successors.count > 0) {
                self.adjList![i] = [Int](repeating:0, count:successors.count)
                for j in 0..<successors.count {
                    let succ = successors[j]
                    self.adjList![i][j] = succ
                }
            }
        }
    }
    
    /**
     * Calculates the strong connected component out of a set of scc's, that
     * contains the node with the lowest index.
     *
     * @return Vector::Integer of the scc containing the lowest nodenumber
     */
    func getLowestIdComponent() -> Array<Int>? {
        var min = self.adjList!.count
        var currScc : Array<Int>?;
        for i in 0..<self.currentSCCs!.count {
            let scc = self.currentSCCs![i]
            for j in 0..<scc.count {
                let node = scc[j]
                if (node < min) {
                    currScc = scc
                    min = node
                }
            }
        }
        return currScc
    }
    
    /**
     * @return Vector[]::Integer representing the adjacency-structure of the
     * strong connected component with least vertex in the currently viewed
     * subgraph
     */
    func getAdjList(nodes: Array<Int>?) -> Array<Array<Int>>?{
        var lowestIdAdjacencyList : Array<Array<Int>>?
        if let n = nodes {
            lowestIdAdjacencyList =  [Array<Int>](repeating: [], count: self.adjList!.count)
            for i in 0..<lowestIdAdjacencyList!.count {
                lowestIdAdjacencyList![i] = [Int]()
            }
            for i in 0..<n.count{
                let node = n[i]
                for j in 0..<self.adjList![node].count {
                    let succ = self.adjList![node][j]
                    if n.contains(succ) {
                        lowestIdAdjacencyList![node].append(succ)
                    }
                }
            }
        }
        return lowestIdAdjacencyList
    }
    
    /**
     * Searchs for strong connected components reachable from a given node.
     *
     * @param root node to start from.
     */
    func getStrongConnectedComponents(root: Int) {
        self.sccCounter = self.sccCounter + 1
        self.lowlink![root] = self.sccCounter
        self.number![root] = self.sccCounter
        self.visited![root] = true
        self.stack!.append(root)
        
        for i in 0..<self.adjList![root].count {
            let w = self.adjList![root][i];
            if (!self.visited![w]) {
                self.getStrongConnectedComponents(root: w)
                self.lowlink![root] = min(lowlink![root], lowlink![w])
            } else if (self.number![w] < self.number![root]) {
                if (self.stack!.contains(w)) {
                    lowlink![root] = min(self.lowlink![root], self.number![w]);
                }
            }
        }
        
        // found scc
        if ((lowlink![root] == number![root]) && (stack!.count > 0)) {
            var next = -1;
            var scc = [Int]()
            repeat {
                next = self.stack!.last!
                self.stack!.remove(at:stack!.count - 1)
                scc.append(next)
            } while (self.number![next] > self.number![root])
            // simple scc's with just one node will not be added
            if (scc.count > 1) {
                self.currentSCCs!.append(scc)
            }
        }
    }
    
    class func test() throws {
        var nodes = [String](repeating: "", count: 10)
        var adjMatrix = [[Bool]](repeating: [Bool](repeating: false, count: 10), count: 10);
        
        for i in 0..<10 {
            nodes[i] = "Node " + String(i);
        }
        
        adjMatrix[0][1] = true;
        adjMatrix[1][2] = true;
        adjMatrix[2][0] = true;
        adjMatrix[2][6] = true;
        adjMatrix[3][4] = true;
        adjMatrix[4][5] = true;
        adjMatrix[4][6] = true;
        adjMatrix[5][3] = true;
        adjMatrix[6][7] = true;
        adjMatrix[7][8] = true;
        adjMatrix[8][6] = true;
        adjMatrix[6][1] = true;
        
        let ecs = ElementaryCyclesSearch(matrix: adjMatrix, graphNodes: nodes as Array<AnyObject>)
        let cycles = try ecs.getElementaryCycles()
        for i in 0..<cycles.count {
            let cycle = cycles[i]
            var representation = ""
            for j in 0..<cycle.count {
                let node = cycle[j]
                if j < cycle.count - 1 {
                    representation += node as! String + " -> "
                }else {
                    representation += node as! String
                }
            }
            print(representation + "\n")
        }
    }
}
