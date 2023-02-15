//
//  ValidateTool.swift
//  HappyBonus
//
//  Created by yuanyuan on 2018/12/10.
//  Copyright © 2018年 MIX. All rights reserved.
//

import UIKit

class ValidateTool {
    static let shared = ValidateTool()
    
    //MARK: - 验证手机号是否合法
    func verifyIsPhoneNum(_ num: String) -> Bool{
        let mobileRegex = "^((1[3-9][0-9]))\\d{8}$"
        let mobileTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: num)
    }
    
    //MARK: - 验证密码是否符合要求(6-18位英文字母、数字或者符号的两种及以上组合,必须包含大写字母)
    func validatePassword(password: String) -> Bool {
        let passwordRegex = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,32}$"
        let passwordlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordlTest.evaluate(with: password)
    }
    
    //MARK: - 验证6位数字密码的正则
    func validateFundPassword(password: String) -> Bool {
        let passwordRegex = "^\\d{6}$"
        let passwordlTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordlTest.evaluate(with: password)

    }

    /// 密码: 6-16位英文或字母的组合
    static func vaildatePassword(_ pwd: String) -> Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: pwd)
    }
    
    
    static let ens = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".map{ String($0)}
    static let numbers = "0123456789".map { String($0) }
    static let symbols = """
                !#$%&'()*+,-.:;<=>?@[]^_`{|}~
                """.map{ String($0) }
    
    enum FundpwdInputError {
        case length, format
        var stringValue: String {
            return self == .length ? "长度6-18个字符" : "请重新设置，试试数字、字母、符号"
        }
    }
    /// 资金密码: 6-18位英文字母/数字/符号, 不能纯数字或纯字母
    static func validFundPwd(_ pwd: String) -> FundpwdInputError? {

        if pwd.count > 18 || pwd.count < 6 {
            return FundpwdInputError.length
        } else {
            var enExit = false, numExit = false, symbolExit = false
            for c in pwd {
                if !enExit { enExit = ens.contains(String(c)) }
                if !numExit { numExit = numbers.contains(String(c)) }
                if !symbolExit { symbolExit = symbols.contains(String(c)) }
                // 如果全是false说明不符合格式
                if !enExit, !numExit, !symbolExit { return .format }
            }
            // 最后, 不能是纯
            let correct = [enExit, numExit, symbolExit].filter({ $0 }).count > 1
            return correct ? nil : .format
        }
    }
}
