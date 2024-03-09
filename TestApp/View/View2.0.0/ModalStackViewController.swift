//
//  ModalStackViewController.swift
//  TestApp
//
//  Created by Владимир Кацап on 08.03.2024.
//

import UIKit

var sortedBy = " "

class ModalStackViewController: UIViewController {
    
    var alfButton, birthdayButton: UIButton?
    var alfButtonView, birthdayButtonView: UIView?
    var viewController: ViewController?


    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        settingsView()
        settingsClickButtons()
        
        if sortedBy == "Alf" {
            alfButtonView?.layer.borderWidth = 6
            birthdayButtonView?.layer.borderWidth = 2
        } 
        if sortedBy == "Day" {
            birthdayButtonView?.layer.borderWidth = 6
            alfButtonView?.layer.borderWidth = 2
        }
        
    }
    
    func settingsView() {
        let sortLabel: UILabel = {
            let label = UILabel()
            label.text = "Сортировка"
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            return label
        }()
        view.addSubview(sortLabel)
        sortLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        alfButtonView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1).cgColor
            return view
        }()
        
        alfButton = {
            let button = UIButton(type: .system)
            button.setTitle("       По алфавиту", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .black
            return button
        }()
        
        view.addSubview(alfButton ?? UIButton())
        alfButton?.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalTo(130)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(sortLabel.snp.bottom).inset(-30)
        })
        
        alfButton?.addSubview(alfButtonView ?? UIView())
        alfButtonView?.snp.makeConstraints({ make in
            make.height.width.equalTo(20)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        birthdayButtonView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1).cgColor
            return view
        }()
        
        birthdayButton = {
            let button = UIButton(type: .system)
            button.setTitle("       По дню рождения", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .black
            return button
        }()
        
        view.addSubview(birthdayButton ?? UIButton())
        birthdayButton?.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.width.equalTo(170)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo((alfButton?.snp.bottom)!)
        })
        
        birthdayButton?.addSubview(birthdayButtonView ?? UIView())
        birthdayButtonView?.snp.makeConstraints({ make in
            make.height.width.equalTo(20)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        
        
    }
    
    
    func settingsClickButtons() {
        alfButton?.addTarget(self, action: #selector(clickerdButton(_:)), for: .touchUpInside)
        birthdayButton?.addTarget(self, action: #selector(clickerdButton(_:)), for: .touchUpInside)
    }
    
    
    
    
    
    deinit {
        
        isLoad = false
        viewController?.mainView?.collectionView?.reloadData()
        if let viewController = self.viewController {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                viewController.loadData()
            }
            
        }
    }



    
    @objc func clickerdButton(_ sender: UIButton) {
        if sender == alfButton {
            sortedBy = "Alf"
            UIView.animate(withDuration: 0.15) {
                self.alfButtonView?.layer.borderWidth = 6
                self.birthdayButtonView?.layer.borderWidth = 2
                
            }
            
        } else {
            sortedBy = "Day"
            UIView.animate(withDuration: 0.15) {
                self.birthdayButtonView?.layer.borderWidth = 6
                self.alfButtonView?.layer.borderWidth = 2
            }
        }
        isLoad = false
        viewController?.mainView?.rightTextFieldButton?.imageView?.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
        
        
    }
    
}
