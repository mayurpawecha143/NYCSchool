//
//  AppCoordinator.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {

    let navigationController: UINavigationController
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func setNYCSchoolListController() {
        let controller = NYCSchoolListViewController()
        controller.delegate = self
        self.navigationController.pushViewController(controller, animated: false)
    }
    
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style:.default))
        self.navigationController.present(alert, animated: true, completion: nil)
    }
}

extension AppCoordinator: NYCSchoolListViewControllerDelegate {
    func checkDetailsfor(_ school: School) {
        let controller = NYCSchoolDetailViewController(school: school)
        self.navigationController.pushViewController(controller, animated: true)
    }
}
