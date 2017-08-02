//
//  LevelTableViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  LevelTableViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 20/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

var allLevelObjectArr = [Category]()

protocol SendLevelDelegate {
    func sendCourseLevel(text:String)
    func populateDataLevel(firstTime: Bool)
    func storeCourseLevel(courseLevelArray2 : [Category])
}

class LevelTableViewController: UITableViewController {
    
    var delegate: SendLevelDelegate?
    
    var level : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (level.count != 0){
            CategoryDataManager.firstTimeLevel = false
        }
        else{
            CategoryDataManager.firstTimeLevel = true
        }
        print("ARRAY SIZE: \(level.count)")
        let days=Calendar.current.dateComponents([.day], from: CategoryDataManager.lastDateUpdateLevel, to: Date())
        if (days.day != 0 ){
            CategoryDataManager.startOfTheDayLevel = true
        } else {
            CategoryDataManager.startOfTheDayLevel = false
        }
        
        print("LAST DATE UPDATE: \(CategoryDataManager.lastDateUpdateLevel)")
        print("DAYS DIFFERENCE : \(days.day!)")
        print("FIRST TIME : \(CategoryDataManager.firstTimeLevel)")
        
        print(CategoryDataManager.startOfTheDayLevel)
        
        if (CategoryDataManager.startOfTheDayLevel || CategoryDataManager.firstTimeLevel){
            
            CategoryDataManager.getCourseLevel(heading: "Level", limit: "50", onComplete: {
                (data : [Category]) in
                self.delegate?.storeCourseLevel(courseLevelArray2: data)
                self.delegate?.populateDataLevel(firstTime: CategoryDataManager.firstTimeLevel)
                
                for var i in 0 ..< data.count {
                    
                    var lvl = Category()
                    lvl.displayOrder = data[i].displayOrder
                    lvl.name = data[i].name
                    lvl.heading = data[i].heading
                    lvl.heading = data[i].heading
                    self.level.append(lvl)
                    //   allLevelObjectArr.append(lvl)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        } else {
            tableView.reloadData()
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return level.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = level[indexPath.row].name
        
        //  _ = navigationController?.popViewController(animated: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        
        print(currentCell.textLabel!.text!)
        self.delegate?.sendCourseLevel(text: currentCell.textLabel!.text!)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     } */
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
