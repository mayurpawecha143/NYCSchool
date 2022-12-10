//
//  SchoolTableViewCell.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/8/22.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var baseView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var address: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func addViews() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
        
        baseView.addSubview(name)
        baseView.addSubview(address)
        self.addSubview(baseView)
        
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1 ),
            baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            
            name.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 3),
            name.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -3),
            
            address.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            address.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 3),
            address.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -3),
            address.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(_ school: School) {
        name.text = school.schoolName
        let addressText = "\(school.primaryAddressLine1), \(school.city), \(school.stateCode), \(school.zip)"
        address.text = addressText
    }
}
