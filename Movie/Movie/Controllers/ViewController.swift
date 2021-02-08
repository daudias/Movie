//
//  ViewController.swift
//  Movie
//
//  Created by Dias on 2/8/21.
//

import UIKit

class ViewController: UITableViewController {
    var movies: [Movie] { MoviesModel.movies }
    var activityIndicator = UIActivityIndicatorView(style: .large)

    @IBAction func favouritesButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let favouritesTableViewController = storyboard.instantiateViewController(identifier: "FavouritesTableViewController") as? FavouritesTableViewController else { return }
        show(favouritesTableViewController, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        MoviesModel.getMovies(reloadData: reloadData)
    }
    
    func reloadData(isSuccess: Bool) {
        sleep(2)
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        if movies.isEmpty || !isSuccess {
            let alert = UIAlertController(title: "Error", message: "Can not download", preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.dateLabel.text = movies[indexPath.row].date
        cell.titleLabel.text = movies[indexPath.row].title
        MoviesModel.setPoster(for: movies[indexPath.row], update: { data in
            cell.posterImageView.image = UIImage(data: data)
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.movie = movies[indexPath.row]
        show(detailViewController, sender: nil)
    }
}
