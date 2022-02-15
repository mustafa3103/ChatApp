//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Mustafa on 24.01.2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var messeageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //We hide the back button top of the left on screen.
        title = K.appName
        
        navigationItem.hidesBackButton = true
        loadMessages()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        messages = []
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField, descending: false)
            .addSnapshotListener { [self] querySnaphot, error in
                self.messages = []
                if let e = error {
                    print("Error was occured while taking data from database. Error is: \(e.localizedDescription)")
                }else {
                    if let snapshotDocuments = querySnaphot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let sender = data[K.FStore.senderField] as? String, let messeageBody =
                                
                                data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: sender, body: messeageBody)
                                
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
    }
    
    //We send data to the Firebase in this function
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if messeageTextField.text != "" {
            
            if let messageBody = messeageTextField.text, let messageSender = Auth.auth().currentUser?.email {
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]) { error in
                    if error != nil {
                        print("Error was occured while sending data to the Firebase. Error is: \(error!.localizedDescription)")
                    }else if !messageBody.isEmpty || messageBody.count > 0 || messageBody != ""{
                        //Area which we send our data to Firebase
                        
                        DispatchQueue.main.async {
                            self.messeageTextField.text = ""
                        }
                        
                        
                        
                    }
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            //Current user
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else {
            //Another user
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        return cell
    }
}

