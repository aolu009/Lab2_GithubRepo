//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Lu Ao on 10/22/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchByLanguageSwitch: UISwitch!
    @IBOutlet weak var languageList: UITableView!
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var starSliderValue: UISlider!
    
    var defaults = UserDefaults.standard
    
    
    
    let languagesAvary : Array = ["Java","JavaScript","Objective-C","Swift","C","C++","C#","Python","Ruby","Shell"]
    var languageSelected : String?
    var savePressed : Bool?
    var rowLastSeltected : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageList.estimatedRowHeight = 100
        languageList.rowHeight = UITableViewAutomaticDimension
        
        self.searchByLanguageSwitch.isOn = defaults.bool(forKey: "LanguageSwitchStatus")
        self.starSliderValue.value = Float(defaults.integer(forKey: "StarSliderValue"))
        self.starCount.text = defaults.string(forKey: "starCount")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchByLanguageSwitch.isOn == true{
            return languagesAvary.count
        }
        else{
            return 0
        }
            }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSwitch") as! SettingsTableViewCell
        if self.searchByLanguageSwitch.isOn == true{
             cell.textLabel?.text = languagesAvary[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        if self.languageSelected != tableView.cellForRow(at: indexPath)?.textLabel?.text{
            self.languageSelected = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType(rawValue: 3)!
            if let rowLastSelectedNotnil = self.rowLastSeltected{
                tableView.cellForRow(at: rowLastSelectedNotnil)?.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
            }
        self.rowLastSeltected = indexPath
        }
        else{
            self.languageSelected = nil
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
            self.rowLastSeltected = nil
        }
        
    }
    
    
    @IBAction func languageSearchListSwitch(_ sender: AnyObject) {
        languageList.reloadData()
        
    }
    
    @IBAction func starCountSlider(_ sender: AnyObject) {
        let starIntValue = Int(starSliderValue.value)
        self.starCount.text = String(describing: starIntValue)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNVC = segue.destination as! UINavigationController
        let destinationVC = destinationNVC.topViewController as! RepoResultsViewController
        if self.searchByLanguageSwitch.isOn == false {
            self.languageSelected = nil
        }
        if segue.identifier == "Save"{
            self.savePressed = true
            destinationVC.starCount = Int(starSliderValue.value)
            if let languageToFilter = self.languageSelected {
                destinationVC.language = "language:" + languageToFilter
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.savePressed == true{
            defaults.set(self.searchByLanguageSwitch.isOn, forKey: "LanguageSwitchStatus")
            defaults.set(self.starSliderValue.value, forKey: "StarSliderValue")
            defaults.set(self.starCount.text, forKey: "starCount")
            print("Switch is:", self.searchByLanguageSwitch.isOn)
        }
        
    }
}
