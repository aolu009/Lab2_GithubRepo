//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    
    @IBOutlet var contentTableView: UITableView!
    var repos: [GithubRepo]!
    var starCount : Int? = 0
    var language : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        contentTableView.estimatedRowHeight = 300
        contentTableView.rowHeight = UITableViewAutomaticDimension
        // Initialize the UISearchBar
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchSettings.minStars = self.starCount!
        searchSettings.searchLanguage = self.language!
        // Perform the first search when the view controller first loads
        doSearch()
        
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
        // Print out new repo
            
            //Store returned repo in repo property
            self.repos = newRepos
            
            for repo in newRepos {
                print(repo)
            }
            self.contentTableView.reloadData()
            
            // Print the returned repositories to the output window
            
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    // Tableview Delegate function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let rowNumber = self.repos?.count{
            return rowNumber
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Declare vars for extracting data
        // Name, Avatar, owner loggin, score, forks_count, description, 
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! contentCell
        cell.nameLabel?.text = self.repos[indexPath.row].name
        cell.userNameLabel?.text = self.repos[indexPath.row].ownerHandle
        cell.languageLabel?.text = self.repos[indexPath.row].language
        cell.descriptionLabel?.text = self.repos[indexPath.row].repoDescription
        let url = self.repos[indexPath.row].ownerAvatarURL
        cell.avatarImageView.setImageWith(URL(string:url!)!)
        cell.forkLabel?.text = String(describing: self.repos[indexPath.row].forks!)
        cell.starLabel?.text = String(describing: self.repos[indexPath.row].stars!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }


}


// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            searchSettings.searchString = searchText
        }
        else{
            searchSettings.searchString = " "
        }
        
        searchBar.resignFirstResponder()
        doSearch()
    }
}
