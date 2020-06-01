//
//  PertemuanViewController.swift
//  Scavy1
//
//  Created by Adri Nofrianto on 30/05/20.
//  Copyright © 2020 Adri Nofrianto. All rights reserved.
//



import UIKit
import CoreData

class PertemuanViewController: UITableViewController {
    
    var pertemuanArray = [Pertemuan]()
    
    var selectedKelas : Kelas? {
        didSet{
            loadPertemuans()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    

    //MARK:-TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pertemuanArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PertemuanCell", for: indexPath)
        
        let pertemuan = pertemuanArray[indexPath.row]
        
        cell.textLabel?.text = pertemuan.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = pertemuan.done ? .checkmark : .none
        
        return cell
    }
    
   
    //MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
        //context.delete(pertemuanArray[indexPath.row])
        //pertemuanArray.remove(at: indexPath.row)
        
        pertemuanArray[indexPath.row].done = !pertemuanArray[indexPath.row].done
        
        savePertemuan()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:- Add New Item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
            
            let alert = UIAlertController(title: "Tambah Pertemuan Baru", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Tambah Pertemuan", style: .default) { (action) in
                //what will happen once the user clicks the Add Item button on our UIAlert
                
                
                let newPertemuan = Pertemuan(context: self.context)
                newPertemuan.title = textField.text!
                newPertemuan.done = false
                newPertemuan.parentKelas = self.selectedKelas
                self.pertemuanArray.append(newPertemuan)
                
                self.savePertemuan()
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Tambah Pertemuan Baru"
                textField = alertTextField
                
            }
            
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
    
    //MARK - Model Manipulation
    
    func savePertemuan() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadPertemuans(with request: NSFetchRequest<Pertemuan> = Pertemuan.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let kelasPredicate = NSPredicate(format: "parentKelas.name MATCHES %@", selectedKelas!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [kelasPredicate, addtionalPredicate])
        } else {
            request.predicate = kelasPredicate
        }

        
        do {
            pertemuanArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    //MARK:- Hapus dan ubah

      override func tableView(_ tableView: UITableView,
                      leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
       {
           let editAction = UIContextualAction(style: .normal, title:  "Ubah", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                   success(true)
               })
      editAction.backgroundColor = .blue

               return UISwipeActionsConfiguration(actions: [editAction])
       }

      override func tableView(_ tableView: UITableView,
                      trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
       {
           let deleteAction = UIContextualAction(style: .normal, title:  "Hapus", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
               success(true)
           })
           deleteAction.backgroundColor = .red

           return UISwipeActionsConfiguration(actions: [deleteAction])
       }



}



