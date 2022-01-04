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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dimSums.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DimSumCell", for: indexPath);
        let dimSum = self.dimSums[indexPath.row];
        var cellContent = cell.defaultContentConfiguration();
        cellContent.text = dimSum.name;
        return cell;
    }
    
    func getAndShowDimSumData(){
        if let url = URL(string:"http://localhost:3000/api/dimsum"){
            var urlReq = URLRequest(url: url)
            urlReq.httpMethod = "GET";
            let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
                data, res, err in
                guard let data = data else{
                    return;
                }
                self.dimSums.removeAll();
                let decoder = JSONDecoder();
                if let dimSums = try? decoder.decode([DimSum].self, from: data){
                    self.dimSums = dimSums;
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                    }
                }else{
                    return;
                }
            })
            task.resume();
        }
    }

}
