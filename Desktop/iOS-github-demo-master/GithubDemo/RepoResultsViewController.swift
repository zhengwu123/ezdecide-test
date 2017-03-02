//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(settings: GithubRepoSearchSettings)
    func didCancelSettings()
}

// Main ViewController
class RepoResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SettingsPresentingViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    var repos: [GithubRepo]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
    }
    func didSaveSettings(settings: GithubRepoSearchSettings) {
        self.searchSettings = settings
        doSearch()
    }
    
    func didCancelSettings() {
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            self.repos = newRepos
            for repo in newRepos {
                print(repo)
                
            }
            self.tableView.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.repos ==  nil {
            return 0
        } else {
            return self.repos.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as! TableViewCell
        cell.name.text = self.repos[indexPath.row].name
        cell.author.text = self.repos[indexPath.row].ownerHandle
        let url = self.repos[indexPath.row].ownerAvatarURL! as String
        
       let imageURL = URL(string: url)
        
        cell.avatar.setImageWith(imageURL!)

        cell.stars.text = String(self.repos[indexPath.row].stars!)
        
        cell.name.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell.name.numberOfLines = 0
        cell.forks.text = String(self.repos[indexPath.row].forks! )
        if(self.repos[indexPath.row].repoDescription != nil){
        cell.textField.text = String(self.repos[indexPath.row].repoDescription! )
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! SearchSettingsViewController
        
        vc.delegate = self
        vc.settings = self.searchSettings
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }

    
}

