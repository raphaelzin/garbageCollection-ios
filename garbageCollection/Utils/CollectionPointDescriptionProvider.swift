//
//  CollectionPointDescriptionProvider.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-30.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension CollectionPoint.PointType {
    
    var longDescription: NSAttributedString {
        CollectionPointDescriptionProvider.description(for: self)
    }
    
}

fileprivate struct CollectionPointDescriptionProvider {
    
    static func description(for collectionPointType: CollectionPoint.PointType) -> NSAttributedString {
        switch collectionPointType {
        case .association: return associationDescription()
        case .ecopoint: return ecopointDescription()
        case .ogr: return ogrDescription()
        case .pcee: return pceeDescription()
        case .pev: return pevDescription()
        }
    }
    
    static let bodyAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray,
                                                                .font: UIFont.systemFont(ofSize: 14, weight: .medium)]
    
    static let headerAttr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label,
                                                        .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
    
    static func ecopointDescription() -> NSAttributedString {
        let mainBody = "Os ecopontos são locais adequados para o descarte gratuito de pequenas proporções de entulho, restos de poda, móveis e estofados velhos, além de óleo de cozinha, papelão, plásticos, vidros e metais. É nos Ecopontos onde pode-se ter acesso ao benefício do programa Recicla Fortaleza, que dá desconto na conta de energia e crédito no Bilhete Único pela troca dos recicláveis. Em breve, os créditos também poderão ser utilizados na conta de água."
        
        let secondaryHeader = "\n\nHorário\n\n"
        
        let secondaryBody = "Horário de funcionamento: Os ecopontos funcionam de segunda-feira a sábado, sempre de 8 às 12 horas e de 14 às 17 horas.\n\nPara atender à população, há em todos os ecopontos um funcionário da Ecofor Ambiental, concessionária da Prefeitura de Fortaleza, responsável pela gestão de resíduos sólidos urbanos, transmitindo orientações e recebendo o material. Um outro funcionário atesta a quantidade de resíduos depositados em cada contêiner dos ecopontos."
        
        let attrMain = NSAttributedString(string: mainBody, attributes: bodyAttr)
        
        let attrHeader = NSAttributedString(string: secondaryHeader, attributes: headerAttr)
        
        let attrSecondary = NSAttributedString(string: secondaryBody, attributes: bodyAttr)
        
        let buildString = NSMutableAttributedString(attributedString: attrMain)
        buildString.append(attrHeader)
        buildString.append(attrSecondary)
        
        return buildString
    }
    
    static func ogrDescription() -> NSAttributedString {
        let mainBody = "Pontos de coleta de óleo e gordura residual são pontos que recebem doações de óleo de cozinha. O descarte impróprio de óleo pode contaminar milhares de litros de água limpa.\n\nO material recolhido será encaminhado à Usina dos Catadores e posteriormente à Usina da Petrobrás, em Quixadá, para a geração de biodiesel."
        
        return NSAttributedString(string: mainBody, attributes: bodyAttr)
    }
    
    static func pceeDescription() -> NSAttributedString {
        let mainBody = "Pontos de coleta de eletro-eletrônicos , para que os mesmos sejam reaproveitados ou descartados de maneira adequada."
        
        return NSAttributedString(string: mainBody, attributes: bodyAttr)
    }
    
    static func pevDescription() -> NSAttributedString {
        let mainBody = "São disponibilizados pela Prefeitura Municipal de Fortaleza e a população pode depositar de forma voluntária materiais recicláveis, como plástico, papel, vidro e metal.\n\nEstão presente em locais com grande fluxo de pessoas como estações de ônibus. O material é doado a uma associação de catadores."
        
        return NSAttributedString(string: mainBody, attributes: bodyAttr)
    }
    
    static func associationDescription() -> NSAttributedString {
        let mainBody = "Nesses locais (em geral grandes galpões) os resíduos coletados pelos catadores ou proveniente de doações são separados e/ou beneficiados para posterior comercialização.\n\nAlgumas associações possuem convênio com shoppings e empresas que doam os resíduos gerados para as mesmas."
        
        return NSAttributedString(string: mainBody, attributes: bodyAttr)
    }
    
}
