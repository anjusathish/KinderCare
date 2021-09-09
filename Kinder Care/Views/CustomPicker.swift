//
//  CustomPicker.swift
//  Mtopo_Arun
//
//  Created by CIPL242-MOBILITY on 14/02/17.
//  Copyright © 2017 Colan Infotech Private Limited. All rights reserved.
//

import UIKit

//Creating Protocol
protocol CustomPickerDelegate: class
{
  func itemPicked(item: AnyObject)
  func pickerCancelled()
}

enum CustomPickerType : Int
{
  case e_PickerType_String = 1,
  e_PickerType_Date
}

class CustomPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  //MARK: - Protocol Declaration
  weak var delegate: CustomPickerDelegate? = nil
  @IBOutlet var vwBaseView: UIView!
  
  @IBOutlet weak var viewPickerBackground : UIView!
  
  //MARK: - Properties Declaration
  var customPicker: UIPickerView!
  var customDatePicker : UIDatePicker!
  
  var totalComponents: Int!
  var arrayComponent = [String]()
  
  var currentPickerType : CustomPickerType = .e_PickerType_String
  
  let screenFrame = UIScreen.main.bounds
  
  //MARK: - UIViewController Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func customPickerOrientation(){
    DispatchQueue.main.async {
      self.viewPickerBackground.frame.size.width = self.view.frame.size.width
      self.removePickerViews()
      switch self.currentPickerType
      {
      case .e_PickerType_String:
        self.configStringPicker()
        
      case .e_PickerType_Date:
        self.configDateTimePicker()
      }
    }
  }
  
  func loadCustomPicker(pickerType : CustomPickerType){
    self.removePickerViews()
    currentPickerType = pickerType
    
    switch pickerType
    {
    case .e_PickerType_String:
      configStringPicker()
      
    case .e_PickerType_Date:
      configDateTimePicker()
    }
  }
  
  func removePickerViews(){
    let pickerViews = viewPickerBackground.subviews
    for view in pickerViews{
      view.removeFromSuperview()
    }
  }
  
  func configStringPicker(){
    self.viewPickerBackground.frame.size.width = self.view.frame.size.width
    //self.customDatePicker.frame.size.width = self.viewPickerBackground.frame.size.width
    self.customPicker = UIPickerView(frame: CGRect(x: 0.0, y: 44.0, width: self.viewPickerBackground.frame.size.width, height: 216.0))
    self.customPicker.delegate = self
    self.customPicker.dataSource = self
    
    let pickerToolbar = self.getPickerToolbar()
    self.viewPickerBackground.addSubview(pickerToolbar)
    self.viewPickerBackground.addSubview(customPicker)
  }
  
  func configDateTimePicker(){
    self.viewPickerBackground.frame.size.width = self.view.frame.size.width
    self.customDatePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 44.0, width: self.viewPickerBackground.frame.size.width, height: 216.0))
    let pickerToolbar = getPickerToolbar()
    customDatePicker.datePickerMode = .date
    viewPickerBackground.addSubview(pickerToolbar)
    viewPickerBackground.addSubview(customDatePicker)
  }
  
  func getPickerToolbar() -> UIToolbar{
    self.viewPickerBackground.frame.size.width = self.view.frame.size.width
    let pickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: viewPickerBackground.frame.size.width, height: 44))
    pickerToolbar.barTintColor = UIColor.ctBlue//Constants.getCustomGreenColor()
    
    self.customDatePicker.datePickerMode = .dateAndTime
    if #available(iOS 13.4, *) {
        //self.customDatePicker.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
    
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonAction(_:)))
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction(_:)))
    let flexibespace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    cancelButton.tintColor  = UIColor.white
    doneButton.tintColor    = UIColor.white
    
    let arrayButtons = [cancelButton,flexibespace,doneButton]
    pickerToolbar.setItems(arrayButtons, animated: true)
    return pickerToolbar
  }
  
  //MARK: - IBAction methods
  @objc func cancelButtonAction(_ sender: Any){
    if self.delegate != nil{
      self.delegate?.pickerCancelled()
    }
  }
  @objc func doneButtonAction(_ sender: Any){
    
    var pickerValue : Any! = nil
    switch currentPickerType{
    case .e_PickerType_String:
      
      if customPicker != nil{
        let selectedRow = customPicker.selectedRow(inComponent: 0)
        pickerValue = arrayComponent[selectedRow]
        Constants.LAST_SELECTED_INDEX_N_PICKER = selectedRow
      }
    case .e_PickerType_Date:
      let pickedDate = customDatePicker.date
      pickerValue = pickedDate
      
    }
    if pickerValue != nil && self.delegate != nil{
      self.delegate?.itemPicked(item: pickerValue as AnyObject)
    }
  }
  
  //MARK: - String Picker Delegate
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return totalComponents
  }
    
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrayComponent.count
  }
    
  //MARK: - UIPickerViewDelegate
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
    return arrayComponent[row]
  }
}


// MARK:- TextView
extension UITextView {
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  @IBInspectable
  var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
}


// MARK:- Top Curve View
@IBDesignable
class TopCurvedView: UIView {

    var path : UIBezierPath!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        path = UIBezierPath()
        
        let y:CGFloat = 0
        
        path.move(to: CGPoint(x: 0, y: y))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: 60))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()

        // Specify the fill color and apply it to the path.
        UIColor.white.setFill()
        path.fill()
    }
}


//MARK:- Button Curve View
// MARK:- Top Curve View
@IBDesignable
class ButtomCurveView: UIView {

    var path : UIBezierPath!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {

        let marginCurve = 40

        let curve1 = UIBezierPath()
        curve1.move(to: CGPoint(x: 0, y: 0))
        curve1.addLine(to: CGPoint(x: rect.width, y: 0))
        curve1.addLine(to: CGPoint(x: rect.width, y: rect.height - CGFloat(marginCurve)))
        curve1.addCurve(to: CGPoint(x: 0, y: rect.height - CGFloat(marginCurve)), controlPoint1: CGPoint(x: rect.width / 2, y: rect.height), controlPoint2: CGPoint(x: rect.width / 2, y: rect.height))
        curve1.close()
        UIColor.appColor.setFill()
        curve1.fill()
    }
}


@IBDesignable
class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
