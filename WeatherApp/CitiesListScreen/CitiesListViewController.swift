
import UIKit


class CitiesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private let cities: [CityData]
    private var filteredCities: [CityData]?
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.black,
            .font : UIFont(name: "NunitoSans-Light", size: 17) as Any
        ]
        bar.searchTextField.attributedPlaceholder = NSMutableAttributedString.init(string: "Enter city name...", attributes: textAttributes)
        bar.searchTextField.leftView?.tintColor = .black
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let searchHandler: (_: CityData)->()?
    
    private lazy var citiesList: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blur)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        return visualEffect
    }()
    
    // MARK: - Initializers
    
    init(cities: [CityData], searchHandler: @escaping (_: CityData)->()) {
        self.cities = cities
        self.searchHandler = searchHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lificycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        citiesList.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        citiesList.dataSource = self
        citiesList.delegate = self

        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        [blurView, searchBar, citiesList].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            
            citiesList.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            citiesList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            citiesList.widthAnchor.constraint(equalTo: view.widthAnchor),
            citiesList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities?.count ?? cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as? CityCell
        guard let cell = cell else { return CityCell() }
        cell.cityLabel.text = filteredCities?[indexPath.row].name ?? cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchHandler(filteredCities?[indexPath.row] ?? cities[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredCities = nil
            citiesList.reloadData()
        }
        else {
            filteredCities = cities.filter { city in
                city.name.contains(searchText)
            }
            citiesList.reloadData()
        }
    }
}
