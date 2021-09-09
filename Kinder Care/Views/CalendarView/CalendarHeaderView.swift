/*
 * CalendarHeaderView.swift
 * Created by Michael Michailidis on 07/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

open class CalendarHeaderView: UIView {
    
    lazy var monthLabel : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.left
        lbl.font = UIFont(name: CalendarView.Style.headerFontName, size: CalendarView.Style.headerFontSize)
        lbl.textColor = CalendarView.Style.headerTextColor
        lbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        lbl.addGestureRecognizer(tap)
        self.addSubview(lbl)
        
        return lbl
    }()
    lazy var downButton : UIButton = {
        let btn = UIButton(type: .custom)
           btn.setImage(UIImage(named: "cal_up_arrow"), for: .normal)
        btn.addTarget(self, action: #selector(tapFunction(sender:)), for: .touchUpInside)
           self.addSubview(btn)
           return btn
       }()
    lazy var dayLabelContainerView : UIView = {
        let v = UIView()
        
        let formatter = DateFormatter()
        
        var start = CalendarView.Style.firstWeekday == .sunday ? 0 : 1
        
        for index in start..<(start+7) {
            
            let weekdayLabel = UILabel()
            
            weekdayLabel.font = UIFont(name: CalendarView.Style.headerFontName, size: 14.0)
            
            weekdayLabel.text = String(formatter.shortWeekdaySymbols[(index % 7)].prefix(1))
            
            weekdayLabel.textColor = CalendarView.Style.headerTextColor
            weekdayLabel.textAlignment = NSTextAlignment.center
            
            v.addSubview(weekdayLabel)
        }
        
        self.addSubview(v)
        
        return v
        
    }()
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        var frm = self.bounds
        frm.origin.y += 5.0
        frm.size.height = self.bounds.size.height / 2.0 - 5.0
        
        self.monthLabel.frame = frm
        self.monthLabel.sizeToFit()
        self.downButton.frame = CGRect(x: monthLabel.frame.size.width, y:  monthLabel.frame.origin.y, width: 23, height: 23)
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0,
            height: self.bounds.size.height / 2.0
        )
        
        for lbl in self.dayLabelContainerView.subviews {
            
            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
    }
   @objc func tapFunction(sender:UITapGestureRecognizer) {
           NotificationCenter.default.post(name: Notification.Name("NotifyUpdateMonths"), object: nil, userInfo: nil)
    }
}
