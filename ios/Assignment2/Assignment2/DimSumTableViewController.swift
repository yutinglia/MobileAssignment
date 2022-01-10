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
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged);
        refreshData(self);
    }
    
    @objc func refreshData(_ sender: AnyObject){
        getAllDimSum(handler: dimSumsHandler);
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? DimSumDetailViewController {
            guard let index = self.tableView.indexPathForSelectedRow else{
                return;
            }
            des.dimSim = dimSums[index.row];
        }
    }
    
    func dimSumsHandler(dimSims:[DimSum]){
        self.dimSums = dimSims;
        DispatchQueue.main.async {
            self.tableView.reloadData();
            self.tableView.refreshControl?.endRefreshing();
        };
    }

}
