//
//  FetchListViewController.swift
//  DBFormForStudent
//
//  Created by sameeltariq on 22/08/2022.
//

import UIKit
import RealmSwift
class FetchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var mySearchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var getRealmData :  [Student] = []
    var searchGetRealmData = [Student]()
    var isSearch = false
    var currentSelectedRow = Student()
    var pervious = ViewController()
    var orignalData = [Student]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        tableView.reloadData()
    
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func fetchData(){
        let realm = try! Realm()
        getRealmData = Array(realm.objects(Student.self))
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch {
            return searchGetRealmData.count
        }
        else{
            return getRealmData.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FetchDataTableViewCell
        //
        
        var fetchAndShow = Student()
        
        
        if isSearch{
            fetchAndShow = searchGetRealmData[indexPath.row]
            
        }
        else{
            
            fetchAndShow = getRealmData[indexPath.row]
            
        }
        
        cell.nameLabel.text = fetchAndShow.name
        cell.rollNoLabel.text = "\(fetchAndShow.rollNo)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return `false` if you do not want the
        //  specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let realm = try! Realm()
        if editingStyle == .delete {
            
            if isSearch{
                let recordForDeletion = searchGetRealmData[indexPath.row]
                do {
                    try realm.write {
                        realm.delete(recordForDeletion)
                    }
                } catch {
                    print("Error deleting course: \(error)")
                }
                // Delete the row from the data source
                searchGetRealmData.remove(at: indexPath.row)
            }
            
            else{
                let recordForDeletion = getRealmData[indexPath.row]
                do {
                    try realm.write {
                        realm.delete(recordForDeletion)
                    }
                } catch {
                    print("Error deleting course: \(error)")
                }
                // Delete the row from the data source
                getRealmData.remove(at: indexPath.row)
            }
            
            
            // Then, delete the row from the table itself
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the list was selected: \(indexPath.row)")
        
        let sendBack =  getRealmData[indexPath.row]
        print(sendBack)
        self.currentSelectedRow = sendBack
        
        self.dismiss(animated: true) {
            
            self.pervious.callbackData(sendBack)
        }
        
    }
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if mySearchText.text == nil || mySearchText.text == "" {
            
                        isSearch = false
                        view.endEditing(true)
                        tableView.reloadData()
                    }else{
                        isSearch = true
                        let resultPredicate = NSPredicate(format: "name CONTAINS[c] %@",  searchText)
                            self.searchGetRealmData = getRealmData.filter{resultPredicate.evaluate(with: $0)}
                        tableView.reloadData()
                        }
   }
    @IBAction func backActionButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
      }
 
    }




    //        self.SearchgetRealmData = self.getRealmData.filter({$0.name == searchText})
    
    //        let formateString = "name contains[cd] %@"
    //        var filterList = searchGetRealmData.filter { NSPredicate(format: formateString, searchText).evaluate(with: $0)} as NSArray

    
    



