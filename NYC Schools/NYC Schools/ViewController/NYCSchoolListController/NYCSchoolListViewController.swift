//
//  NYCSchoolListViewController.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import UIKit

protocol NYCSchoolListViewControllerDelegate: AnyObject {
    func checkDetailsfor(_ school: School)
    func showAlert(with error: Error)
}

class NYCSchoolListViewController: UIViewController {

    weak var delegate: NYCSchoolListViewControllerDelegate?
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var schoolList: [School] = []
    
    let schoolListManager: SchoolListManager
    init(schoolListManager: SchoolListManager = SchoolListManager.shared) {
        self.schoolListManager = schoolListManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()
    
    var tableView: UITableView = {
        var tableview = UITableView()
        tableview.register(SchoolTableViewCell.self, forCellReuseIdentifier: "schoolCell")
        tableview.separatorStyle = .none
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "NYC Schools"
        
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        
        spinner.startAnimating()
        updatedSchoolList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func updatedSchoolList() {
        schoolListManager.fetchSchoolList(completionHandler: { [weak self] list in
            guard let strongSelf = self else { return }
            strongSelf.schoolList = list
            DispatchQueue.main.async {
                strongSelf.spinner.stopAnimating()
                strongSelf.tableView.reloadData()
                if list.count == 0 {
                    strongSelf.delegate?.showAlert(with: ServerError.serverError)
                }
            }
        })
    }
}

extension NYCSchoolListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath) as! SchoolTableViewCell
        cell.configure(schoolList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let resturant = schoolList[indexPath.row]
        delegate?.checkDetailsfor(resturant)
    }
}

extension NYCSchoolListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getList(contains: searchText)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
        showDefaultList()
    }
    
    func getList(contains searchText: String) {
        if searchText.isEmpty {
            showDefaultList()
        } else {
            schoolListManager.fetchSchoolList(with: searchText, completionHandler: { [weak self] list in
                guard let strongSelf = self else { return }
                strongSelf.schoolList = list
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            })
        }
    }
    
    func showDefaultList() {
        self.schoolList = schoolListManager.fetchAllSchools()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
