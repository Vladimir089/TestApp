//
//  ViewController.swift
//  TestApp
//
//  Created by Владимир Кацап on 06.03.2024.
//

import UIKit
import Alamofire

var arrayScrollView = ["Все", "analytics", "android", "back_office", "backend", "design"]
var personArray = [(Item, UIImage)]()
var isLoad = false
var imageArray = [UIImage]()


let departmentMappings: [String: DepartamentComponent] = [
    "analytics": .analytics,
    "android": .android,
    "back_office": .back_office,
    "backend": .backend,
    "design": .design,
    "frontend": .frontend,
    "hr": .hr,
    "ios": .ios,
    "management": .management,
    "pr": .pr,
    "qa": .qa,
    "support": .support
]


class ViewController: UIViewController {

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
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        // Проверяем наличие интернет-подключения
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
                        self.mainView?.collectionView?.reloadData()
                    }
                case .failure(_):
                    return
                }
            }
        }
        isLoad = true
    }
    
    
    
}

