//
//  SearchViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import MusadoraKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

    // Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }

    // Properties
    var searchResults: MusicItemCollection<Song> = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            Task {
                    await searchSong(searchText: searchText)
                    searchBar.resignFirstResponder()
            }
        }
    }
}
