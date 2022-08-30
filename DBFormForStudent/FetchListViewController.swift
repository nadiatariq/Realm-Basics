//
//  FetchListViewController.swift
//  DBFormForStudent
//
//  Created by sameeltariq on 22/08/2022.
//

import UIKit
import RealmSwift
class FetchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    var getRealmData :  [Student] = []
    // create a variable of array of student type
    var searchGetRealmData :  [Student] = []
    
    var isSearch = false
    var currentSelectedRow = Student()
    var pervious = ViewController()
    
    var searchResults = try! Realm().objects(Student)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var mySearchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
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
        
        return 50.0
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
        var searchResults = try! Realm().
        self.isSearch = true
        //        self.SearchgetRealmData = self.getRealmData.filter({$0.name == searchText})
        
        self.searchGetRealmData = self.getRealmData.filter({$0.name?.lowercased().contains( (mySearchText!.text?.lowercased())! ) as! Bool })
        self.tableView.reloadData()
        
    }
    
    func filterResultsWithSearchString(searchString: String) {
      let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString) // 1
      let scopeIndex = searchController.searchBar.selectedScopeButtonIndex // 2
      let realm = try! Realm()

      switch scopeIndex {
      case 0:
        searchResults = realm.objects(Student).filter(predicate).sorted("name", ascending: true) // 3
      case 1:
        searchResults = realm.objects(Student).filter(predicate).sorted("created", ascending: true) // 4
      default:
        searchResults = realm.objects(Student).filter(predicate) // 5
      }
    }
    func fetchData(){
        let realm = try! Realm()
        getRealmData = Array(realm.objects(Student.self))
        for studentData in getRealmData{
            print("\(studentData.name ?? " " ) and rollNumber is \(studentData.rollNo)")
            
        }
    }
    
    @IBAction func backActionButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

