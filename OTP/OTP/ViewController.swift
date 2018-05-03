//
//  ViewController.swift
//  OTP
//
//  Created by 张乐 on 3/5/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Foundation
import CryptoSwift

class ViewController: UIViewController {

    @IBOutlet weak var otpbtn: UIButton!
    
    
    @IBOutlet weak var keytx: UITextField!
    @IBOutlet weak var hmactx: UILabel!
    
    @IBAction func otpfunc(_ sender: Any) {
        //1# get unix time
        let timeInterval = NSDate().timeIntervalSince1970
        print("unix time ***** ",Int(timeInterval))
        //2# /30
        let time30 = Int(timeInterval/30)
        print("unix time ***** ",time30)
        //3# hex time length to 16 bites
        var str = NSString(format:"%2X", time30) as String
        str = "000000000"+str
        //str = "0000000002a52035"
        //2a52035"
        print("hex code is ***** ",str)
        //4# get ascii
        let input = self.hexStringtoAscii(hexString : str)
        print("bite string ****** ",input)
        //5# get ascii code
        var array: [UInt8] = []
        for c in input{
            let s = String(c).unicodeScalars
            let svalue = Int(s[s.startIndex].value)
            print("print int index of ascii ******* ",svalue)
            array.append(UInt8(svalue))
        }
        print("array uint8 ****** ",array)
        //6# hash with key
        do{
            var keys = ""
            if(self.keytx.text != nil){
                keys = self.keytx.text!
            }else{
                keys = "LBPYKCVKYCBL6JS2GVUPC54FVAUCZYEH"
            }
            let ss = try HMAC(key: keys, variant:.sha1).authenticate(array)
            //LBPYKCVKYCBL6JS2GVUPC54FVAUCZYEH
            //lbpykcvkycbl6js2gvupc54fvauczyeh
            //let ss = try HMAC(key: "LBPYKCVKYCBL6JS2GVUPC54FVAUCZYEH", variant:.sha1).authenticate(array)
            //lbpykcvkycbl6js2gvupc54fvauczyeh
            print("sha1 is ******** ",ss)
            //7#
            let resdata = ss[19] & 0xf
            let offset = Int(resdata)
            print("after and with 19th ****** ",offset)
            print("offset start from ****** ",ss[offset])
            //
            let res1 = ss[offset] & 0x7f
            let res2 = ss[offset+1] & 0xff
            let res3 = ss[offset+2] & 0xff
            let res4 = ss[offset+3] & 0xff
            var str1 = String(res1, radix: 2)
            print("i1 count is ****** ",str1)
            let r2 = String(res2, radix: 2)
            var i2 = r2.count
            while(i2<8){
                    str1 = str1 + "0"
                    i2 = i2+1
            }
            str1 = str1 + String(res2, radix: 2)
            print("i2 count is ****** ",str1)
            let r3 = String(res3, radix: 2)
            var i3 = r3.count
            if(i3<8){
                while(i3<8){
                    str1 = str1 + "0"
                    i3 = i3 + 1
                }
            }
            str1 = str1 + String(res3, radix: 2)
            print("i3 count is ****** ",str1)
            let r4 = String(res4, radix: 2)
            var i4 = r4.count
            while(i4<8){
                str1 = str1 + "0"
                i4 = i4 + 1
            }
            str1 = str1 + String(res4, radix: 2)
            print("count of r4 ****** ",str1)
            let dec = Int(str1, radix: 2)
            print("final code is ***** ",dec)
            let data2 = Decimal(dec!) / 1000000
            let date3 = Int(truncating: NSDecimalNumber(decimal: data2))
            let date4 = Double(truncating: NSDecimalNumber(decimal: data2)) - Double(date3)
            let finalcode = Int(date4 * 1000000)
            print("result ****** ",finalcode)
            self.hmactx.text = String(finalcode)
        }catch{
            print("error is ***",NSError())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //conver from hex to ascii
    func hexStringtoAscii(hexString : String) -> String {
        
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = hexString as NSString
        let matches = regex.matches(in: hexString, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }


}

