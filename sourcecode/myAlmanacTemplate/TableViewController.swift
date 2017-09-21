//
//  TableViewController.swift
//  myAlmanacTemplate
//
//  Created by Sergey Umarov on 31/01/2017.
//  Copyright © 2017 Sergey Umarov. All rights reserved.
//

import UIKit
import Kanna


class TableViewController: UITableViewController {
    
    var myHtml:String?
    var myTitleArray = [String]()
    var myHrefArray = [String]()
    var sortArray = [Int]()
    var rowsInSection = [Int]()
    var mySortedDict = [Int:Array<String>]()
    var mySourceString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readFromFile()
        getSourcefromUrl(urlStr: mySourceString[0]+mySourceString[1])
        getSort(arr: myHrefArray)

    }
    
    func getSourcefromUrl(urlStr:String){
        
        //get HTML String from URL - start
        if let myURL = NSURL(string: urlStr) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                self.myHtml = myHTMLString as String
            } catch {
                print(error)
            }
        }
        //get HTML String from URL - end
        
        //Kanna - start
        if let doc = HTML(html: myHtml!, encoding: .utf8) {
            var i = 0
            var z = 0
            var tmpStr:String

            for link in doc.css("h4, li") {
                    tmpStr = link.toHTML!
                if tmpStr.contains("SPECIALTY SITES"){i = 1}
                if tmpStr.contains("h4"){z = 1}
                if i == 0 && z == 1 {
                    myHrefArray.append(link.toHTML!)
                    myTitleArray.append(link.text!)
                }
            }
        }
        //Kanna - end

    }
    
    func getSort(arr:Array<String>){
        //
        for i in 0..<arr.count{
            if arr[i].contains("h4"){
                sortArray.append(i)
            }
        }
        //
        for i in 1..<sortArray.count{
            rowsInSection.append(sortArray[i]-sortArray[(i-1)]-1)
        }
        rowsInSection.append(myTitleArray.count - sortArray.last!)
        //
        var z = 0
        var tmpArr = [String]()
        for i in 0..<sortArray.count-1{
            tmpArr.append(contentsOf: myTitleArray[(sortArray[i]+1)...(sortArray[i+1]-1)])
            mySortedDict[i] = tmpArr
            tmpArr.removeAll()
            z += 1
        }
        tmpArr.append(contentsOf: myTitleArray[(sortArray.last)!...(myTitleArray.count-1)])
        mySortedDict[z] = tmpArr
    }
    
    func readFromFile(){
        if let path = Bundle.main.path(forResource: "source", ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                mySourceString = text.components(separatedBy: "\n")
                }
            }
        }
  
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return headerArrayTitle[section]
        
        var tmpTitle = [String]()
        for i in 0..<sortArray.count{
            tmpTitle.append(myTitleArray[sortArray[i]])
        }
        //print(tmpTitle)
        return tmpTitle[section]
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortArray.count
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSection[section]
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textColor = UIColor.magenta
        //cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = mySortedDict[indexPath.section]?[indexPath.row] ?? "row\(indexPath.row)"
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if segue.identifier == "detailSegue" {
                    if let indexPath = tableView.indexPathForSelectedRow {
                       let dvc = segue.destination as! DetailedTableViewController
                        //блок для обработки и подготовки передачи ссылки
                        let tmpStr = mySortedDict[indexPath.section]?[indexPath.row]
                        var tmpString = ""
                        for item in myHrefArray{
                            if item.contains(tmpStr!){
                                tmpString = item
                            }
                        }
                        var tmpRef = tmpString.components(separatedBy: "<li><a href=\"")
                        let ref:String = tmpRef[1]
                        var tmpTitle = ref.components(separatedBy: "\">")
                        let prehref = tmpTitle[0]
                        let href = String(prehref.substring(to: prehref.index(prehref.endIndex, offsetBy:-9)))
                        //
                        dvc.sourceHref = href
                        dvc.sourceTitle = mySortedDict[indexPath.section]?[indexPath.row]
                    }
                }
            }

}
