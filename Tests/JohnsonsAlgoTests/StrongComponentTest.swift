//
//  StrongComponentTest.swift
//  JohnsonsAlgoTests
//
//  Created by Klaus Kneupner on 07/05/2022.
//


import XCTest
@testable import JohnsonsAlgo

final class StrongComponentTests: XCTestCase {

    func buildEmptyGraph(n: Int) -> (AdjacencyMatrix, Array<String>) {
        var nodes = [String](repeating: "", count: n)
        let adjMatrix = [[Bool]](repeating: [Bool](repeating: false, count: n), count: n);
        
        for i in 0..<n {
            nodes[i] = "Node " + String(i);
        }
        return (adjMatrix,nodes)
    }
    
    func testTarjan() throws {
        var (adjMatrix,nodes) = buildEmptyGraph(n: 10)
  
        
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
    
    // from: https://en.wikipedia.org/wiki/Strongly_connected_component
    func testWikiExample () throws {
        var (adjMatrix,nodes) = buildEmptyGraph(n: 8)
        adjMatrix[0][1] = true
        adjMatrix[1][2] = true
        adjMatrix[1][4] = true
        adjMatrix[1][5] = true
        adjMatrix[2][3] = true
        adjMatrix[2][6] = true
        adjMatrix[3][2] = true
        adjMatrix[3][7] = true
        adjMatrix[4][0] = true
        adjMatrix[4][5] = true
        adjMatrix[5][6] = true
        adjMatrix[6][5] = true
        adjMatrix[7][6] = true
        adjMatrix[7][3] = true

        let ecs = ElementaryCyclesSearch(matrix: adjMatrix, graphNodes: nodes)
        let cycles = try ecs.getElementaryCycles()
        for i in 0..<cycles.count {
            let cycle = cycles[i]
            var representation = ""
            for j in 0..<cycle.count {
                let node = cycle[j]
                if j < cycle.count - 1 {
                    representation += node + " -> "
                }else {
                    representation += node
                }
            }
            print(representation + "\n")
        }
        XCTAssertEqual(cycles.count,3 )
       
    }
}
