//
//  DetailViewController.swift
//  Movie
//
//  Created by Dias on 2/8/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var overviewLabel: UILabel!
    let filledStarImageName = "star.fill", starImageName = "star"
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var markAsFavouriteBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: getImageForMarkAsFavouriteBarButtonItem(), style: .plain, target: self, action: #selector(markAsFavourite))
        return barButtonItem
    }()
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        updateView()
    }
    
    @objc func markAsFavourite() {
        guard let movie = movie, !movie.isFavourite else { return }
        movie.isFavourite = true
        markAsFavouriteBarButtonItem.image = getImageForMarkAsFavouriteBarButtonItem()
    }
    
    func getImageForMarkAsFavouriteBarButtonItem() -> UIImage? {
        guard let movie = movie else { return nil }
        return UIImage(systemName: movie.isFavourite ? filledStarImageName : starImageName)
    }
    
    func updateView() {
        guard let movie = movie else { return }
        overviewLabel.text = movie.overview
        self.title = movie.title
        self.navigationItem.rightBarButtonItem = markAsFavouriteBarButtonItem
        MoviesModel.getTrailer(for: movie, update: setupTrailerView)
    }
    
    func setupTrailerView(_ request: URLRequest) {
        sleep(2)
        webView.load(request)
        self.activityIndicator.stopAnimating()
    }

}
