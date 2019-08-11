//
//  MainTVC.swift
//  DemoSPH
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {

    fileprivate lazy var data = {
        return [Data]()
    }()
    
    var expectedDict = [String : Any]()
    var yearQuarter = [String : [String : String]]()
    var sortedData = [(key: String, value: [String : String])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return yearQuarter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let mobileConsumption = self.sortedData[indexPath.row]
        /*if let year = year {
            let Q1 = Double((year.valueForKeyPath(keyPath: "Q1") as? String)!) ?? 0.0
            let Q2 = Double((year.valueForKeyPath(keyPath: "Q2") as? String)!) ?? 0.0
            let Q3 = Double((year.valueForKeyPath(keyPath: "Q3") as? String)!) ?? 0.0
            let Q4 = Double((year.valueForKeyPath(keyPath: "Q4") as? String)!) ?? 0.0
            
            let totalVal = Q1 + Q2 + Q3 + Q4
            print(totalVal)
        }*/
        var doubleValue :Double = 0.0

        for (_, value) in mobileConsumption.value.enumerated()
            {
                let newValue = Double(value.value)
                if let newValue = newValue {
                    doubleValue = doubleValue + newValue
                }
            }
        
        
        cell.textLabel?.text = self.sortedData[indexPath.row].key
        cell.detailTextLabel?.text = String(doubleValue)
        
        return cell
    }
}

// MARK: - Network Calls

extension MainTVC {
    fileprivate func fetchData() {
        
        let paylaod = [
            "resource_id": Constants.resourceId,
            "limit": Constants.limit
        ] as [String: Any]
        
        Data.fetchData(data: paylaod) {data, error in
            
            if error != nil {
                print(error as Any)
            } else {
                self.data = data!

                var expectInnerDict = [String : String]()
                if let data = data {
                    for i in 0..<data.count{
                        //print(i)
                        //print(data[i].quarter + " : " + data[i].volume_of_mobile_data)
                        let temp = data[i].quarter.split(separator: "-")
                        expectInnerDict.updateValue(data[i].volume_of_mobile_data, forKey: data[i].quarter)
                
//                        yearQuarter.updateValue(String(temp[1]), forKey: String(temp[0]))
                        
                        //yearQuarter[String(temp[0])] = [String(temp[1])]
                        /*
                        if ((yearQuarter[String(temp[0])]) != nil)
                        {
                            print("Already Exists")
                            yearQuarter[String(temp[0])]?.append(String(temp[1]))
                            
                        }
                        else
                        {
                            yearQuarter[String(temp[0])] = [String(temp[1])]
                            print(yearQuarter)
                        }
                        */
                        if ((self.yearQuarter[String(temp[0])]) != nil)
                        {
                            //yearQuarter["String(temp[0])"]?[String(temp(1))] = data[i].volume_of_mobile_data
                            self.yearQuarter[String(temp[0])]?[String(temp[1])] = data[i].volume_of_mobile_data
                        }
                        else
                        {
                            self.yearQuarter[String(temp[0])] = [String(temp[1]) : data[i].volume_of_mobile_data]
                        }
                    }
                    self.sortedData = self.yearQuarter.sorted { $0.0 < $1.0 }
                    print(self.sortedData)
                }
//                print(expectInnerDict)
//                print(self.yearQuarter)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
