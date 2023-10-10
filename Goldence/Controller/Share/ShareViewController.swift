//
//  ShareViewController.swift
//  Goldence
//
//  Created by 趙如華 on 2023/9/26.
//

import UIKit
import Firebase

class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var publicNotes: [GoldenNote] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetchPublicNotes()
        if let navigationBar = navigationController?.navigationBar {
            // Customize the title color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as? ShareTableViewCell {
            let note = publicNotes[indexPath.row]
            // Configure your cell with the note's data (e.g., title, content)
            cell.shareTitle.text = "——\(note.title)"
            cell.shareTextView.text = note.cardContent
            return cell
        } else {
            // Handle the case where cell is nil (though it should not happen if you registered the correct cell identifier)
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicNotes.count
    }
    
    func fetchPublicNotes() {
        let notesCollection = db.collection("note")
        
        // Query notes where isPublic is true
        notesCollection.whereField("is_public", isEqualTo: true).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching public notes: \(error.localizedDescription)")
                return
            }
            
            // Clear existing public notes
            self.publicNotes.removeAll()
            
            // Iterate through the documents and populate the publicNotes array
            for document in querySnapshot!.documents {
                let data = document.data()
                let title = data["title"] as? String ?? ""
                let cardContent = data["cardContent"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                let isPublic = data["is_public"] as? Bool ?? false
                
                let note = GoldenNote(id: id, bookTitle: "", type: "", title: title, cardContent: cardContent, isPublic: isPublic)
                
                self.publicNotes.append(note)
            }
            
            // Reload the table view with the public notes
            self.tableView.reloadData()
            
        }
    }
}
