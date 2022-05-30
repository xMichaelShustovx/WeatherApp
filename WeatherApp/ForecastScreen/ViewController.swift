import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherModelProtocol {
    
    // MARK: - Properties
    
    private let model = WeatherModel()
    
    private var isBlurred = false {
        didSet {
            UIView.animate(withDuration: 0.7) {
                self.blurView.alpha = self.isBlurred ? 1 : 0
            }
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sun")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var detailedView = DetailedView()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["3 days", "7 days"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .lightGray
        control.tintColor = .red
        control.addTarget(self, action: #selector(forecastDaysDidChange(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var segmentedControlBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.backgroundColor = .white
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var forecastView = ForecastView(weather: model.weather)
    
    private lazy var chooseCityButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(presentCitiesList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blur)
        visualEffect.alpha = 0
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        return visualEffect
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        model.delegate = self
        model.getWeatherUsingUserLocation()
        isBlurred = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.flashScrollIndicators()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        [imageView, scrollView, chooseCityButton, blurView].forEach { self.view.addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            chooseCityButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            chooseCityButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            chooseCityButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        [detailedView, segmentedControlBackground, segmentedControl, forecastView].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            detailedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            detailedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            detailedView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -80),
            detailedView.heightAnchor.constraint(equalToConstant: 300),
            
            segmentedControl.topAnchor.constraint(equalTo: detailedView.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -80),
            
            segmentedControlBackground.heightAnchor.constraint(equalTo: segmentedControl.heightAnchor),
            segmentedControlBackground.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor),
            segmentedControlBackground.centerXAnchor.constraint(equalTo: segmentedControl.centerXAnchor),
            segmentedControlBackground.centerYAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            
            forecastView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            forecastView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forecastView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -80),
            forecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc
    private func forecastDaysDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:

            scrollView.scrollToTop()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.forecastView.setForecastDaysNumber(days: 3)
            }
            
        case 1:
            forecastView.setForecastDaysNumber(days: 7)
        default:
            scrollView.scrollToTop()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.forecastView.setForecastDaysNumber(days: 3)
            }
        }
    }
    
    @objc
    private func presentCitiesList() {
        present(CitiesListViewController(cities: model.cities ?? [], searchHandler: searchHandler(cityData:)), animated: true, completion: nil)
    }
    
    private func searchHandler(cityData: CityData) {
        model.city = nil
        model.weather = nil
        model.getWeatherUsingLocation(location: (cityData.coord.lat, cityData.coord.lon))
    }

    // MARK: - WeatherModelDelegate Methods
    
    func cityRetrieved(city: City?) {
        DispatchQueue.main.async {
            self.isBlurred = false
            self.detailedView.setupUI(city: self.model.city, weather: self.model.weather)
        }
    }
    
    func weatherRetrieved(weather: Weather?) {
        DispatchQueue.main.async {
            self.isBlurred = false
            self.forecastView.setWeather(self.model.weather)
            self.imageView.image = UIImage(named: Constants.weatherImages[weather?.current.weather.first?.main ?? ""] ?? "")
        }
    }
    
    func locationTrackingDenied() {
        DispatchQueue.main.async {
            self.isBlurred = false
            self.presentCitiesList()
        }
    }
}
