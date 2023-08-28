import UIKit
class MoviewViewController: UIViewController
{
    private var movies: [Movie] = []
    
    /*lazy var startbutton: UIButton={
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("começar", for: .normal)
        button.clipsToBounds=true
        button.layer.cornerRadius=8
        button.backgroundColor = .darkGray
        return button
        
        
    }()*/
    
    private let tableView: UITableView =
    {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
            table.backgroundColor = .black
                table.separatorStyle = .none
        return table
    }()
    private let titleLabel: UILabel =
    {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
    label.textColor = .white
        label.numberOfLines = 0
            label.text = "Filmes populares"
    return label
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        view.backgroundColor  = .darkGray
        
        
    }
    private func setupView()
    {
        view.backgroundColor = .systemBackground
            tableView.dataSource = self
                tableView.delegate = self
        addViewsInHierarchy()
            setupConstraints()
                fetchRemotePopularMovies()
        
        
        
    }
    private func addViewsInHierarchy()
    {
        view.addSubview(titleLabel)
            view.addSubview(tableView)
        
    }
    private func setupConstraints()
    {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        /*
        NSLayoutConstraint.activate([
            startbutton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -125),
        startbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Centraliza horizontalmente
        startbutton.widthAnchor.constraint(equalToConstant: 136), // Defina a largura desejada
        startbutton.heightAnchor.constraint(equalToConstant: 44)
        ])*/
        
    }
    private func fetchRemotePopularMovies()
    {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=2123f7821fc1adc226b8d60b70f445e6&language=pt-BR")!
        
      /*
       test 12
       let url = URL(string: "https://api.themoviedb.org /3/account/ {account_id} /favorite/movies")!*/
        
        
        
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = URLSession.shared.dataTask(with: request)
        { data, _, error in
            if error != nil { return }
            guard let data else { return }
            guard let remoteMovies = try? decoder.decode(TMDBRemoteMovie.self, from: data) else { return }
            self.movies = remoteMovies.results
            DispatchQueue.main.async
            {
            self.tableView.reloadData()
            }
        }
        task.resume()
    }
}
extension MoviewViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = MovieCell()
            let movie = movies[indexPath.row]
                cell.setup(movie: movie)
                    return cell
    }
}
extension MoviewViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let movie = movies[indexPath.row]
            let storyboard = UIStoryboard(name: "Detail", bundle: Bundle(for: DetailViewController.self))
                let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
                    detailViewController.movie = movie
                    navigationController?.pushViewController(detailViewController, animated: true)
    }
}
