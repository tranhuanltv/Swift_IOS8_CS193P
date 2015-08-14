//
//  CalculatorBrain.swift
//  Calculate
//
//  Created by HuanTran on 8/9/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description : String {
            switch(self)
            {
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knowOps = [String:Op]()
    
    init()
    {
        knowOps["×"] = Op.BinaryOperation("×", *)
        knowOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knowOps["+"] = Op.BinaryOperation("+", +)
        knowOps["−"] = Op.BinaryOperation("−", { $1 - $0 })
        knowOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops : [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand): return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let firstEvaluation = evaluate(remainingOps);
                if let result1 = firstEvaluation.result {
                    let secondEvaluation = evaluate(firstEvaluation.remainingOps)
                    if let result2 = secondEvaluation.result {
                        return (operation(result1, result2), secondEvaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluation() -> Double?
    {
        let (result, ops) = evaluate(opStack)
        println("Result \(result) in \(ops)");
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluation()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operand = knowOps[symbol] {
            opStack.append(operand)
            return evaluation()
        }
        
        return nil
    }
}