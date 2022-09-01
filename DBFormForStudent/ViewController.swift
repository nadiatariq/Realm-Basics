//
//  ViewController.swift
//  DBFormForStudent
//
//  Created by sameeltariq on 19/08/2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,ViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rollNoField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var sendBack : Student?
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        nextButton.layer.cornerRadius = 30
    }
//    func callbackData(_ value:Student){
//        self.isUpdate = true
//        self.nameField.text = value.name
//        self.rollNoField.text = "\(value.rollNo)"
//        self.sendBack = value
//    }
    func doSomethingWith(value: Student) {
        self.nameField.text = value.name
        self.rollNoField.text = "\(value.rollNo)"
        self.sendBack = value
    }
    @IBAction func submitAction(_ sender: Any) {
        
        if isUpdate{
            let realm = try! Realm()
            
            let student = realm.objects(Student.self).where {
                $0.ID == self.sendBack?.ID ?? ""
            }.first!
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            do {
                try realm.write({
                    student.rollNo = Int(self.rollNoField.text ?? "0")  ?? 0
                    student.name = self.nameField.text ??  ""
                })
            }
            catch{
                print(error)
            }
        }
        else{
       
            let realm = try! Realm()
            
//            let myPrimaryKey = 0
//
//
//            let specificPerson = realm.object(ofType: Student.self, forPrimaryKey: myPrimaryKey)
           
            let studentInfo = Student()
            

            
            if  let abcd = nameField.text{
                studentInfo.name = abcd
                print(abcd)
            }
            
            if let rollNumber = rollNoField.text{
                studentInfo.rollNo = Int(rollNumber) ?? 0
                print(rollNumber)
            }
            
            studentInfo.ID = UUID().uuidString
            do {
                try realm.write({
                    
                    realm.add(studentInfo, update: .all)
                    
                })
            }
            catch{
                print(error)
            }
        }
        
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        //  performSegue(withIdentifier: "nextButton", sender: self)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FetchListViewController") as! FetchListViewController
//        vc.pervious = self
        self.present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
}


