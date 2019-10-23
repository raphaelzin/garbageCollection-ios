//
//  GCError.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-22.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

// Errors by domain

struct GCError {
    
    enum Server: Error {
        case invalidQueryResult
        case serverUnreachable
        case noDataFound
    }
    
    enum Misc: Error {
        case invalidquery
    }
    
}

// Error descriptions

extension GCError.Server: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidQueryResult: return "Houve um problema com a resposta do servidor, por favor, tente mais tarde."
        case .noDataFound: return "Não foram encontrados dados no servidor. Tente novamente mais tarde."
        case .serverUnreachable: return "Não foi possível se conectar com o servidor. Tente novamente mais tarde."
        }
    }
    
}

extension GCError.Misc: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidquery: return "Busca inválida, por favor tente novamente mais tarde."
        }
    }
    
}
