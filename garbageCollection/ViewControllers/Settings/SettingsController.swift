//
//  SettingsController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol SettingsControllerCoordinatorDelegate: class {
    
}

class SettingsController: GCViewModelController<SettingsViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: SettingsControllerCoordinatorDelegate?
    
    // MARK: Subviews
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.registerCell(cellClass: BasicTableViewCell.self)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: Lifecycle
    
    override init(viewModel: SettingsViewModelType) {
        super.init(viewModel: viewModel)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private Layout methods

private extension SettingsController {
    
    func configureView() {
        navigationItem.title = "Configurações"
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Configurações", image: UIImage(systemName: "gear"), tag: 0)
        }
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

// MARK: Custom types

extension SettingsController {
    
    enum SettingsField: UITableViewCellConfigurator {
        case neighbourhood, hints, reminders, sendSuggestions, shareApp, review, sourceCode
        
        var accessory: UITableViewCell.AccessoryType {
            switch self {
            case .neighbourhood, .sendSuggestions, .shareApp, .review, .sourceCode:
                return .disclosureIndicator
            default: return .none
            }
        }
        
        var title: String {
            switch self {
            case .neighbourhood: return "Bairro"
            case .hints: return "Dicas"
            case .reminders: return "Lembretes de coletas"
            case .sendSuggestions: return "Enviar sugestões ou críticas"
            case .shareApp: return "Compartilhar o aplicativo"
            case .review: return "Avaliar o app"
            case .sourceCode: return "Código fonte"
            }
        }
    }
    
    enum SettingsSection: CaseIterable {
        case aboutYou, notifications, aboutTheApp
        
        var header: String {
            switch self {
            case .notifications: return "Notificações"
            case .aboutTheApp: return "Sobre o app"
            case .aboutYou: return "Sobre você"
            }
        }
        
        var footer: String? {
            switch self {
            case .notifications: return "Dicas são notificações silenciosas sobre as melhores maneiras para descartar certos matérias ou novidades do sistema."
            case .aboutYou, .aboutTheApp: return nil
            }
        }
        
        // Private static methods and attributes
        
        static let numberOfSections = 3
        
        static func fields(for section: Int) -> [SettingsField] {
            guard (0..<SettingsSection.numberOfSections).contains(section) else {
                fatalError("\(section) Invalid section ")
            }
            
            if section == 0 {
                return [.neighbourhood]
            } else if section == 1 {
                return [.hints, .reminders]
            } else {
                return [.sendSuggestions, .shareApp, .review, .sourceCode]
            }
        }

        static func field(for indexPath: IndexPath) -> SettingsField {
            fields(for: indexPath.section)[indexPath.row]
        }
    }
    
}

// MARK: TableView management

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        SettingsSection.allCases[section].footer
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SettingsSection.allCases[section].header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsSection.fields(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = SettingsSection.field(for: indexPath)
        let cell = tableView.dequeue(cellClass: BasicTableViewCell.self, indexPath: indexPath)
        cell.configure(with: field)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
