//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Michael Shustov on 10.03.2022.
//

import UIKit

class ForecastCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ForecastCell"

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "NunitoSans-ExtraLight", size: 15)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "NunitoSans-ExtraLight", size: 17)
        label.text = "--º"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(date: Date, image: UIImage, temperature: String) {
        dateLabel.text = date.dayOfWeek()
        weatherImageView.image = image
        tempLabel.text = "\(temperature)º"
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        backgroundColor = .clear

        [dateLabel, weatherImageView, tempLabel].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            dateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            weatherImageView.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 10),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100),
            
            tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tempLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            tempLabel.leftAnchor.constraint(equalTo: weatherImageView.rightAnchor, constant: 10),
            tempLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
