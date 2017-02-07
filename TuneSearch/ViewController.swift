//
//  ViewController.swift
//  TuneSearch
//
//  Created by Valerie Greer on 2/1/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let hostName = "https://itunes.apple.com/search?term="
    var reachability :Reachability?
    var searchArray = [String]()
    
    @IBOutlet var searchTextField   :UITextField!
    @IBOutlet var searchButton      :UIButton!
    @IBOutlet var searchTableView   :UITableView!
    
    //MARK: - TableView Methods
    
    func updateScreen() {
        searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        return cell
    }
    
    
    //MARK: - Core Methods
    
    func parseJson(data: Data) {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            //print("JSON:\(jsonResult)")
            let searchArray = jsonResult["results"] as! [[String:Any]]
            for searchDictionary in searchArray {
                print("Artist Name:\(searchDictionary["artistName"])")
                print("Album Name:\(searchDictionary["collectionCensoredName"])")
                print("Song Name:\(searchDictionary["trackCensoredName"])")
            }
        }catch {
            print("JSON Parsing Error")
        }
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    func getFile(filename: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlString = "\(hostName)\(filename)"
        //print("\(urlString)")
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let receivedData = data else {
                print("No Data")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            if receivedData.count > 0 && error == nil {
                print("Received Data:\(receivedData)")
                let dataString = String.init(data: receivedData, encoding: .utf8)
                //print("Got Data String:\(dataString!)")
                self.parseJson(data: receivedData)
            } else {
                print("Got Data of Length 0")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        task.resume()
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction func getFilePressed(button: UIButton) {
//        guard let reach = reachability else {
//            return
//        }
//        if reach.isReachable {
            //getFile(filename: "/classfiles/iOS_URL_Class_Get_File.txt")
            //getFile(filename: "/classfiles/flavors.json")
            let searchTerm = searchTextField.text! + "&attribute=artistTerm"
            getFile(filename: searchTerm)
//        } else {
//            print("Host Not Reachable. Turn on the Internet")
//        }
        
    }
    
    //MARK: - Reachability Methods
    
//    func setupReachability(hostName: String) {
//        reachability = Reachability(hostname: hostName)
//        reachability!.whenReachable = { reachability in
//            DispatchQueue.main.async {
//                self.updatedLabel(reachable: true, reachability: reachability)
//            }
//        }
//        reachability!.whenUnreachable = { reachability in
//            
//        }
//    }
//    
//    func startReachability() {
//        do {
//            try reachability!.startNotifier()
//        } catch {
//            networkStatusLabel.text = "Unable to Start Notifier"
//            networkStatusLabel.textColor = .red
//            return
//        }
//    }
//    
//    func updatedLabel(reachable: Bool, reachability: Reachability) {
//        if reachable {
//            if reachability.isReachableViaWiFi {
//                networkStatusLabel.textColor = .green
//            } else {
//                networkStatusLabel.textColor = .blue
//            }
//        } else {
//            networkStatusLabel.textColor = .red
//        }
//        networkStatusLabel.text = reachability.currentReachabilityString
//    }
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupReachability(hostName: hostName)
        //startReachability()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

