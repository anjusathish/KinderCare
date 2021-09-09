//
//  TableViewExtension.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 17/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

extension UITableView {
  
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
       // self.register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
  
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                           for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }
  
    func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        )
    }
}

extension UICollectionView {
  
    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
}
