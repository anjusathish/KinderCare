//
//  ListWeeklyMenuDelegate.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 16/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol ListWeeklyMenuDelegate {
    
  func listWeeklyMenu(items:[Dish],_ weeklyItem: [WeeklyMenuItem], _ editWeeklyMenuData: [DatumDish])
    func failure(message : String)
}

class ListWeeklyMenuViewModel
{
    var delegate:ListWeeklyMenuDelegate!
    
    func getWeeklyMenu(date: String, classId : String, schoolId : String,user_id:Int) {
        
        WeeklyMenuServiceHelper.requestFormData(router: .getWeeklyMenu(date: date, classId: classId, schoolId: schoolId, user_id: user_id), completion: {
            (result : Result<ListWeeklyMenuResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    let dishes = data.data.map({$0.dishes}).flatMap({$0})
                    
                    
                    let menuItem = data.data.map({$0.weeklyMenuItems}).flatMap({$0})
                    
                    
                    
                    self.delegate.listWeeklyMenu(items: dishes, menuItem, data.data)
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
}
