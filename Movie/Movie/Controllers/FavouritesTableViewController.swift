//
//  FavouritesTableViewController.swift
//  Movie
//
//  Created by Dias on 2/8/21.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    
    var movies: [Movie] { MoviesModel.getFavouriteMovies() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as! FavouriteTableViewCell
        cell.titleLabel.text = movies[indexPath.row].title
        return cell
    }
}
