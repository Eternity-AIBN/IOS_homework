//
//  Calculator.swift
//  Cal
//
//  Created by AIBN on 2020/10/25.
//

import Foundation

class Calculator{
    var curNum : Double
    var lastNum : Double
    var decPoint : Bool
    
    var negativeFlag : Bool
    var isConstant : Bool
    
    var resStr : String
    var rad : Bool
    var operation : String
    
    let e : Double
    let pi : Double
    
    init(){
        self.curNum = 0
        self.lastNum = 0
        self.decPoint = false
        self.negativeFlag = false
        self.resStr = "0"
        self.isConstant = false
        self.rad = false
        self.operation = ""
        
        self.e = 2.718281728459
        self.pi = 3.141592653589
    }
    
    func Clear(){
        self.curNum = 0
        self.lastNum = 0
        self.decPoint = false
        self.negativeFlag = false
        self.resStr = "0"
        self.isConstant = false
        self.rad = false
        self.operation = ""
    }
    
    func HandleNum(_ num:String) -> String{
        if num == "e"{
            self.isConstant = true
            self.curNum = self.e
            self.resStr = String(self.curNum)
        }else if num == "π"{
            self.isConstant = true
            self.curNum = self.pi
            self.resStr = String(self.curNum)
        }
        else if num == "Rand"{
            self.isConstant = true
            self.curNum = Double(arc4random()) / Double(4294967295)
            self.resStr = String(self.curNum)
        }
        if self.isConstant == false{
            if num == "." && self.decPoint == false{
                self.decPoint = true
                self.resStr += "."
            }else{      // 0~9
                if self.resStr == "0"{
                    self.resStr = num
                }
                else{
                    self.resStr += num
                }
                self.curNum = Double(self.resStr)!
            }
        }
        return self.resStr
    }
    
    func IsSingleOp(_ op:String) -> Bool{
        if op=="%"||op=="AC"||op=="+/-"||op=="x²"||op=="x³"||op=="eˣ"||op=="10ˣ"||op=="1/x"||op=="²√x"||op=="³√x"||op=="ln"||op=="log₁₀"||op=="x!"||op=="sin"||op=="cos"||op=="tan"||op=="sinh"||op=="cosh"||op=="tanh"||op=="Rand"
        {
            return true
        }else{
            return false
        }
    }
    
    func HandleSingleOp(_ op:String) -> String{
        if op == "%"{
            self.curNum *= 0.01
            self.resStr = String(self.curNum)
        }else if op == "AC"{
            Clear()
            return "0"
        }else if op == "+/-"{
            self.negativeFlag = !self.negativeFlag
            if self.negativeFlag == true{
                self.resStr = "-" + self.resStr
            }
            else{
                self.resStr = String(self.resStr.dropFirst())
            }
            self.curNum *= -1
            return self.resStr
        }else if op == "x²"{
            self.curNum = pow(self.curNum, 2)
        }else if op == "x³"{
            self.curNum = pow(self.curNum, 3)
        }else if op == "eˣ"{
            self.curNum = pow(e, self.curNum)
        }else if op == "10ˣ"{
            self.curNum = pow(10, self.curNum)
        }else if op == "1/x"{
            if self.curNum == 0{
                self.resStr = "0"
                return "Error"
            }
            self.curNum = 1/self.curNum
        }else if op == "²√x"{
            self.curNum = pow(self.curNum, 1/2)
        }else if op == "³√x"{
            self.curNum = pow(self.curNum, 1/3)
        }else if op == "ln"{
            if self.curNum <= 0{
                self.resStr = "0"
                return "Error"
            }
            self.curNum = log(self.curNum)
        }else if op == "log₁₀"{
            if self.curNum <= 0{
                self.resStr = "0"
                return "Error"
            }
            self.curNum = log10(self.curNum)
        }else if op == "x!"{
            if self.curNum <= 0{
                self.resStr = "0"
                return "Error"
            }
            var tmp = 1
            var ans = 1
            while Double(tmp) < self.curNum{
                tmp += 1
                ans *= tmp
            }
            self.curNum = Double(ans)
        }else if op == "sin"{
            if rad{
                self.curNum = self.curNum / 180 * Double.pi
            }
            self.curNum = sin(self.curNum)
        }else if op == "cos"{
            if rad{
                self.curNum = self.curNum / 180 * Double.pi
            }
            self.curNum = cos(self.curNum)
        }else if op == "tan"{
            if rad{
                self.curNum = self.curNum / 180 * Double.pi
            }
            self.curNum = tan(self.curNum)
        }else if op == "rad"{
            self.rad = !self.rad
        }else if op == "sinh"{
            self.curNum = sinh(self.curNum)
        }else if op == "cosh"{
            self.curNum = cosh(self.curNum)
        }else if op == "tanh"{
            self.curNum = tanh(self.curNum)
        }
        let res = String(self.curNum)
        Clear()
        return res
    }
    
    func HandleDoubleOp(_ op:String) -> String{
        if self.operation == ""{
            self.lastNum = self.curNum
            self.resStr = "0"
        }
        else{
            if self.operation == "+"{
                self.curNum = self.lastNum + self.curNum
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "-"{
                self.curNum = self.lastNum - self.curNum
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "÷"{
                self.curNum = self.lastNum / self.curNum
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "×"{
                self.curNum = self.lastNum * self.curNum
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "xʸ"{
                self.curNum = pow(self.lastNum, self.curNum)
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "ʸ√x"{
                self.curNum = pow(self.lastNum, 1/self.curNum)
                self.lastNum = self.curNum
                self.resStr = "0"
            }else if self.operation == "="{
                self.resStr = "0"
            }
        }
        self.operation = op
        
        let res = String(self.curNum)
        self.isConstant = false
        self.negativeFlag = false
        self.decPoint = false
        return res
    }
    
    func HandleOp(_ op:String) -> String{
        var res = "0"
        if IsSingleOp(op){
            res = HandleSingleOp(op)
        }else {
            res = HandleDoubleOp(op)
        }
        return res
    }
}
