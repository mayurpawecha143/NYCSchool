//
//  NYCSchoolDetailViewController.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/8/22.
//

import UIKit

class NYCSchoolDetailViewController: UIViewController {

    var school: School
    let schoolListManager: SchoolListManager
    init(school: School, schoolListManager: SchoolListManager = SchoolListManager.shared) {
        self.school = school
        self.schoolListManager = schoolListManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var name: UILabel = {
        let font = UIFont.boldSystemFont(ofSize: 30)
        let label = createLabel(font)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var phone: UIButton = {
        return createButton(with: UIImage(named: "phone"))
    }()
    
    var website: UIButton = {
        return createButton(with: UIImage(named: "www"))
    }()
    
    var email: UIButton = {
        return createButton(with:UIImage(named: "email"))
    }()
    
    var highlights: UILabel = {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let label = createLabel(font)
        label.text = "Highlights"
        return label
    }()
    
    var numberOfStudents: UILabel = {
        let label = createLabel()
        return label
    }()
    
    var studentsTakenSAT: UILabel = {
        let label = createLabel()
        return label
    }()
    
    var readingScore: UILabel = {
        let label = createLabel()
        return label
    }()
    
    var mathScore: UILabel = {
        let label = createLabel()
        return label
    }()
    
    var writingScore: UILabel = {
        let label = createLabel()
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let label = createLabel(font)
        label.text = "Description"
        return label
    }()
    
    var descriptionText: UILabel = {
        let label = createLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addViews()
        requestDetails()
        updateDetails()
    }
    
    func requestDetails() {
        schoolListManager.fetchSchoolSAT(for: school.dbn, completionHandler: { newSchool in
            guard let school = newSchool else { return }
            self.school = school
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.updateDetails()
                strongSelf.setViewLayout()
            }
        })
    }
    
    func updateDetails() {
        self.name.text = school.schoolName
        email.isHidden = school.schoolEmail != nil ? true : false
        numberOfStudents.text = "Total students: \(school.totalStudents)"
        
        if let studentsSAT = school.numOfSatTestTakers {
            studentsTakenSAT.text = "Student taken SAT: \(studentsSAT)"
            studentsTakenSAT.isHidden = false
        } else {
            studentsTakenSAT.isHidden = true
        }
        
        if let reading = school.satCriticalReadingAvgScore {
            readingScore.text = "Average reading score: \(reading)"
            readingScore.isHidden = false
        } else {
            readingScore.isHidden = true
        }
        
        if let writing = school.satWritingAvgScore {
            writingScore.text = "Average writing score: \(writing)"
            writingScore.isHidden = false
        } else {
            writingScore.isHidden = true
        }
        
        if let mathscore = school.satMathAvgScore {
            mathScore.text = "Average math score: \(mathscore)"
            mathScore.isHidden = false
        } else {
            mathScore.isHidden = true
        }
        
        descriptionText.text = school.overviewParagraph
    }
    
    @objc func phoneTapped() {
        // Add call function
    }
    
    @objc func websiteTapped() {
        // open website
    }
    
    @objc func emailTapped() {
        // create email
    }
    
    func addViews() {
        self.view.addSubview(name)
        self.view.addSubview(phone)
        self.view.addSubview(website)
        self.view.addSubview(email)
        
        self.view.addSubview(highlights)
        self.view.addSubview(numberOfStudents)
        self.view.addSubview(studentsTakenSAT)
        self.view.addSubview(readingScore)
        self.view.addSubview(writingScore)
        self.view.addSubview(mathScore)
        
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(descriptionText)
        
        phone.addTarget(self, action: #selector(phoneTapped), for: .touchUpInside)
        website.addTarget(self, action: #selector(websiteTapped), for: .touchUpInside)
        email.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)
        
        setViewLayout()
    }
    
    func setViewLayout() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            name.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            name.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            phone.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            phone.heightAnchor.constraint(equalToConstant: 40),
            phone.widthAnchor.constraint(equalToConstant: 40),
            
            website.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            website.trailingAnchor.constraint(equalTo: phone.leadingAnchor, constant: -5),
            website.heightAnchor.constraint(equalToConstant: 40),
            website.widthAnchor.constraint(equalToConstant: 40),
            
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            email.trailingAnchor.constraint(equalTo: website.leadingAnchor, constant: -5),
            email.heightAnchor.constraint(equalToConstant: 40),
            email.widthAnchor.constraint(equalToConstant: 40),
            
            highlights.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10),
            highlights.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            highlights.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            numberOfStudents.topAnchor.constraint(equalTo: highlights.bottomAnchor, constant: 2),
            numberOfStudents.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            numberOfStudents.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            studentsTakenSAT.topAnchor.constraint(equalTo: numberOfStudents.bottomAnchor),
            studentsTakenSAT.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            studentsTakenSAT.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            readingScore.topAnchor.constraint(equalTo: studentsTakenSAT.bottomAnchor),
            readingScore.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            readingScore.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            writingScore.topAnchor.constraint(equalTo: readingScore.bottomAnchor),
            writingScore.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            writingScore.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            mathScore.topAnchor.constraint(equalTo: writingScore.bottomAnchor),
            mathScore.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            mathScore.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: mathScore.bottomAnchor, constant:  10),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            
            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            descriptionText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            descriptionText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
        ])
    }
}
