//
//  dats.swift
//  Otopark_Takip_Sistemi
//
//  Created by Ibrahim Gok on 26.01.2022.
//

import Foundation
import UIKit

// veri tababnından çekilen verilerin derlenmesi için kod yapısının oluşturulması.

struct hospital_data: Identifiable {
    
    var il : String = ""
    var id : String = ""
    var park_ismi : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var emptySpace : String = ""
    
    
    
    init(raw: [String]) {
        il = raw[0]
        id = raw[1]
        park_ismi = raw[2]
        latitude = raw[3]
        longitude = raw[4]
        emptySpace = raw[5]
        
    }
}

// Veri tabanından verilerin çekilemsi için kod yapısının oluşturulması.

func loadCSV(from csvName: String) -> [hospital_data] {
    var csvToStruct = [hospital_data]()
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }
    
    var data = ""
    
    do {
      data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return[]
    }
    
    var rows = data.components(separatedBy: "\n")
    
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
        let hospitalDataStruct = hospital_data.init(raw: csvColumns)
        csvToStruct.append(hospitalDataStruct)
        }
    }
    return csvToStruct
}

