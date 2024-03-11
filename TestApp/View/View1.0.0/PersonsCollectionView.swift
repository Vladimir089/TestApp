//
//  PersonsCollectionView.swift
//  TestApp
//
//  Created by Владимир Кацап on 06.03.2024.
//

import UIKit

class PersonsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super .init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoad == false {
            return 10
        } else {
            return personArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        var imageView: UIImageView?
        var lastFirstNameLabel: UILabel?
        var specLabel: UILabel?
        var dopLabel: UILabel?
        var dateLabel: UILabel?
        
        //MARK: -No load
        let botImageView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 40
            view.clipsToBounds = true
            view.alpha = 0.5
            view.backgroundColor = .systemGray5
            return view
        }()
        
        let topView: UIView = {
            let view = UIView()
            view.alpha = 0.5
            view.backgroundColor = .systemGray5
            view.layer.cornerRadius = 8
            return view
        }()
        
        let botView: UIView = {
            let view = UIView()
            view.alpha = 0.5
            view.backgroundColor = .systemGray5
            view.layer.cornerRadius = 7
            return view
        }()
        
        cell.addSubview(botImageView)
        botImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.left.equalToSuperview()
        }
        
        cell.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(144)
            make.top.equalToSuperview().inset(25)
            make.left.equalTo(botImageView.snp.right).inset(-10)
        }
        
        cell.addSubview(botView)
        botView.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(80)
            make.top.equalTo(topView.snp.bottom).inset(-5)
            make.left.equalTo(botImageView.snp.right).inset(-10)
        }
        
        //MARK: -Load
        
        print(personArray.count)
        if isLoad == true {
            
            if indexPath.row < personArray.count {
                
                imageView = {
                    let image = personArray[indexPath.row].1
                    let imageView = UIImageView(image: image)
                    imageView.layer.cornerRadius = 40
                    imageView.clipsToBounds = true
                    imageView.alpha = 0
                    return imageView
                }()
                
                cell.addSubview(imageView ?? UIImageView())
                imageView!.snp.makeConstraints { make in
                    make.height.width.equalTo(80)
                    make.top.left.equalToSuperview()
                }
                
                lastFirstNameLabel = {
                    let label = UILabel()
                    label.text = "\(personArray[indexPath.row].0.firstName ) \(personArray[indexPath.row].0.lastName)"
                    label.font = .systemFont(ofSize: 16, weight: .medium)
                    label.alpha = 0
                    return label
                }()
                
                cell.addSubview(lastFirstNameLabel ?? UILabel())
                lastFirstNameLabel?.snp.makeConstraints({ make in
                    make.top.equalToSuperview().inset(25)
                    make.left.equalTo(botImageView.snp.right).inset(-10)
                })
                
                specLabel = {
                    let label = UILabel()
                    label.text = personArray[indexPath.row].0.department
                    label.font = .systemFont(ofSize: 13, weight: .light)
                    label.alpha = 0
                    label.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
                    return label
                }()
                
                cell.addSubview(specLabel ?? UILabel())
                specLabel?.snp.makeConstraints({ make in
                    make.top.equalTo(topView.snp.bottom).inset(-5)
                    make.left.equalTo(botImageView.snp.right).inset(-10)
                })
                
                dopLabel = {
                    let label = UILabel()
                    label.text = personArray[indexPath.row].0.userTag
                    label.font = .systemFont(ofSize: 14, weight: .medium)
                    label.textColor = UIColor(red: 151/255, green: 151/255, blue: 155/255, alpha: 1)
                    return label
                }()
                
                cell.addSubview(dopLabel ?? UILabel())
                dopLabel?.snp.makeConstraints({ make in
                    make.bottom.equalTo((lastFirstNameLabel?.snp.bottom)!)
                    make.left.equalTo((lastFirstNameLabel?.snp.right)!).inset(-5)
                })
                
                dateLabel = {
                    let label = UILabel()
                    label.text = personArray[indexPath.row].0.birthday
                    label.font = .systemFont(ofSize: 15, weight: .regular)
                    label.textColor = UIColor(red: 85/255, green: 85/255, blue: 92/255, alpha: 1)
                    label.alpha = 0
                    return label
                }()
                
                cell.addSubview(dateLabel ?? UILabel())
                dateLabel?.snp.makeConstraints({ make in
                    make.top.equalTo((dopLabel?.snp.centerY)!).offset(-5)
                    make.right.equalToSuperview().inset(3)
                })
                
                if sortedBy == "Day" {
                    UIView.animate(withDuration: 0.3) {
                        dateLabel?.alpha = 1
                        
                    }
                }
                UIView.animate(withDuration: 0.3) {
                    botImageView.alpha = 0
                    topView.alpha = 0
                    botView.alpha = 0
                    imageView?.alpha = 1
                    lastFirstNameLabel?.alpha = 1
                    specLabel?.alpha = 1
                    
                }
            }
            
        } else {
            UIView.animate(withDuration: 0.3) {
                botImageView.alpha = 0.5
                topView.alpha = 0.5
                botView.alpha = 0.5
                imageView?.alpha = 0
                lastFirstNameLabel?.alpha = 0
                specLabel?.alpha = 0
                dateLabel?.alpha = 0
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0) // Установите нужное значение для отступа сверху
    }
}
