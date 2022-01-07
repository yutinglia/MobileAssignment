//
//  DimSumTableViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 4/1/2022.
//

import UIKit

class DimSumTableViewController: UITableViewController {
    
    var dimSums = [DimSum]();

    override func viewDidLoad() {
        super.viewDidLoad()
        getAndShowDimSumData();
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dimSums.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DimSumCell", for: indexPath);
        let dimSum = self.dimSums[indexPath.row];
        var cellContent = cell.defaultContentConfiguration();
        cellContent.text = dimSum.name;
        cell.contentConfiguration = cellContent;
        return cell;
    }
    
    func getAndShowDimSumData(){
        apiGet(path: "dimsum", callback: {
            (dimSums:[DimSum]?) in
            guard let dimSums = dimSums else { print("???"); return; }
            self.dimSums = dimSums;
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        })
    }

}
