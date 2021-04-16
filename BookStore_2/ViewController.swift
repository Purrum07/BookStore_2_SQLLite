//
//  ViewController.swift
//  BookStore_2
//
//  Created by user192467 on 4/6/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var myTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    
    
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedObjectContext) as! Book
        book.title = "My Book" + String(loadBooks().count)
        
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            NSLog("My Error %@", error)
        }
        
        myTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
    }
    
    func loadBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        //MARK:Challenge 2 - Ascending Order
        let titleSort: NSSortDescriptor = NSSortDescriptor(key:"title", ascending: true)
        fetchRequest.sortDescriptors = [titleSort]
        
        var result: [Book] = []
        
        do{
            result = try managedObjectContext.fetch(fetchRequest)
        } catch{
            NSLog("My Error: %@", error as NSError)
        }
        
        
        return result
    }
    //MARK:Challenge 1 - Remove book
    @IBAction func removeBook(_ sender: UIBarButtonItem) {
        let result = loadBooks()
        if let indexPath = myTableView.indexPathForSelectedRow {
            let selectedBook : Book = result[indexPath.row]
            deleteBook(book: selectedBook)
        }
        
        myTableView.reloadData()
    }
    
    func deleteBook(book: Book){
        managedObjectContext.delete(book)
        
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            NSLog("My Error %@", error)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadBooks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        else{
            return UITableViewCell()
        }
        
        let book: Book = loadBooks()[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }
    


}


