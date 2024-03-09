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
var isLoad = false
var imageArray = [UIImage]()




class ViewController: UIViewController {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }


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
    }
    
    @objc func showFilter() {
        let modalStackVC = ModalStackViewController()
        modalStackVC.viewController = self // Установите ссылку на экземпляр ViewController
        present(modalStackVC, animated: true)
    }

    
    @objc func refreshPage() {
        loadData()
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
        mainView?.collectionView?.reloadData()
        activityIndicatorView.startAnimating()
        personArray.removeAll()
        loadData()
        sender.endRefreshing()
    }
    
    func loadData() {
        personArray.removeAll()
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        guard let isConnected = NetworkReachabilityManager()?.isReachable, isConnected else {
            self.mainView?.errorView?.alpha = 1
            return
        }

        AF.request("https://stoplight.io/mocks/kode-api/trainee-test/331141861/users", headers: header).responseData { response in
            
            // Проверяем код ответа сервера
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
                    print(1)
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
        // Добавляем "Все" в массив
        arrayScrollView.append("Все")
        for item in data.items {
            uniqueDepartments.insert(item.department) // Добавляем отдел в множество
        }
        
        // Преобразуем множество обратно в массив и добавляем его в arrayScrollView
        arrayScrollView.append(contentsOf: uniqueDepartments.sorted())
        
        // Создаем словарь для соответствия строкам из массива и кейсам перечисления
        
        // Проходим по всем элементам массива
        for index in 0..<arrayScrollView.count {
            let element = arrayScrollView[index]
            // Пробуем найти соответствующий кейс перечисления по строке из массива
            if let departmentCase = departmentMappings[element] {
                // Если нашли соответствие, заменяем элемент в массиве на соответствующий кейс перечисления
                arrayScrollView[index] = departmentCase.rawValue
            } else {
                // Если не нашли соответствие, печатаем сообщение об ошибке
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
                    self.mainView?.collectionView?.reloadData()
                    if sortedBy == "Alf" {
                        
                        personArray.sort { (firstPerson, secondPerson) -> Bool in
                            return firstPerson.0.firstName < secondPerson.0.firstName
                        }
                        
                    }
                    if sortedBy == "Day" {
                        isLoad = false
                        self.loadBirthday()
                        //self.sortBirthday()
                        
                        
                        
                        
                        
                    }

                    
                case .failure(_):
                    return
                }
                
            }
        }
        
       
        isLoad = true
    }
    
    func loadBirthday() {
        
            for index in 0..<personArray.count {
                if let formattedData = self.formatDate(personArray[index].0.birthday) {
                    
                        personArray[index].0.birthday = formattedData
                        print(personArray[index].0.birthday)
                    
                }
            }
        
        isLoad = true
    }
    
    
    

    func sortBirthday() {
        // Преобразуем строки даты рождения в объекты Date
        let currentDate = Date()
        personArray.sort { (firstPerson, secondPerson) -> Bool in
            guard let firstDate = dateFormatter.date(from: firstPerson.0.birthday),
                  let secondDate = dateFormatter.date(from: secondPerson.0.birthday) else {
                return false
            }
            
            // Определяем дни до дня рождения для каждого человека
            let firstDaysUntilBirthday = Calendar.current.dateComponents([.day], from: currentDate, to: firstDate).day ?? 0
            let secondDaysUntilBirthday = Calendar.current.dateComponents([.day], from: currentDate, to: secondDate).day ?? 0
            
            // Если один из элементов имеет отрицательное значение (то есть день рождения в этом году уже прошел),
            // он должен быть помещен в конец массива
            if firstDaysUntilBirthday < 0 {
                return false
            } else if secondDaysUntilBirthday < 0 {
                return true
            }
            
            // Сравниваем дни до дня рождения
            return firstDaysUntilBirthday < secondDaysUntilBirthday
        }
        isLoad = true
    }




    
    
    func formatDate(_ dateString: String) -> String? {
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU") // Устанавливаем локаль на русский
            outputFormatter.dateFormat = "dd MMM"
            return outputFormatter.string(from: date)
        }
        return nil
    }

    
}

