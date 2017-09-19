//
//  Shapes.swift
//  GeomAppGame
//
//  Created by Joshua McFarlin on 8/22/17.
//  Copyright © 2017 Joshua McFarlin. All rights reserved.
//

import UIKit
import SceneKit
import Foundation

class Shapes {
    
    var scene: SCNScene
    
    init(scene: SCNScene) {
        self.scene = scene
    }
    
    func findPos(line: String) -> SCNVector3 {
        let nums = stringToArray(str: line)
        return SCNVector3Make(Float(nums[0]), Float(nums[2]), Float(nums[1]))
    }
    
    func degToRad(degrees: Float) -> Float {
        return degrees * 3.14/180
    }
    
    func rotation(x: Float, y: Float, z: Float) -> SCNMatrix4 {
        let xRot = SCNMatrix4MakeRotation(degToRad(degrees: x), 1, 0, 0)
        let yRot = SCNMatrix4MakeRotation(degToRad(degrees: y), 0, 1, 0)
        let zRot = SCNMatrix4MakeRotation(degToRad(degrees: z), 0, 0, 1)
        return SCNMatrix4Mult(xRot, SCNMatrix4Mult(yRot, zRot))
    }
    
    func stringToArray(str: String) -> Array<CGFloat> {
        var pS = str.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range:nil)
        pS = pS.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
        let nI = pS.components(separatedBy: ",")
        let formatted = nI.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        var force = [CGFloat]()
        for item in formatted {
            force.append(CGFloat((item as NSString).floatValue))
        }
        return force
    }
    
    func processText(str: String) -> Array<Array<String>> {
        var objs = [Array<String>]()
        let lineArray = str.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        for item in lineArray {
            let form = item.components(separatedBy: ") ")
            objs.append(form)
        }
        return objs
    }
    
    func processItem(arry: Array<String>) {
        var pos = "(0,0,0)"
        var rot = SCNMatrix4MakeRotation(0, 0, 0, 0)
        for item in arry {
            if item.range(of:"rotation") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 8)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                rot = rotation(x: Float(nums[0]), y: Float(nums[1]), z: Float(nums[2]))
            } else if item.range(of:"position") != nil {
                pos = String(item[item.index(item.startIndex, offsetBy: 8)..<item.endIndex])
            } else if item.range(of:"cube") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 4)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addCube(width: nums[0], posString: pos, rot: rot)
            } else if item.range(of:"prism") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 5)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addPrism(width: nums[0], height: nums[1], length: nums[2], posString: pos, rot: rot)
            } else if item.range(of:"cone") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 4)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addCone(topRadius: nums[0], bottomRadius: nums[1], height: nums[2], posString: pos, rot: rot)
            } else if item.range(of:"cylinder") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 8)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addCylinder(radius: nums[0], height: nums[1], posString: pos, rot: rot)
            } else if item.range(of:"pyramid") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 7)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addPyramid(width: nums[0], height: nums[1], length: nums[2], posString: pos, rot: rot)
            } else if item.range(of:"sphere") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 6)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addSphere(radius: nums[0], posString: pos, rot: rot)
            } else if item.range(of:"torus") != nil {
                let ret = item[item.index(item.startIndex, offsetBy: 5)..<item.endIndex]
                let nums = stringToArray(str: String(ret))
                addTorus(ringRadius: nums[0], pipeRadius: nums[1], posString: pos, rot: rot)
            } else if item.range(of:"floor") != nil {
                addFloor()
            }
        }
    }
    
    func addCube(width: CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNBox(width: width, height: width, length: width, chamferRadius: 0))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addPrism(width: CGFloat, height: CGFloat, length: CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNBox(width: width, height: height, length: length, chamferRadius: 0))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addCone(topRadius: CGFloat, bottomRadius: CGFloat, height:CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNCone(topRadius: topRadius, bottomRadius: bottomRadius, height: height))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addCylinder(radius: CGFloat, height:CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNCylinder(radius: radius, height: height))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addPyramid(width: CGFloat, height:CGFloat, length: CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNPyramid(width: width, height: height, length: length))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addSphere(radius: CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNSphere(radius: radius))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addTorus(ringRadius: CGFloat, pipeRadius:CGFloat, posString: String, rot: SCNMatrix4) {
        let shape = SCNNode(geometry: SCNTorus(ringRadius: ringRadius, pipeRadius: pipeRadius))
        shape.transform = rot
        shape.position = findPos(line: posString)
        self.scene.rootNode.addChildNode(shape)
    }
    
    func addFloor() {
        let floor = SCNFloor()
        floor.length = 100
        floor.width = 100
        floor.firstMaterial?.diffuse.contents  = UIColor(red: 95.0 / 255.0, green: 105.0 / 255.0, blue: 114.0 / 255.0, alpha: 1)
        let plane = SCNNode(geometry: floor)
        plane.position = SCNVector3(0, 0, 0)
        self.scene.rootNode.addChildNode(plane)
    }
}
