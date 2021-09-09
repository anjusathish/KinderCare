//
//  CalendarViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/13/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol HolidayDelegate {
    
    func holidaySuccess(Holiday:[HoildayData])
    
    func failure(message : String)
}

class HolidayViewModel
{
    var delegate:HolidayDelegate!
    
    func hoildayList(month:Int,school_id:Int){
        
        CalendarServiceHelper.requestFormData(router:  CalendarServiceManager.holidayList(month: month, school_id: school_id), completion: {
            (result : Result<HolidayList, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        print(_data)
                        self.delegate.holidaySuccess(Holiday: _data)
                        
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
     
}
