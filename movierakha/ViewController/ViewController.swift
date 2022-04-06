//
//  ViewController.swift
//  movierakha
//
//  Created by LIMA 1 on 05/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tblMovies: UITableView!
    
    private var moviesList: [MovieData] = []
    private var selectedMovie: MovieData?
    private var selectedCategory: MovieCategory = .popular

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_favorite_filled"), style: .plain, target: self, action: #selector(self.onTapFavoritePage))
        tblMovies.dataSource = self
        tblMovies.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesCell")
        tblMovies.delegate = self
        self.loadMoviesData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            if let destVC = segue.destination as? MovieDetailViewController {
                destVC.movie = self.selectedMovie
            }
        }
    }

    @objc func onTapFavoritePage() {
        self.performSegue(withIdentifier: "segueToFavorite", sender: self)
    }
    
    @IBAction func onTapCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Popular", style: .default , handler:{ alert in
            self.selectedCategory = .popular
            self.loadMoviesData()
        }))
        
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default , handler:{ alert in
            self.selectedCategory = .topRated
            self.loadMoviesData()
        }))
    
        alert.addAction(UIAlertAction(title: "Now Playing", style: .default , handler:{ alert in
            self.selectedCategory = .nowPlaying
            self.loadMoviesData()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))

        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: nil)
    }
    
    func loadMoviesData() {
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        ApiHelper.getMoviesList(category: selectedCategory) { result, moviesData in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                switch result {
                case .success:
                    let data = moviesData?.results
                    if(data?.count == 0) {
                        self.showAlertDialog(title: "Data Not Found", message: "Please try another category")
                    } else {
                        self.moviesList.removeAll()
                        self.moviesList.append(contentsOf: data!)
                        self.tblMovies.reloadData()
                    }
                    break
                case .failed(let errMessage):
                    self.showAlertDialog(title: "Oops", message: errMessage.message)
                    break
                case .none:
                    break
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as? MoviesTableViewCell
        {
            cell.tag = indexPath.row
            
            let movies = moviesList[indexPath.row]
            cell.lblTitle.text = movies.title
            cell.lblReleaseDate.text = "Released at \(movies.releaseDate ?? "-")"
            cell.lblDesc.text = movies.overview
            
            cell.imgMovie.downloaded(from: ApiHelper.generateImageUrl(image: movies.backdropPath ?? ""), contentMode: .scaleAspectFill)
            cell.imgMovie.rounded(cornerRadius: 8.0)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMovie = moviesList[indexPath.row]
        self.performSegue(withIdentifier: "segueToDetail", sender: self)
        self.tblMovies.deselectRow(at: indexPath, animated: true)
    }
}
