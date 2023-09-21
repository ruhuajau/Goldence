//
//  AddPageViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/14.
//

import UIKit

class SelectShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            // Configure the cell for the first section
            cell = tableView.dequeueReusableCell(withIdentifier: "NewShelfTableViewCell", for: indexPath)
            // Customize this cell for the first section
        } else {
            // Configure the cell for the second section
            cell = tableView.dequeueReusableCell(withIdentifier: "AddPageTableViewCell", for: indexPath)
            // Customize this cell for the second section
        }
        
        return cell
    }
}
