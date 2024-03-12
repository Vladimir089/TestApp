//
//  Skeleton.swift
//  TestApp
//
//  Created by Владимир Кацап on 06.03.2024.
//

import UIKit
import SnapKit

var selectedButton: UIButton?

class Skeleton: UIView {
    
    var viewController: ViewController?
    var errorView: UIView?
    var collectionView: PersonsCollectionView?
    var refreshButton, closeTextFieldButton, clearTextFieldButton: UIButton?
    var searchTextField: UITextField?
    var leftTextFieldButton, rightTextFieldButton: UIButton?
    var specScrollView: UIScrollView?
    
    let leftContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        isUserInteractionEnabled = true
        topView()
        searchTextField?.isUserInteractionEnabled = true
        fillScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func topView() {
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(140)
        }
        
        leftTextFieldButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            button.tintColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
            return button
        }()
        
        rightTextFieldButton = {
            let button = UIButton()
            if let image = UIImage(named: "rightText") {
                let redImage = image.withRenderingMode(.alwaysTemplate)
                button.setImage(redImage, for: .normal)
                button.tintColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
            }
            return button
        }()
        
        closeTextFieldButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "xmark"), for: .normal)
            button.alpha = 0
            button.tintColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
            return button
        }()
        
        
        searchTextField = {
            let field = UITextField()
            field.placeholder = "Введите имя, тег, почту..."
            field.font = .systemFont(ofSize: 15, weight: .medium)
            field.layer.cornerRadius = 15
            field.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
            field.delegate = self
            
            leftContainerView.addSubview(leftTextFieldButton!)
            rightContainerView.addSubview(rightTextFieldButton!)
            
            
            let inset: CGFloat = 10
            leftTextFieldButton?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 8))
            }
            
            rightTextFieldButton?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: inset))
            }
            
          
            
            field.leftView = leftContainerView
            field.rightView = rightContainerView
            field.rightViewMode = .always
            field.leftViewMode = .always
            
            
            
            
            return field
        }()
        
        view.addSubview(searchTextField ?? UITextField())
        searchTextField?.snp.makeConstraints({ make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(60)
        })
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray6
            return view
        }()
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        specScrollView = {
            let scroll = UIScrollView()
            scroll.isScrollEnabled = true
            scroll.showsHorizontalScrollIndicator = false
            return scroll
        }()
        
        view.addSubview(specScrollView ?? UIScrollView())
        specScrollView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(separatorView.snp.bottom)
            make.top.equalTo((searchTextField?.snp.bottom)!).inset(-5)
        })
        
        collectionView = PersonsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        addSubview(collectionView ?? UIView())
        collectionView?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        })
        
        //MARK: -Error view
        
        errorView = {
            let view = UIView()
            view.backgroundColor = .white
            view.isUserInteractionEnabled = true
            view.alpha = 0
            return view
        }()
        
        addSubview(errorView ?? UIView())
        errorView?.snp.makeConstraints({ make in
            make.height.width.top.left.right.bottom.equalToSuperview()
        })
        
        let errorImageView: UIImageView = {
            let image = UIImage(named: "flyingSpaucer")
            let imageView = UIImageView(image: image)
            return imageView
        }()
        
        errorView?.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { make in
            make.height.width.equalTo(56)
            make.centerX.centerY.equalToSuperview()
        }
        
        let errorOneLabel: UILabel = {
            let label = UILabel()
            label.text = "Какой-то сверхразум все сломал"
            label.font = .systemFont(ofSize: 17, weight: .medium)
            return label
        }()
        
        errorView?.addSubview(errorOneLabel)
        errorOneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorImageView.snp.bottom)
        }
        
        let errorTwoLabel: UILabel = {
            let label = UILabel()
            label.text = "Постараемся быстро починить"
            label.font = .systemFont(ofSize: 16, weight: .light)
            label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
            return label
        }()
        
        errorView?.addSubview(errorTwoLabel)
        errorTwoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorOneLabel.snp.bottom).inset(-2)
        }
        
        refreshButton = {
            let button = UIButton(type: .system)
            button.setTitle("Попробовать снова", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
            return button
        }()
        
        errorView?.addSubview(refreshButton ?? UIButton())
        refreshButton?.snp.makeConstraints({ make in
            make.width.equalTo(343)
            make.height.equalTo(20)
            make.top.equalTo(errorTwoLabel.snp.bottom).inset(-2)
            make.centerX.equalToSuperview()
        })
        
        clearTextFieldButton = {
            let button = UIButton(type: .system)
            button.setTitle("Отмена", for: .normal)
            button.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            return button
        }()
        view.addSubview(clearTextFieldButton!)
        clearTextFieldButton?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.height.equalTo(18)
            make.centerY.equalTo(searchTextField!.snp.centerY)
            make.left.equalTo(searchTextField!.snp.right).inset(-20)
        })
        
        
    }
    
    func fillScrollView() {

        var previousButton: UIButton?
        for (index, item) in arrayScrollView.enumerated() {
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.setTitleColor(.systemGray3, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            specScrollView?.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).inset(-20)
                } else {
                    make.left.equalToSuperview().inset(16)
                }
                if index == arrayScrollView.count - 1 {
                    make.right.equalToSuperview().inset(16)
                }
            }
            previousButton = button
        }
        
        if let firstButton = specScrollView?.subviews.first as? UIButton {
            if let viewController = viewController {
                viewController.selectButton(firstButton)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let viewController = viewController {
            viewController.selectButton(sender)
        }
    }

    
    func reloadScrollView() {
        specScrollView?.subviews.forEach { $0.removeFromSuperview() }
        fillScrollView()
    }
}


extension Skeleton: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2) { [self] in
            for subview in rightContainerView.subviews {
                subview.removeFromSuperview()
            }
            searchTextField?.placeholder = "Введите имя, тег, почту..."
            searchTextField?.snp.remakeConstraints({ make in
                       make.left.equalToSuperview().inset(16)
                       make.right.equalToSuperview().inset(16) // Обновленный правый отступ
                       make.top.equalToSuperview().inset(60)
                       make.height.equalTo(40)
                   })
            
            rightContainerView.addSubview(rightTextFieldButton!)
            
            rightTextFieldButton?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10))
            }
            leftTextFieldButton?.tintColor = UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1)
            closeTextFieldButton?.alpha = 0
            rightTextFieldButton?.alpha = 1
            self.layoutIfNeeded()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.2) { [self] in
            for subview in rightContainerView.subviews {
                subview.removeFromSuperview()
            }
            searchTextField?.placeholder = nil
            searchTextField?.snp.remakeConstraints({ make in
                       make.left.equalToSuperview().inset(16)
                       make.right.equalToSuperview().inset(110) // Обновленный правый отступ
                       make.top.equalToSuperview().inset(60)
                       make.height.equalTo(40)
                   })
            
            rightContainerView.addSubview(closeTextFieldButton!)
            print(searchTextField?.text)
            
            if  searchTextField?.text == Optional("") {
                closeTextFieldButton?.alpha = 0
                
            }
            if  searchTextField?.text != Optional("") {
                closeTextFieldButton?.alpha = 1
                
            }
            
            closeTextFieldButton?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 10))
            }
            
            leftTextFieldButton?.tintColor = .black
            
            
            
            
            
            rightTextFieldButton?.alpha = 0
           self.layoutIfNeeded()
        }
        

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == searchTextField {
                UIView.animate(withDuration: 0.3) {
                    let currentText = (textField.text ?? "") as NSString
                    let newText = currentText.replacingCharacters(in: range, with: string)
                    
                    if newText.isEmpty {
                        self.closeTextFieldButton?.alpha = 0
                    } else {
                        self.closeTextFieldButton?.alpha = 1
                    }
                }
                 
                
            
                
                sortCopyPersonArrayByTextFieldText()
                return true
            }
            return false
        }
    
    
    func sortCopyPersonArrayByTextFieldText() {
        guard let searchText = searchTextField?.text?.lowercased() else { return }

        // Отсортировать массив по пользовательскому условию
        personArray.sort { (left, _) -> Bool in
            // Получить данные Item из left
            let item = left.0
            // Создать массив всех строковых полей Item
            let itemStrings = [item.firstName, item.userTag, item.phone]
            // Преобразовать все строки в нижний регистр и проверить, содержится ли в них searchText
            let containsSearchText = itemStrings.map { $0.lowercased() }.contains { $0.contains(searchText) }
            // Вернуть результат сравнения
            return containsSearchText
        }

        viewController?.mainView?.collectionView?.reloadData()
    }
}

