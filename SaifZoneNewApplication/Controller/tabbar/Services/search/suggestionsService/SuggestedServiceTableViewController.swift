//
//  SuggestedServiceTableViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/24/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit

class SuggestedServiceTableViewController: UITableViewController {
  
    var searchedService = String() {
        didSet {
            currentService = serviceNamesWith(prefix: searchedService)
            tableView.reloadOnMainThread()
        }
    }
    private var services: [SAIFZONEService] = AppConstants.allServicesArray
    //private var terms: [Term] = Bundle.main.loadJSONFile(named: "terms")
    //private var currentNames = [String]()
    private var currentService = [SAIFZONEService]()
    var didSelect: (String) -> Void = { _ in }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentService.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuggestedServiceTableViewCell
        cell.set(service: currentService[indexPath.row],
                 searchedTerm: searchedService)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(currentService[indexPath.row].Caption)
    }
    /*
    func namesWith(prefix: String) -> [String] {
        return terms
            .filter { $0.name.hasCaseInsensitivePrefix(prefix) }
            .sorted { $0.popularity > $1.popularity }
            .map    { $0.name }
    }*/
    
    
    func serviceNamesWith(prefix: String) -> [SAIFZONEService] {
        return services
            .filter { $0.Caption.contains(prefix) }
            
    }
}
