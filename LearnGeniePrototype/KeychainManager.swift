//
//  KeyChainManager.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 15.05.2023.
//
//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
import Foundation
import Security

class KeychainManager {
    
    private let service: String
    
    init(service: String) {
        self.service = service
    }
    
    private func getQueryDictionary(forKey key: String) -> [String: Any] {
        var queryDictionary: [String: Any] = [:]
        
        queryDictionary[kSecClass as String] = kSecClassGenericPassword
        queryDictionary[kSecAttrService as String] = service + key
        queryDictionary[kSecAttrAccount as String] = key
        
        return queryDictionary
    }
    
    func save(_ data: Data, forKey key: String) throws {
        var queryDictionary = getQueryDictionary(forKey: key)
        
        let result = SecItemCopyMatching(queryDictionary as CFDictionary, nil)
        switch result {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[kSecValueData as String] = data
            
            let updateStatus = SecItemUpdate(queryDictionary as CFDictionary, attributesToUpdate as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainError.unhandledError(status: updateStatus)
            }
            
        case errSecItemNotFound:
            queryDictionary[kSecValueData as String] = data
            
            let addStatus = SecItemAdd(queryDictionary as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.unhandledError(status: addStatus)
            }
            
        default:
            throw KeychainError.unhandledError(status: result)
        }
    }
    
    func load(forKey key: String) throws -> Data {
        var queryDictionary = getQueryDictionary(forKey: key)
        queryDictionary[kSecReturnData as String] = kCFBooleanTrue
        queryDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.unexpectedData
        }
        
        return data
    }
}

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
    case unexpectedData
}
