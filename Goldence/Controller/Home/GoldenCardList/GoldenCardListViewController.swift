//
//  GoldenCardListViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/23.
//

import UIKit

class GoldenCardListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var bookTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "AddGoldenCardCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "GoldenCardCell", for: indexPath)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewGoldence" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? NewGoldenceViewController {
                    destinationVC.bookTitle = bookTitle
                }
            }
        }
    }
}
