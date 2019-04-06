//
//  ViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var db : Firestore!
    var travels = [Travel]()
    var listener : ListenerRegistration!
    var travelToPass : Travel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let backgroundImage = UIImage(named: AppImages.Background)
        let backgroundView = UIImageView(image: backgroundImage)
        backgroundView.alpha = 0.4
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.backgroundView = backgroundView
        tableView.register(UINib(nibName: Identifiers.TravelCell, bundle: nil), forCellReuseIdentifier: Identifiers.TravelCell)
        
        fetchCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            presentAuthController()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    @objc func refreshCollection() {
        fetchCollection()
    }
    
    func fetchCollection() {
        let collectionRef = db.collection(Collections.Travels)
        
        listener = collectionRef.addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            self.travels.removeAll()
            
            for document in documents {
                let data = document.data()
                let travel = Travel.init(data: data)
                self.travels.append(travel)
            }
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func presentAuthController() {
        
        let storyboard = UIStoryboard(name: Storyboard.AuthStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.AuthViewController)
        
        present(controller, animated: true, completion: nil)
        
    }

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            presentAuthController()
            
        } catch {
            debugPrint(error)
            
            Auth.auth().handleAuthError(error: error, vc: self)
        }
        
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.TravelCell, for: indexPath) as? TravelCell {
            
            cell.configureCell(travel: travels[indexPath.row])
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        travelToPass = travels[indexPath.row]
        
        performSegue(withIdentifier: Identifiers.travelDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let travelDetails = segue.destination as? TravelDetailsViewController {
            travelDetails.selectedTravel = travelToPass
        }
    }
    
}
