//
//  KelasViewController.swift
//  Scavy1
//
//  Created by Adri Nofrianto on 31/05/20.
//  Copyright © 2020 Adri Nofrianto. All rights reserved.
//

import UIKit
import CoreData

class KelasViewController: UITableViewController {

    var locals = [Kelas]()
       
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
  //MARK: - TableView Datasource Methods
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return locals.count
         
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "KelasCell", for: indexPath)
         
         cell.textLabel?.text = locals[indexPath.row].name
         
         return cell
         
     }
    
    //MARK: - TableView Delegate Methods
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToPertemuan", sender: self)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destinationVC = segue.destination as! PertemuanViewController
           
           if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedKelas = locals[indexPath.row]
           }
       }

    //MARK: - Data Manipulation Methods
       
       func saveCategories() {
           do {
               try context.save()
           } catch {
               print("Error saving category \(error)")
           }
           
           tableView.reloadData()
           
       }
       
       func loadCategories() {
           
           let request : NSFetchRequest<Kelas> = Kelas.fetchRequest()
           
           do{
               locals = try context.fetch(request)
           } catch {
               print("Error loading categories \(error)")
           }
          
           tableView.reloadData()
           
       }
     //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Tambah Kelas Baru", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Tambah", style: .default) { (action) in
                   
                   let newKelas = Kelas(context: self.context)
                   newKelas.name = textField.text!
                   
                   self.locals.append(newKelas)
                   
                 self.saveCategories()
        }
   
    alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Tambah kelas baru"
        }
        
        present(alert, animated: true, completion: nil)
        
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
    
    // this method handles row deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            locals.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            if editingStyle == .insert {
                
            }
        }
    }
}
