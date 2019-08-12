//
//  DetailTVC.swift
//  DemoSPH
//
//  Created by Vaishu on 12/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import UIKit

class DetailTVC: UITableViewController {
    
    enum Screen {
        enum dataCell: String {
            case identifier = "data-cell"
            case module = "DataCell"
        }
        enum basicCell: String {
            case identifier = "detail-cell"
        }
    }
    
    var year = String()
    var yearQuarterData = [String : String]()
    var isValueDecreased = false
    var selectedRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerComponents()
        
        navigationItem.title = "\(year) mobile data consumption"
    }
    
    // MARK: - Private
    
    fileprivate func registerComponents() {
        let cell = UINib(nibName: Screen.dataCell.module.rawValue, bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: Screen.dataCell.identifier.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return yearQuarterData.count
        }
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.basicCell.identifier.rawValue, for: indexPath)
            cell.textLabel?.text = "Mobile data consumption decreased for the following quarter"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.dataCell.identifier.rawValue, for: indexPath) as! DataCell
            
            var dataConsumption = yearQuarterData.sorted(by: { $0.0 < $1.0 })
            var doubleValue :Double = 0.0
            var previousQuarterValue = 0.0
            
            for (key , value) in dataConsumption.enumerated() {
                let newValue = Double(value.value)
                
                if let newValue = newValue {
                    doubleValue = doubleValue + newValue
                    if isValueDecreased != true {
                        if newValue < previousQuarterValue {
                            isValueDecreased = true
                            self.selectedRow = key
                        }
                    }
                    previousQuarterValue = newValue
                }
            }
            
            let volume = Double(dataConsumption[indexPath.row].value)
            cell.titleText.text = dataConsumption[indexPath.row].key
            cell.detailText.text = String(format: "%.5f", volume ?? 0.0)
            
            if indexPath.row == selectedRow {
                cell.backgroundColor = .lightGray
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Screen.basicCell.identifier.rawValue, for: indexPath)
            cell.textLabel?.text = ""
            
            return cell
        }
    }
}
