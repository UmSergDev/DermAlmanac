//
//  DetailedTableViewController.swift
//  myAlmanacTemplate
//
//  Created by Sergey Umarov on 31/01/2017.
//  Copyright © 2017 Sergey Umarov. All rights reserved.
//

import Foundation
import UIKit

class DetailedTableViewController: UITableViewController{
    
    var rowNum:Int = 0
    var sourceHref:String?
    var sourceHrefWithPrefix:String?
    var sourceTitle:String?
    var globalURL:String?
    var mySourceString = [String]()
    var cellName = ["Overview",
                    "Presentation",
                    "DDx",
                    "Workup",
                    "Treatment",
                    "Medication",
                    "Follow-up"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = sourceTitle
        readFromFile()
    }
    
    func readFromFile(){
        if let path = Bundle.main.path(forResource: "source", ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                mySourceString = text.components(separatedBy: "\n")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textColor = UIColor.magenta
        //cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = cellName[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detailSegueNew" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let dvc = segue.destination as! ViewController
                    dvc.myURLString = mySourceString[0] + sourceHref! + mySourceString[indexPath.row+2]
                    dvc.myTitleString = sourceTitle
                }
            }
        }
}
