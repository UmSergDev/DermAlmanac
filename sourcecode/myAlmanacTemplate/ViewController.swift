//
//  ViewController.swift
//  myAlmanacTemplate
//
//  Created by Sergey Umarov on 31/01/2017.
//  Copyright © 2017 Sergey Umarov. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    
    var myURLString:String?
    var myTitleString:String?
    var myHtml:String?
    var parsedHTML:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.delegate = self
        navigationItem.title = "article"
        //navigationItem.title = myTitleString
        //navigationItem.backBarButtonItem?.title = "back"
        getParse(str: myURLString!)
        myWebView.loadHTMLString(parsedHTML!, baseURL: nil)
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func getParse(str:String){
        // get HTML String from URL
        if let myURL = NSURL(string: str) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                self.myHtml = myHTMLString as String
            } catch {
                print(error)
            }
        }
       
        // Kanna get title for parsed HTML String
        if let doc = HTML(html: myHtml!, encoding: .utf8) {
            //объявляем переменные
            var tmpArr = [String]()
            var i = 0
            var z = 0
            var tmpStr = ""
            parsedHTML = "<h1>"+doc.title!+"</h1>"+"\n\n"
            //получаем массив заголовков для сравнения
            for titleFor in doc.css("h2") {
                tmpArr.append(titleFor.text!)
            }
            //парсим HTML
            for link in doc.css("h2, h3, p, img") {
                tmpStr = link.text!
                if tmpStr.contains("Nothing to disclose"){z = 1}
                if (tmpStr == tmpArr[0] || i>0)&&(z == 0){
                    parsedHTML = parsedHTML! + link.toHTML!
                    i += 1
                }
            }
        }
    }
}

