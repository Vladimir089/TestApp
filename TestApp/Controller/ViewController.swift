//
//  ViewController.swift
//  TestApp
//
//  Created by Владимир Кацап on 06.03.2024.
//

import UIKit
import Alamofire

var arrayScrollView = ["Все", "Аналитика", "Android", "Бэк-офис", "Backend"]
var personArray = [(Item, UIImage)]()
var copyPersonArray = [(Item, UIImage)]()
var isLoad = false
var imageArray = [UIImage]()

class ViewController: UIViewController {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    var mainView: Skeleton?
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = Skeleton()
        self.view = mainView
        refreshCollection()
        mainView?.refreshButton?.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        mainView?.rightTextFieldButton?.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        mainView?.viewController = self
    }
    
    @objc func showFilter() {
        let modalStackVC = ModalStackViewController()
        modalStackVC.viewController = self
        present(modalStackVC, animated: true)
    }
    
    func selectButton(_ button: UIButton) {
        selectedButton?.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
                
            }
        }
        selectedButton?.setTitleColor(.systemGray3, for: .normal)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .blue
        underlineView.tag = 999
        button.addSubview(underlineView)
        button.setTitleColor(.black, for: .normal)
        
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(button.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(button.titleLabel?.intrinsicContentSize.width ?? 0)
        }
        
        selectedButton = button
        if selectedButton?.titleLabel?.text == "Все" {
            personArray = copyPersonArray 
            print(personArray.count)
        } else {
            personArray = copyPersonArray.filter { $0.0.department == selectedButton?.titleLabel?.text }
        }
        mainView?.collectionView?.reloadData()
    }
    
    
    @objc func refreshPage() {
        loadData()
        copyPersonArray.removeAll()
    }
    
    func refreshCollection() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        mainView?.collectionView?.refreshControl = refreshControl
        mainView?.collectionView?.addSubview(activityIndicatorView)
        let midX = mainView?.collectionView?.bounds.midX ?? 0.0
        activityIndicatorView.center = CGPoint(x: midX, y: 50)
        activityIndicatorView.hidesWhenStopped = true
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        isLoad = false
        activityIndicatorView.startAnimating()
        personArray.removeAll()
        copyPersonArray.removeAll()
        loadData()
        sender.endRefreshing()
    }
    
    func loadData() {
        personArray.removeAll()
        copyPersonArray.removeAll()
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        guard let isConnected = NetworkReachabilityManager()?.isReachable, isConnected else {
            self.mainView?.errorView?.alpha = 1
            return
        }
        
        AF.request("https://stoplight.io/mocks/kode-api/trainee-test/331141861/users", headers: header).responseData { response in
            guard let statusCode = response.response?.statusCode, statusCode == 200 else {
                UIView.animate(withDuration: 0.3) {
                    self.mainView?.errorView?.alpha = 1
                }
                return
            }
            
            switch response.result {
            case .success(let data):
                self.mainView?.errorView?.alpha = 0
                if let person = try? JSONDecoder().decode(Person.self, from: data) {
                    self.reloadScrollView(data: person)
                    self.activityIndicatorView.stopAnimating()
                }
            case .failure(_):
                return
            }
        }
    }
    
    func reloadScrollView(data: Person) {
        var uniqueDepartments = Set<String>()
        arrayScrollView.removeAll()
        arrayScrollView.append("Все")
        for item in data.items {
            uniqueDepartments.insert(item.department)
        }
        
        arrayScrollView.append(contentsOf: uniqueDepartments.sorted())
        for index in 0..<arrayScrollView.count {
            let element = arrayScrollView[index]
            if let departmentCase = departmentMappings[element] {
                arrayScrollView[index] = departmentCase.rawValue
            } else {
                print("Не удалось найти соответствие для значения: \(element)")
            }
        }
        mainView?.reloadScrollView()
        
        for i in data.items {
            AF.request(i.avatarURL, method: .get).responseData { response in
                switch response.result {
                case .success(let data):
                    
                    if let image = UIImage(data: data) {
                        personArray.append((i,image))
                    }
                    
                    if sortedBy == "Alf" {
                        personArray.sort { (firstPerson, secondPerson) -> Bool in
                            return firstPerson.0.firstName < secondPerson.0.firstName
                        }
                    }
                    
                    let dateFormatterForDisplay: DateFormatter = {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM"
                        return formatter
                    }()
                    
                    if sortedBy == "Day" {
                        
                        let semaphore = DispatchSemaphore(value: 1)
                        isLoad = false
                        self.mainView?.collectionView?.reloadData()
                        // Выполнение сортировки
                        DispatchQueue.global().sync {
                            semaphore.wait()
                            personArray.sort { (firstPerson, secondPerson) -> Bool in
                                if let firstDate = self.dateFormatter.date(from: firstPerson.0.birthday),
                                   let secondDate = self.dateFormatter.date(from: secondPerson.0.birthday) {
                                    let firstDateString = dateFormatterForDisplay.string(from: firstDate)
                                    let secondDateString = dateFormatterForDisplay.string(from: secondDate)
                                    return firstDateString < secondDateString
                                }
                                
                                return true
                            }
                            semaphore.signal()
                        }
                        
                        // Обновление формата даты
                        DispatchQueue.global().sync {
                            semaphore.wait()
                            for index in 0..<personArray.count {
                                let originalDate = personArray[index].0.birthday
                                if let date = self.dateFormatter.date(from: originalDate) {
                                    let formattedDate = dateFormatterForDisplay.string(from: date)
                                    personArray[index].0.birthday = formattedDate
                                }
                            }
                            semaphore.signal()
                        }
                    }
                    
                    for index in 0..<personArray.count {
                        let element = personArray[index].0.department
                        if let departmentCase = departmentMappings[element] {
                            personArray[index].0.department = departmentCase.rawValue
                        }
                    }
                    
                    copyPersonArray = personArray
                    isLoad = true
                    self.mainView?.collectionView?.reloadData()
                case .failure(_):
                    return
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

