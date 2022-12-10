//
//  CustomViews.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/9/22.
//

import Foundation
import UIKit

func createLabel(_ font: UIFont = UIFont.systemFont(ofSize: 16), _ color: UIColor = .black) -> UILabel {
    let label = UILabel()
    label.textAlignment = .left
    label.textColor = color
    label.font = font
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}

func createButton(with image: UIImage?) -> UIButton {
    let button = UIButton(type: .custom)
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}
