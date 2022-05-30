
import UIKit

class CityCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "CityCell"
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.font = UIFont(name: "NunitoSans-Light", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            cityLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
