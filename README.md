# Implementing Google's Two-Step Authentication with SWIFT 

The algorithm is from https://www.codementor.io/slavko/google-two-step-authentication-otp-generation-du1082vho

# 1.Take the current Unix Time Stamp 
Swift Code: 
let timeInterval = NSDate().timeIntervalSince1970 

# 2.Device the result with 30 
Swift Code:
var time30 = timeInterval/30 

# 3.Calculate the OTP - onetime password based on HMAC 
# 	a.Take integer part of the value above and convert to hex 
Swift Code: 
time30 = Int(timeInterval) 
var str = NSString(format:"%2X", time30) as String 
#   b.If hex string has lesser than 16 characters, pad it from the left using 0 character 
Swift Code: 
str = "000000000"+str  // here can use condition loop
#   c.Get ASCII code of the result  
Swift Code: 
let input = self.hexStringtoAscii(hexString : str) 
var array: [UInt8] = [] 
for c in input{ 
let s = String(c).unicodeScalars 
      let svalue = Int(s[s.startIndex].value) 
      array.append(UInt8(svalue)) 
       } 
#   d.Calculate sha1 HMAC 
Swift Code 
let ss = try HMAC(key: keystring,variant:.sha1).authenticate(array) 
//key string can get from manually input , for example: 
//var keystring = self.keytx.text! 

# 4.Convert it to a 6 digit sequence 
#   a.Take 19th Array Element 
Swift Code: 
let resdata = ss[19] & 0xf 
#   b.Perform a bitwise operator & on mask 0xf 
Swift Code: 
let offset = Int(resdata) 
#   c.Get 4 elements from array, start from offset element to offset+4 element and bitwise operator & on mask 0xff(0x7f) 
Swift Code: 
let res1 = ss[offset] & 0x7f 
let res2 = ss[offset+1] & 0xff 
let res3 = ss[offset+2] & 0xff 
let res4 = ss[offset+3] & 0xff 
#  d.Get the bianery string of the 4 elements, the calculate function is like bellow 
Swift Code: 
var str1 = String(res1, radix: 2) 
let r2 = String(res2, radix: 2) 
var i2 = r2.count 
while(i2<8){ 
  str1 = str1 + "0" 
  i2 = i2+1 
} 
str1 = str1 + String(res2, radix: 2) 
let r3 = String(res3, radix: 2) 
var i3 = r3.count 
while(i3<8){ 
	str1 = str1 + "0" 
	i3 = i3 + 1 
} 
str1 = str1 + String(res3, radix: 2) 
let r4 = String(res4, radix: 2) 
var i4 = r4.count 
while(i4<8){ 
	str1 = str1 + "0" 
	i4 = i4 + 1 
} 
str1 = str1 + String(res4, radix: 2) 
let dec = Int(str1, radix: 2) 

# 5.Take the final result 
#   a.retrieve the modulus of division on 10 pow length of the needed sequence (for 6 it is 1000000) 
Swift Code: 
let data2 = Decimal(dec!) / 1000000 
#   b.Get modules as the result 
Swift Code: 
let date3 = Int(truncating: NSDecimalNumber(decimal: data2)) 
let date4 = Double(truncating: NSDecimalNumber(decimal: data2)) - Double(date3) 
let finalcode = Int(date4 * 1000000) 
 
# Now We are finished with our algorithm here. Finalcode is the result generated. 
