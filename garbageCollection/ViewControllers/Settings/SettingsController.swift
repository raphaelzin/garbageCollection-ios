//
//  SettingsController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit
import RxBiBinding
import Parse

protocol SettingsControllerCoordinatorDelegate: class {
    func didRequestSourceCode(from controller: SettingsController)
    func didRequestSuggestionForm(from controller: SettingsController)
    func didRequestNeighbourhoodSelection(from controller: SettingsController)
}

class SettingsController: GCViewModelController<SettingsViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: SettingsControllerCoordinatorDelegate?
    
    private let disposeBag = DisposeBag()
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
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

// MARK: Private methods

private extension SettingsController {
    
    func shareApp() {
        let items: [Any]
        
        if let shareAppMessage: String = PFConfig.current().getConfigValue(with: .shareURL) {
            items = [shareAppMessage]
        } else {
            let shareURL: String = PFConfig.current().getConfigValue(with: .shareURL) ?? ""
            items = ["Estou usando esse app pra coleta de lixo e pontos de coleta, da uma olhada ;)\n\n\(shareURL)"]
        }
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
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
            case .neighbourhood: return "Seu bairro"
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
        
        if field == .reminders {
            let switchControl = UISwitch()
            switchControl.isOn = InstallationManager.shared.notificationsEnabled.value
            (switchControl.rx.isOn <-> InstallationManager.shared.notificationsEnabled).disposed(by: disposeBag)
            cell.accessoryView = switchControl
        } else if field == .hints {
            let switchControl = UISwitch()
            switchControl.isOn = viewModel.hintsNotifications.value
            switchControl.rx.isOn.bind(to: viewModel.hintsNotifications).disposed(by: disposeBag)
            cell.accessoryView = switchControl
        } else if field == .neighbourhood, let label = cell.detailTextLabel {
            viewModel
                .selectedNeighbourhood
                .map { $0?.name ?? "Selecionar" }
                .asDriver(onErrorJustReturn: nil)
                .drive(label.rx.text)
                .disposed(by: disposeBag)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch SettingsSection.field(for: indexPath) {
        case .sourceCode:
            coordinatorDelegate?.didRequestSourceCode(from: self)
        case .sendSuggestions:
            coordinatorDelegate?.didRequestSuggestionForm(from: self)
        case .shareApp:
            shareApp()
        case .neighbourhood:
            coordinatorDelegate?.didRequestNeighbourhoodSelection(from: self)
        case .review:
            SKStoreReviewController.requestReview()
        default:
            print("To do")
        }
    }
    
}

extension SettingsController: NeighbourhoodSelectorDelegate {
    
    func didSelect(neighbourhood: Neighbourhood) {
        InstallationManager.shared.updateNeighbourhood(to: neighbourhood)
    }
    
}
