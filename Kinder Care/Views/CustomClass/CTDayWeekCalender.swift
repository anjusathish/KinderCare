
 import Foundation
 import UIKit

 @IBDesignable
 class CTDayWeekCalender: UIControl {
     @IBInspectable var cornerRadius : CGFloat = 0.0 {
         didSet {
             clipsToBounds = true
             layer.cornerRadius = cornerRadius
         }
     }
     
     @IBInspectable var leftArrowImage : UIImage?{
         didSet {
             renderButtons()
         }
     }
     
     @IBInspectable var rightArrowImage : UIImage?{
         didSet {
             renderButtons()
         }
     }
     
     @IBInspectable var calenderImage : UIImage?{
         didSet {
             renderButtons()
         }
     }
     
     var date : Date = Date(){
         didSet {
             setDate()
         }
     }
     
     var dateString : String{
         get {
             let dateString = date.asString(withFormat: "dd-MM-yyyy")
             return dateString
         }
     }
     
     var minmumDate : Date?{
         didSet {
             setLeftButtonSate()
         }
     }
     
     var maximumDate : Date?{
         didSet {
             setRightButtonSate()
         }
     }
     
     private var leftArrowButton = UIButton(type: .custom)
     private var rightArrowButton = UIButton(type: .custom)
     private var currentDateButton = UIButton(type: .custom)
     var selectedView : UIView?
     var currentWeekCount = 0
     var maxWeekCount = 0
     var maxDaysCount = 0
     
     override func awakeFromNib() {
         
         leftArrowButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
         rightArrowButton.addTarget(self, action: #selector(rightButtonAction(sender:)), for: .touchUpInside)
         
         renderButtons()
     }
     
     private func renderButtons() {
         
         for item in self.subviews {
             item.removeFromSuperview()
         }
         
         
         let stackview = UIStackView()
         stackview.axis = .horizontal
         stackview.distribution = .equalSpacing
         
         let weekStack = UIScrollView()
         weekStack.backgroundColor = UIColor.init(red: 239/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1.0)
         currentDateButton.isUserInteractionEnabled = false
         weekStack.isScrollEnabled = false
         setLeftImage()
         setRightImage()
         setCalednerImage()
         setDate()
         
         stackview.addArrangedSubview(leftArrowButton)
         stackview.addArrangedSubview(currentDateButton)
         stackview.addArrangedSubview(rightArrowButton)
         
         self.addSubview(stackview)
         self.addSubview(weekStack)
         
         stackview.translatesAutoresizingMaskIntoConstraints = false
         leftArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
         rightArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
         stackview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         stackview.heightAnchor.constraint(equalToConstant: 40).isActive = true
         // stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         stackview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
         stackview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
         
         weekStack.translatesAutoresizingMaskIntoConstraints = false
         weekStack.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 0).isActive = true
         weekStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
         weekStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
         weekStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
         
         
         let allDays = Date().getAllDays()
         let width = Double((UIScreen.main.bounds.size.width - 16) / 7)
         let height = 60.0
         var x = 0.0
         var i = 1
         maxDaysCount = allDays.count
         maxWeekCount = maxDaysCount / 7
         for cdate in allDays {
             let dayView = UIView.init(frame: CGRect.init(x: x, y: 0.0, width: width, height: height))
             dayView.tag = i
             dayView.backgroundColor = UIColor.white
             
             let dateLbl = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: width, height: height/2-10))
             dateLbl.text = "\(cdate.asString(withFormat: "dd"))"
             dateLbl.textColor = UIColor.init(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
             dateLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
             dateLbl.textAlignment = .center
             dayView.addSubview(dateLbl)
             
             let dayLbl = UILabel.init(frame: CGRect.init(x: 0, y: height/2, width: width, height: height/2-10))
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "EEE"
             dayLbl.text = dateFormatter.string(from: cdate)
             dayLbl.textColor = UIColor.init(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
             dayLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
             dayLbl.textAlignment = .center
             dayView.addSubview(dayLbl)
             if i > 1 && i <= allDays.count{
                 let dividerLbl = UILabel.init(frame: CGRect.init(x: 0, y: 7, width: 1, height: height-14))
                 dividerLbl.backgroundColor = UIColor.init(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
                 dayView.addSubview(dividerLbl)
             }
             x = x + width
             weekStack.addSubview(dayView)
             let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
             dayView.addGestureRecognizer(tap)
             i = i+1
         }
         
         weekStack.contentSize = CGSize.init(width: x, height: height)
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d"
         let currentDate = dateFormatter.string(from: Date())
         
         for view in weekStack.subviews{
             let tag = view.tag
             
             let _date = getDateAsString(forTag: tag)
             
             let bckColor = UIColor.init(red: 239/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1.0);
             if currentDate == _date {
                 setBackgroundColorDayView(view:  view, color: bckColor, isRound: true)
             }
         }
        
        let current = allDays.firstIndex(where: {$0.asString(withFormat: "yyy-MM-dd") == Date().asString(withFormat: "yyy-MM-dd")})!
        
         //let current = Int(currentDate)! - 1
         currentWeekCount = current / 7
         setDate()
         let width2 =  UIScreen.main.bounds.size.width - 16
         let cgpoint = CGPoint.init(x: (width2 * CGFloat(currentWeekCount)), y: weekStack.contentOffset.y)
         weekStack.setContentOffset(cgpoint, animated: true)
         setLeftButtonSate()
         setRightButtonSate()
     }
     
     @objc func tapFunction(sender:UITapGestureRecognizer) {
         let colorBck = UIColor.init(red: 239/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1.0)
         setBackgroundColorDayView(view:  sender.view!, color: colorBck, isRound: true)
     }
     
     func setBackgroundColorDayView(view:UIView,color:UIColor,isRound:Bool){
         
         self.date = Date().getAllDays()[view.tag-1]
         
         sendActions(for: .valueChanged)
         
         if selectedView != nil{
             resetDayView()
         }
         view.backgroundColor = color
         let superViewDay = view.superview
         let tag = view.tag
         if tag > 0 {
             if view.subviews.count > 2{
                 view.subviews[2].isHidden = true
             }
             if(isRound){
                 ((view.subviews[0]) as! UILabel).textColor = UIColor.white
                 ((view.subviews[1]) as! UILabel).textColor = UIColor.white
             }
             if (tag > 1){
                 let previousView = superViewDay?.subviews[tag-2]
                 if (isRound){
                     let path = UIBezierPath(roundedRect: previousView!.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
                     let mask = CAShapeLayer()
                     mask.path = path.cgPath
                     previousView!.layer.mask = mask
                 }
             }
         }
         
         if tag < maxDaysCount {
             let nextView = superViewDay?.subviews[tag]
             nextView?.subviews[2].isHidden = true
             if (isRound){
                 let path = UIBezierPath(roundedRect: nextView!.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
                 let mask = CAShapeLayer()
                 mask.path = path.cgPath
                 nextView!.layer.mask = mask
             }
         }
         selectedView = view
     }
     
     func resetDayView(){
         selectedView!.backgroundColor = UIColor.white
         ((selectedView!.subviews[0]) as! UILabel).textColor = UIColor.init(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
         ((selectedView!.subviews[1]) as! UILabel).textColor = UIColor.init(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
         let superViewDay = selectedView!.superview
         let tag = selectedView!.tag
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d"
         let bckColor = UIColor.init(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0);
         let currentDate = dateFormatter.string(from: Date())
         
         let _date = getDateAsString(forTag: tag)

         if currentDate == _date {
             selectedView!.backgroundColor = bckColor
         }
         
         if tag > 1 {
             if currentDate != _date ,selectedView!.subviews.count > 2 {
                 selectedView!.subviews[2].isHidden = false
             }
             let previousView = superViewDay?.subviews[tag-2]
             let path = UIBezierPath(roundedRect: previousView!.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 0, height: 0))
             let mask = CAShapeLayer()
             mask.path = path.cgPath
             previousView!.layer.mask = mask
             
         }
         
         if tag < maxDaysCount {
             let nextView = superViewDay?.subviews[tag]
             if currentDate != _date,(nextView?.subviews.count)! > 2 {
                 nextView?.subviews[2].isHidden = false
             }
             let path = UIBezierPath(roundedRect: nextView!.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 0, height: 0))
             let mask = CAShapeLayer()
             mask.path = path.cgPath
             nextView!.layer.mask = mask
             
             let _date = getDateAsString(forTag: tag+1)
             
             if currentDate == _date{
                 nextView!.subviews[2].isHidden = true
             }
             
             let _date1 = getDateAsString(forTag: tag-1)

             if currentDate == _date1{
                 selectedView!.subviews[2].isHidden = true
             }
         }
         
     }
     
     private func getDateAsString(forTag tag : Int) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "d"
        if tag  == 0 {
            
        }
        else{
         let _date = Date().getAllDays()[tag-1]
         return dateFormatter.string(from: _date)
     }
        return  "nil"
    }
    
     private func setLeftImage() {
         
         if let image = leftArrowImage {
             leftArrowButton.setImage(image, for: .normal)
         }
     }
     
     private func setRightImage() {
         
         if let image = rightArrowImage {
             rightArrowButton.setImage(image, for: .normal)
         }
     }
     
     private func setCalednerImage() {
         
         if let image = calenderImage {
             currentDateButton.setImage(image, for: .normal)
             currentDateButton.tintColor = .white
         }
     }
     
     private func setDate() {
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = " MMMM yyy"
         currentDateButton.setTitle("   \(dateFormatter.string(from: date))", for: .normal)
     }
     
     private func setLeftButtonSate() {
         
         if currentWeekCount >= 1  {
             leftArrowButton.isEnabled = true
         }
         else {
             leftArrowButton.isEnabled = false
         }
     }
     
     private func setRightButtonSate() {
         
         if  currentWeekCount < maxWeekCount {
             rightArrowButton.isEnabled = true
         }
         else {
             rightArrowButton.isEnabled = false
         }
     }
     
     //MARK:- Actions
     
     @objc private func leftButtonAction(sender : UIButton) {
         
         let scrollView : UIScrollView  = self.subviews[1] as! UIScrollView
         if currentWeekCount >= 1 {
             currentWeekCount = currentWeekCount - 1
             setDate()
             let width =  UIScreen.main.bounds.size.width - 16
             let cgpoint = CGPoint.init(x: (width * CGFloat(currentWeekCount)), y: scrollView.contentOffset.y)
             scrollView.setContentOffset(cgpoint, animated: true)
         }
         setLeftButtonSate()
         setRightButtonSate()
     }
     
     @objc private func rightButtonAction(sender : UIButton) {
         
         let scrollView : UIScrollView  = self.subviews[1] as! UIScrollView
         if currentWeekCount <= maxWeekCount {
             currentWeekCount = currentWeekCount + 1
             setDate()
             let width =  UIScreen.main.bounds.size.width - 16
             let cgpoint = CGPoint.init(x: (width * CGFloat(currentWeekCount)), y: scrollView.contentOffset.y)
             scrollView.setContentOffset(cgpoint, animated: true)
         }
         setRightButtonSate()
         setLeftButtonSate()
     }
 }

 extension Calendar {
     static let iso8601 = Calendar(identifier: .iso8601)
     static let gregorian = Calendar(identifier: .gregorian)
 }

 extension Date
 {
     func byAdding(component: Calendar.Component, value: Int, wrappingComponents: Bool = false, using calendar: Calendar = .current) -> Date? {
         calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrappingComponents)
     }
     func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
         calendar.dateComponents(components, from: self)
     }
     func startOfWeek(using calendar: Calendar = .current) -> Date {
         calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
     }
     var noon: Date {
         Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
     }
    
     func daysOfWeek(using calendar: Calendar = .current) -> [Date] {
         let startOfWeek = self.startOfWeek(using: calendar).noon
         let range = calendar.range(of: .day, in: .month, for: self)!
         return (0...(range.count-1)).map { startOfWeek.byAdding(component: .day, value: $0, using: calendar)! }
     }
     
     mutating func addDays(n: Int)
     {
         let cal = Calendar.current
         self = cal.date(byAdding: .day, value: n, to: self)!
     }
     
     func firstDayOfTheMonth() -> Date {
         return Calendar.current.date(from:
                                         Calendar.current.dateComponents([.year,.month,.hour,.month,.second,.timeZone], from: self))!
     }
     
     func getAllDays() -> [Date]
     {
         
                 
         
         let days = firstDayOfTheMonth().daysOfWeek(using: .iso8601)
         
         print(days)
         
         return days
     }
 }







