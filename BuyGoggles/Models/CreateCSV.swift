//
//  CreateCSV.swift
//  BuyGoggles
//
//  Created by Eddie Char on 12/19/20.
//

import Foundation

struct CreateCSV {
        
    static func commaSeparatedValueDataForLines(lines: [[String]]) -> Data {
        return lines.map { column in
            commaSeparatedValueStringForColumns(columns: column)
        }.joined(separator: "\r\n").data(using: String.Encoding.utf8)!
    }
    
    private static func commaSeparatedValueStringForColumns(columns: [String]) -> String {
        return columns.map { column in
            quoteColumn(column: column)
        }.joined(separator: ",")
    }

    private static func quoteColumn(column: String) -> String {
        if column.contains(",") || column.contains("\"") {
            return "\"" + column.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        else {
            return column
        }
    }
}
