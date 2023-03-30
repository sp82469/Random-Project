//
//  SingletonClass.swift
//  Practice
//
//  Created by Admin on 15/03/23.
//

import Foundation

class Singleton {
    static let object = Singleton(number: 0,code: 0)
    var number : Int
    var code : Int
    private init(number : Int,code  : Int)
    {
        self.number = number
        self.code = code
    }
}

class SingletonSecond {
    static let object = SingletonSecond(number: 0,code: 0)
    var number : Int
    var code : Int
    private init(number : Int,code  : Int)
    {
        self.number = number
        self.code = code
    }
}
