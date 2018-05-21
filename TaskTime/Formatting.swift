//
//  TextFieldMaxLengths.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/28/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import Foundation
import UIKit

//max length of text field
private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

//currency text field
class CurrencyField: UITextField {
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999.99
    private var lastValue: String = ""
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if if needed
        // Formatter.currency.locale = Locale(identifier: "pt_BR") // or "en_US", "fr_FR", etc
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    @objc func editingChanged() {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        lastValue = Formatter.currency.string(for: decimal) ?? ""
        text = lastValue
        print("integer:", integerValue)
        print("double:", doubleValue)
        print("decimal:", decimal)
        print("currency:", lastValue)
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
extension String {
    var digits: [UInt8] { return compactMap{ UInt8(String($0)) } }
}
extension Collection where Iterator.Element == UInt8 {
    var string: String { return map(String.init).joined() }
    var decimal: Decimal { return Decimal(string: string) ?? 0 }
}
extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}

//date functions
func getCurrentDate () -> Int {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let currentDate = dateFormatter.string(from: date)
    let currentDateInt = Int(currentDate)!
    return currentDateInt
}

func saveDateData(date:Int?) {
    UserDefaults.standard.set(date, forKey: "myDate")
}

func fetchDateData() -> Int? {
    if let date = UserDefaults.standard.integer(forKey: "myDate") as? Int {
        return date
    } else {
        return 0
    }
}

//segue from left
class SegueFromLeft: UIStoryboardSegue {
    override func perform() {
        
        let src = self.source
        let dst = self.destination
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                        
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

//segue from right
class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        
        let src = self.source
        let dst = self.destination
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                        
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

//color
func getColor() -> UIColor {
    let hex = UserDefaults.standard.integer(forKey: "myColor")
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF)) / 255.0
    let color = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:1.0)
    return color
}

func setColor(hex: Int) {
    UserDefaults.standard.set(hex, forKey: "myColor")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
