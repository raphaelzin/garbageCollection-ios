//
//  RubbishReportController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift

protocol RubbishReportControllerDelegate: class {
    func didRequestDismiss(from controller: RubbishReportController)
    func didRequestDetailsInput(from controller: RubbishReportController)
    func didRequestDateSelection(from controller: RubbishReportController, callback: @escaping (Date) -> Void)
}

class RubbishReportController: GCViewModelController<RubbishReportViewModelType> {
    
    // MARK: Attributes
    
    private let disposeBag = DisposeBag()
    
    weak var coordinatorDelegate: RubbishReportControllerDelegate?
    
    // MARK: Subviews
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.registerCell(cellClass: UITableViewCell.self)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private lazy var headerView: PictureSelectionView = {
        let view = PictureSelectionView()
        view.delegate = self
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(viewModel: RubbishReportViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureNavigationBar()
        configuretableViewHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Subtypes

extension RubbishReportController {
    
    enum FieldType: Int, UITableViewCellConfigurator, CaseIterable {
        case `where`, when, details
        
        var accessory: UITableViewCell.AccessoryType {
            switch self {
            case .where, .details: return .disclosureIndicator
            default: return .none
            }
        }
        
        var title: String {
            switch self {
            case .details: return "Você tem mais detalhes?"
            case .when: return "Quando você viu o entulho?"
            case .where: return "Onde está o entulho?"
            }
        }
        
        var header: String {
            switch self {
            case .details: return "Mais detalhes (opcional)"
            case .when: return "Quando"
            case .where: return "Onde"
            }
        }
        
        var footer: String? {
            switch self {
            case .details: return "Mais detalhes podem incluir quaisquer informações que possam auxiliar a prefeitura a lidar com descarte."
            default: return nil
            }
        }
    }
    
}

// MARK: Private layout methods

private extension RubbishReportController {
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
    
    func configuretableViewHeader() {
        tableView.tableHeaderView = headerView
        headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Reportar entulho"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Fechar", style: .plain, target: self, action: #selector(onCloseTap))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(onSaveTap))
    }
}

// MARK: Private selectors

extension RubbishReportController {
    
    @objc func onCloseTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
    @objc func onSaveTap() {
        print(#function)
    }
    
}

// MARK: TableView management

extension RubbishReportController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        FieldType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        FieldType.allCases[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        FieldType.allCases[section].footer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = FieldType(rawValue: indexPath.section)!
        let cell = tableView.dequeue(cellClass: UITableViewCell.self, indexPath: indexPath)
        
        cell.configure(with: fieldType)
        cell.bindContent(with: viewModel.driver(for: fieldType),
                         placeholder: fieldType.title,
                         disposeBag: disposeBag)
        
        return cell
    }
    
}

extension RubbishReportController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch FieldType(rawValue: indexPath.section)! {
        case .details:
            coordinatorDelegate?.didRequestDetailsInput(from: self)
        case .when:
            coordinatorDelegate?.didRequestDateSelection(from: self) { [weak viewModel] date in
                viewModel?.whenRelay.accept(date)
            }
        default:
            print("To do")
        }
        
    }
    
}

// MARK: delegate conformances

extension RubbishReportController: TextInputControllerDelegate {
    
    func didEnter(text: String) {
        viewModel.detailsRelay.accept(text)
    }
    
}

extension RubbishReportController: PictureSelectionViewDelegate {
    
    func didRequestPicture(from pictureSelectionView: PictureSelectionView) {
        print("Did enter: \(pictureSelectionView)")
    }
    
}
