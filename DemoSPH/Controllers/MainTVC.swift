//
//  MainTVC.swift
//  DemoSPH
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {
    
    enum Screen {
        enum dataCell: String {
            case identifier = "data-cell"
            case module = "DataCell"
        }
        enum basicCell: String {
            case identifier = "basic-cell"
        }
        enum controllers: String {
            case detail = "DetailTVC"
        }
    }
    
    
    fileprivate lazy var data = {
        return [Data]()
    }()
    
    var expectedDict = [String : Any]()
    var yearQuarter = [String : [String : String]]()
    var sortedData = [(key: String, value: [String : String])]()
    var isValueDecreased = false
    var selectedIndexPath = [IndexPath]() // keep track of indexpath

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerComponents()
        fetchData()
    }
    
    @IBAction func didPullToRefresh(_ sender: UIRefreshControl) {
        
        fetchData()
        sender.endRefreshing()
    }
    
    // MARK: - Private
    fileprivate func registerComponents() {
        let cell = UINib(nibName: Screen.dataCell.module.rawValue, bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: Screen.dataCell.identifier.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return yearQuarter.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.basicCell.identifier.rawValue, for: indexPath)
            cell.textLabel?.text = Constants.introduction
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.dataCell.identifier.rawValue, for: indexPath) as! DataCell
            
            var doubleValue :Double = 0.0
            var previousQuarterValue = 0.0
            let mobileConsumption = self.sortedData[indexPath.row]
            let sortedConsumption = mobileConsumption.value.sorted { $0.0 < $1.0 }
            
            isValueDecreased = false // set flag to check if there is decrease in the consumption in any quarter
            
            for (key, value) in sortedConsumption.enumerated() {
                let newValue = Double(value.value)
                
                if let newValue = newValue {
                    doubleValue = doubleValue + newValue
                    if isValueDecreased != true {
                        if newValue < previousQuarterValue {
                            selectedIndexPath.append(indexPath)

                            print("Decrease in value for: \(mobileConsumption.key) Q\(key)")
                            isValueDecreased = true
                        }
                    }
                    previousQuarterValue = newValue
                }
            }
            cell.titleText.text = self.sortedData[indexPath.row].key
            cell.detailText.text = String(format: "%.5f", doubleValue)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.basicCell.identifier.rawValue, for: indexPath)
            cell.textLabel?.text = ""
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndexPath.contains(indexPath) {
            cell.backgroundColor = .lightGray
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if selectedIndexPath.contains(indexPath) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Screen.controllers.detail.rawValue) as! DetailTVC
            let quarters = self.sortedData[indexPath.row].value
            let year = self.sortedData[indexPath.row].key
            vc.yearQuarterData = quarters
            vc.year = year
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return Constants.headerTitle
        }
        return ""
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
                let alert = UIAlertController(title: Constants.errorTitle,
                                              message: Constants.errorMessage,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                self.present(alert, animated: true)

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
                            //add data to the existing key :- adding either Q1,Q2,Q3 or Q4 to already created year component
                            self.yearQuarter[String(temp[0])]?[String(temp[1])] = data[i].volume_of_mobile_data
                        }
                        else
                        {
                            // create new key with year value.
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
