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
    
    enum UserInteraction: Error {
        case invalidReportInput
        case invalidFeedbackInput
    }
    
    enum Server: Error {
        case invalidQueryResult
        case serverUnreachable
        case noDataFound
    }
    
    enum ServerData: Error {
        case invalidCoordinates
        case invalidPhoneNumber
    }
    
    enum Misc: Error {
        case invalidquery
        case invalidUser
    }
    
    enum Geocoder: Error {
        case invalidGeocoderResponse
    }
    
}

// Error descriptions

extension GCError.UserInteraction {
    
    var errorDescription: String? {
        switch self {
        case .invalidReportInput: return "Houve um problema ao criar o reporte. Verifique se há uma foto, localização e data válida ou tente novamente mais tarde"
        case .invalidFeedbackInput: return "Houve um erro ao enviar seu comentário. Verifique se o campo de comentário não está vazio e tente novamente."
        }
    }
    
}

extension GCError.Server: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidQueryResult: return "Houve um problema com a resposta do servidor, por favor, tente mais tarde."
        case .noDataFound: return "Não foram encontrados dados no servidor. Tente novamente mais tarde."
        case .serverUnreachable: return "Não foi possível se conectar com o servidor. Tente novamente mais tarde."
        }
    }
}

extension GCError.ServerData {
    
    var errorDescription: String? {
        switch self {
        case .invalidCoordinates: return "Coordenadas invalidas, por favor, tente mais tarde."
        case .invalidPhoneNumber: return "Número de telefone inválido, tente novamente mais tarde."
        }
    }
    
}

extension GCError.Geocoder: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidGeocoderResponse: return "Houve um problema com este endereço, tente novamente mais tarde."
        }
    }
    
}

extension GCError.Misc: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidUser: return "Houve um erro com o seu usuário. Tente novamente mais tarde."
        case .invalidquery: return "Busca inválida, por favor tente novamente mais tarde."
        }
    }
    
}
