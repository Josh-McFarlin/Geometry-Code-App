//
//  EditorViewController.swift
//  GeomAppGame
//
//  Created by Joshua McFarlin on 8/22/17.
//  Copyright © 2017 Joshua McFarlin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBAction func render() {
        Variables.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        let s = Shapes(scene: Variables.scene)
        let info = s.processText(str: myTextView.text)
        for item in info {
            s.processItem(arry: item)
        }
        
        tabBarController?.selectedIndex = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTextView.layer.borderWidth = 0.5
        myTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditorViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
