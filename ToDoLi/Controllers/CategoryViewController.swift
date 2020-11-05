//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Анастасия Улитина on 03.11.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNames()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Fatal error")}
        navBar.backgroundColor = UIColor.white
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navBar.tintColor = UIColor.black
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New name", message: "Add new name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
                
            }
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let categories = categoryArray?[indexPath.row] {
        cell.textLabel?.text = categories.name
        cell.backgroundColor = UIColor(hexString: categories.color)
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories.color)!, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data manupulation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
    func loadNames() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
    }
    
}


