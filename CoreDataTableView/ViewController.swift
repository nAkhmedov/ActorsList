//
//  ViewController.swift
//  CoreDataTableView
//
//  Created by NAVRUZ on 11/2/17.
//  Copyright © 2017 NAVRUZ. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var actors: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Actor")
        
        do {
            actors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Actors List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New name",
                                      message: "Add a new actor",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cacelAction = UIAlertAction(title: "Cancel",
                                        style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cacelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Actor", in: managedContext)!
        let actor = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        actor.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            actors.append(actor)
        } catch let error as NSError {
            print("Coulnt save. \(error), \(error.userInfo)")
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actor = actors[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = actor.value(forKey: "name") as? String
        
        return cell
    }
}

