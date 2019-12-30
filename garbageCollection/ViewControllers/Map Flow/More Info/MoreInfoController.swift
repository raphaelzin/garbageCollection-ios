//
//  MoreInfoController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-30.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class MoreInfoController: UIViewController {
    
    // MARK: Attributes
    
    private let types = CollectionPoint.PointType.allCases
    
    // MARK: Subviews
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.registerCell(cellClass: CollectionPointTypeCell.self)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension MoreInfoController {
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

// MARK: TableView management

extension MoreInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "As informações acima e no mapa foram obtidos a partir da plataforma de dados abertos em:\nhttps://mapas.fortaleza.ce.gov.br/"
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Tipos de pontos de coleta"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CollectionPointTypeCell.self, indexPath: indexPath)
        cell.configure(with: types[indexPath.row])
        return cell
    }
    
}
