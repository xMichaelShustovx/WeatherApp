//
//  DetailedView.swift
//  WeatherApp
//
//  Created by Michael Shustov on 10.03.2022.
//

import UIKit

class DetailedView: UIView {

    // MARK: - Properties
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "NunitoSans-Regular", size: 40)
        label.textColor = .black
        label.text = "--"
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "NunitoSans-Regular", size: 60)
        label.textColor = .black
        label.text = "--º"
        return label
    }()
    
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "NunitoSans-Light", size: 17)
        label.textColor = .black
        label.text = "Pressure: -- mm Hg\nHumidity: -- %"
        return label
    }()
    
    lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupUI(city: City?, weather: Weather?) {
        if let city = city {
            cityLabel.text = city.name
        }
        else if let weather = weather {
            var cityName = weather.timezone
            if let index = cityName.firstIndex(of: "/") {
                cityName.removeSubrange(...index)
                cityName = cityName.replacingOccurrences(of: "_", with: " ")
                cityLabel.text = cityName
            } else {
                cityLabel.text = cityName
            }
        }
        else {
            cityLabel.text = "--"
        }
        
        if let weather = weather {
            tempLabel.text = "\(Int(weather.current.temp))º"
            detailsLabel.text = "Pressure: \(weather.current.pressure) mm Hg\nHumidity: \(weather.current.humidity) %"
            weatherImage.image = UIImage(named: Constants.weatherForecastImages[weather.current.weather.first?.main ?? ""] ?? "placeholder")
        }
        else {
            tempLabel.text = "--º"
            detailsLabel.text = "Pressure: -- mm Hg\nHumidity: -- %"
            weatherImage.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubviews() {
        [backgroundView, stackView, weatherImage].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            weatherImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weatherImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            weatherImage.widthAnchor.constraint(equalTo: weatherImage.heightAnchor),
            weatherImage.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 10),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        [UIView(), cityLabel, tempLabel, detailsLabel, UIView()].forEach { stackView.addArrangedSubview($0) }
    }
}
