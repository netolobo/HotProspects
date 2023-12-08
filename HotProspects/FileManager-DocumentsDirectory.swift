//
//  FileManager+GetDocumentsDirectory.swift
//  BucketList
//
//  Created by Neto Lobo on 26/11/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
