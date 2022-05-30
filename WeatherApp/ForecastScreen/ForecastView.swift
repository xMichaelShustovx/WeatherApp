
import UIKit


class ForecastView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private var weather: Weather?
    
    private var forecastDaysToShow = 3
    private let forecastCellHeight: CGFloat = 80
    lazy private var animatedForecastHeightConstraint: NSLayoutConstraint = tableViewBackground.heightAnchor.constraint(equalToConstant: forecastCellHeight * CGFloat(forecastDaysToShow))
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        table.bounces = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var tableViewBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = .white
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    init(weather: Weather?) {
        self.weather = weather
        super.init(frame: .zero)
        
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setForecastDaysNumber(days: Int) {
        forecastDaysToShow = days
        animatedForecastHeightConstraint.constant = forecastCellHeight * CGFloat(forecastDaysToShow)
        tableView.reloadData()
        layoutIfNeeded()
    }
    
    func setWeather(_ weather: Weather?) {
        self.weather = weather
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        [tableViewBackground, tableView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableViewBackground.topAnchor.constraint(equalTo: self.topAnchor),
            tableViewBackground.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tableViewBackground.widthAnchor.constraint(equalTo: self.widthAnchor),
            tableViewBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            animatedForecastHeightConstraint,
            
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDaysToShow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell
        guard let cell = cell else { return ForecastCell() }
        
        let weatherDescription = weather?.daily[indexPath.row].weather.first?.main ?? ""
        let image = UIImage(named: Constants.weatherForecastImages[weatherDescription] ?? "placeholder")
        
        cell.selectionStyle = .none
        cell.setupCell(date: Date(timeIntervalSince1970: weather?.daily[indexPath.row].dt ?? 0), image: image ?? UIImage(), temperature: String(Int(weather?.daily[indexPath.row].temp.day ?? 0)))
        
        if indexPath.row + 1 == forecastDaysToShow {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        }
        else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return forecastCellHeight
    }
}
