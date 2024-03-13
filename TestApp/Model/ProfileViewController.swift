//
//  ProfileViewController.swift
//  TestApp
//
//  Created by Владимир Кацап on 12.03.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileImage: UIImage?
    var firstName: String?
    var lastName: String?
    var userTag: String?
    var otdel: String?
    var phone: String?
    var dateBirthday: String?
    
    var phoneLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoad = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backItem?.title = " "
    }
    
    
    func createInterface() {
        let viewTop: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
            return view
        }()
        view.addSubview(viewTop)
        viewTop.snp.makeConstraints { make in
            make.height.equalTo(280)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let imageView: UIImageView = {
            let imageView = UIImageView(image: profileImage)
            imageView.layer.cornerRadius = 52
            imageView.clipsToBounds = true
            return imageView
        }()
        viewTop.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(104)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        let lastFirstName: UILabel = {
            let label = UILabel()
            label.text = "\((firstName ?? " ") as String) \((lastName ?? " ") as String)"
            label.font = .systemFont(ofSize: 24, weight: .bold)
            return label
        }()
        viewTop.addSubview(lastFirstName)
        lastFirstName.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-20)
            make.centerX.equalTo(imageView.snp.centerX).offset(-10)
        }
        
        let userTagLabel: UILabel = {
            let label = UILabel()
            label.text = "\((userTag ?? " ") as String)"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
            return label
        }()
        viewTop.addSubview(userTagLabel)
        userTagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(lastFirstName.snp.centerY).offset(2)
            make.left.equalTo(lastFirstName.snp.right).inset(-5)
        }
        
        let otdelLabel: UILabel = {
            let label = UILabel()
            label.text = "\((otdel ?? " ") as String)"
            label.font = .systemFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
            return label
        }()
        viewTop.addSubview(otdelLabel)
        otdelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lastFirstName.snp.bottom).inset(-12)
        }
        
        var agePerson = 0
        
        if let age = calculateAge(birthDate: dateBirthday) {
            print("Возраст: \(age) лет")
            agePerson = age
            
        } else {
            print("Невозможно вычислить возраст")
            agePerson =  99
        }

        
        let viewBirthday: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            
            let image = UIImageView(image: UIImage(named: "star"))
            view.addSubview(image)
            image.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }
            let formattedDate = formatBirthdayDate(dateBirthday)
            let dateBirthdayLabel = UILabel()
            dateBirthdayLabel.text = formattedDate
            dateBirthdayLabel.font = .systemFont(ofSize: 16, weight: .medium)
            view.addSubview(dateBirthdayLabel)
            dateBirthdayLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(image.snp.right).inset(-15)
            }
            
            let ageLabel: UILabel = {
                let label = UILabel()
                let lastDigit = agePerson % 10
                if lastDigit == 1 && agePerson > 10 {
                    label.text = "\(agePerson) год"
                } else if (lastDigit == 2 || lastDigit == 3 || lastDigit == 4) && agePerson > 14 {
                    label.text = "\(agePerson) года"
                } else {
                    label.text = "\(agePerson) лет"
                }
                
                label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
                label.font = .systemFont(ofSize: 16, weight: .medium)
                return label
            }()
            view.addSubview(ageLabel)
            ageLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
            
            return view
        }()
        view.addSubview(viewBirthday)
        viewBirthday.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(viewTop.snp.bottom).inset(-10)
        }
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray5
            return view
        }()
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.left.right.equalTo(viewBirthday)
            make.height.equalTo(1)
            make.top.equalTo(viewBirthday.snp.bottom)
        }
        
        let phoneView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            
            let image = UIImageView(image: UIImage(named: "phone"))
            view.addSubview(image)
            image.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }
            
            phoneLabel = UILabel()
            phoneLabel!.text = "\((phone ?? " ") as String)"
            phoneLabel!.font = .systemFont(ofSize: 16, weight: .medium)
            view.addSubview(phoneLabel!)
            
            phoneLabel!.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(image.snp.right).inset(-15)
            }
            
            return view
        }()
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePhoneTap(_:)))
        phoneView.addGestureRecognizer(tapGestureRecognizer)
        phoneView.isUserInteractionEnabled = true

        
        
    }
    
    @objc func handlePhoneTap(_ sender: UITapGestureRecognizer) {
        guard let phoneNumber = phoneLabel!.text, !phoneNumber.isEmpty else {
            return
        }
        
        // Открыть приложение телефона с номером телефона
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func formatBirthdayDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func calculateAge(birthDate: String?) -> Int? {
        guard let birthDateString = birthDate else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateOfBirth = dateFormatter.date(from: birthDateString) {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
            return ageComponents.year
        } else {
            return nil
        }
    }


    
}
