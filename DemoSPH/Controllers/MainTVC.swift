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
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let yearComponent = data[indexPath.row].quarter {
            let strngArray = stringFromDate(year: yearComponent)
            let quarter = strngArray[1]
            let year = strngArray[0]
            cell.textLabel?.text = year +  " "  + quarter
        }
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
                self.data = data!.reversed()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
