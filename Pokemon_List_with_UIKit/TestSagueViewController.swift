//
//  TestSagueViewController.swift
//  Pokemon_List_with_UIKit
//
//  Created by tharis on 31/7/2564 BE.
//

import UIKit

class TestSagueViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    var poKename:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.text = poKename
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
