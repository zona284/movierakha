//
//  MovieDetailViewController.swift
//  movierakha
//
//  Created by LIMA 1 on 06/04/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet var tblDetail: UITableView!
    
    private lazy var favProvider: FavoriteMovieProvider = { return FavoriteMovieProvider() }()
    
    var movie: MovieData?
    private var reviews: [ReviewData] = []
    private var isFavorited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = movie?.title ?? "Detail"
        tblDetail.register(UINib(nibName: "MovieInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieInfoCell")
        tblDetail.register(UINib(nibName: "HeaderReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderReviewCell")
        tblDetail.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        tblDetail.register(UINib(nibName: "EmptyDataTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyCell")
        tblDetail.dataSource = self
        tblDetail.delegate = self
        self.loadReviewsData()
        self.checkFavorite()
    }
    
    func loadReviewsData() {
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        ApiHelper.getReviews(movieId: movie?.id ?? 0) { result, reviewsData in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                switch result {
                case .success:
                    let data = reviewsData?.results
                    self.reviews.removeAll()
                    self.reviews.append(contentsOf: data!)
                    self.tblDetail.reloadSections(IndexSet(integer: 2), with: .none)
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

    func checkFavorite() {
        favProvider.checkIsFavorite(id: movie?.id ?? 0) { id in
            DispatchQueue.main.async {
                if id {
                    self.isFavorited = true
                } else {
                    self.isFavorited = false
                }
                self.tblDetail.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func onTapFavoriteButton() {
        if let movie = self.movie, movie != nil {
            if(isFavorited) {
                favProvider.deleteFavorite(movie.id ?? 0) {
                    DispatchQueue.main.async {
                        self.checkFavorite()
                    }
                }
            } else {
                favProvider.addToFavorite(movie) {
                    DispatchQueue.main.async {
                        self.checkFavorite()
                    }
                }
            }
        }
    }

}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || reviews.count == 0 {
            return 1
        } else {
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return setMovieInfoView(tableView, indexPath)
        } else if indexPath.section == 1 {
            return setReviewHeaderView(tableView, indexPath)
        } else {
            return setReviewsView(tableView, indexPath)
        }
        
    }
    
    func setMovieInfoView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as? MovieInfoTableViewCell
        {
            cell.lblTitle.text = movie?.title
            cell.lblReleaseDate.text = "Released at \(movie?.releaseDate ?? "-")"
            cell.lblDesc.text = movie?.overview
            
            cell.imgMovie.downloaded(from: ApiHelper.generateImageUrl(image: movie?.backdropPath ?? ""), contentMode: .scaleAspectFit)
            cell.imgMovie.rounded(cornerRadius: 8.0)
            
            if self.isFavorited {
                cell.btnFav.setImage(UIImage(named: "ic_favorite_filled")?.withTintColor(UIColor.red), for: .normal)
            } else {
                cell.btnFav.setImage(UIImage(named: "ic_favorite_outline")?.withTintColor(UIColor.red), for: .normal)
            }
            
            cell.btnFav.addTarget(self, action: #selector(onTapFavoriteButton), for: .touchUpInside)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func setReviewHeaderView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderReviewCell", for: indexPath) as? HeaderReviewTableViewCell
        {
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func setReviewsView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewTableViewCell, reviews.count > 0
        {
            let review = reviews[indexPath.row]
            cell.lblUsername.text = review.author
            cell.lblContent.text = review.content?.htmlToString
            cell.lblPostDate.text = review.createdAt?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.convertToString(format: "yyyy-MM-dd HH:mm")
            return cell
        } else {
            let empty = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyDataTableViewCell ?? UITableViewCell()
            return empty
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2) {
            let review = reviews[indexPath.row]
            if let url = URL(string: review.url ?? "") {
                UIApplication.shared.open(url)
            }
            self.tblDetail.deselectRow(at: indexPath, animated: true)
        }
    }
}
