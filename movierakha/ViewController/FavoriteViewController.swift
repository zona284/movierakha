//
//  FavoriteViewController.swift
//  movierakha
//
//  Created by LIMA 1 on 06/04/22.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet var tblFavorite: UITableView!
    
    private lazy var favProvider: FavoriteMovieProvider = { return FavoriteMovieProvider() }()
    private var moviesList: [MovieData] = []
    private var selectedMovie: MovieData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblFavorite.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavMoviesCell")
        tblFavorite.dataSource = self
        tblFavorite.delegate = self
        self.loadFavData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            if let destVC = segue.destination as? MovieDetailViewController {
                destVC.movie = self.selectedMovie
            }
        }
    }
    
    func loadFavData(){
        favProvider.getAllFavorite { data in
            DispatchQueue.main.async {
                self.moviesList.removeAll()
                self.moviesList = data
                self.tblFavorite.reloadData()
            }
        }
    }

}


extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavMoviesCell", for: indexPath) as? MoviesTableViewCell
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
        self.tblFavorite.deselectRow(at: indexPath, animated: true)
    }
}
