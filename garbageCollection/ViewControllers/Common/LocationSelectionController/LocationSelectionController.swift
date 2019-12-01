//
//  LocationSelectionController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol LocationSelectionControllerCoordinatorDelegate: class {
    func didRequestDismiss(from controller: UIViewController)
}

protocol LocationSelectionDelegate: class {
    func didSelect(location: Location)
}

class LocationSelectionController: GCViewModelController<LocationSelectionViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: LocationSelectionControllerCoordinatorDelegate?
    
    weak var delegate: LocationSelectionDelegate?
    
    private let disposeBag = DisposeBag()
    
    // MARK: Subviews
    
    private var selectectLocation = MKMarkerAnnotationView()
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapTap)))
        mv.showsUserLocation = true
        mv.delegate = self
        return mv
    }()
    
    private lazy var addressTextField: GCSearchBarView = {
        let tf = GCSearchBarView()
        tf.placeholder = "Procurar endereço"
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowRadius = 4
        tf.layer.shadowOpacity = 0.6
        tf.layer.shadowOffset = .zero
        
        return tf
    }()
    
    private lazy var centerPosition: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "map-pin"))
        iv.contentMode = .bottom
        return iv
    }()

    // MARK: LifeCycle
    
    override init(viewModel: LocationSelectionViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureNavBar()
        
        bindAddressSearch()
        bindLocationSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: false)
    }
    
}

// MARK: Bindings

private extension LocationSelectionController {
    
    func bindAddressSearch() {
        
        addressTextField
            .rx
            .text
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .flatMapLatest({ (address) -> Single<Location?> in
                self.viewModel.search(for: address)
            })
            .compactMap { $0 }
            .subscribe(onNext: { (location) in
                self.focus(on: location)
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindLocationSelected() {
        viewModel
            .selectedLocation
            .map { $0 != nil }
            .subscribe(onNext: { (hasSelectedLocation) in
                UIView.animate(withDuration: 0.3) {
                    self.centerPosition.alpha = hasSelectedLocation ? 1 : 0
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private layout methods

private extension LocationSelectionController {
    
    func configureLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.top.trailing.equalTo(view).inset(16)
        }
        
        view.addSubview(centerPosition)
        centerPosition.snp.makeConstraints { (make) in
            let size = #imageLiteral(resourceName: "map-pin").size
            make.size.equalTo(size)
            make.centerY.equalTo(mapView).offset(-size.height)
            make.centerX.equalTo(mapView)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Selecionar localização"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onSaveTap))
    }
    
}

// MARK: Private selectors

private extension LocationSelectionController {
    
    @objc func onSaveTap() {
        guard let location = viewModel.selectedLocation.value else {
            simpleAlert(withTitle: "Opa!",
                        message: "Você precisa selecionar um endereço antes de salvar.")
            return
        }
        delegate?.didSelect(location: location)
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
    @objc func onMapTap() {
        addressTextField.resignFirstResponder()
    }
    
}

// MARK: Map management

private extension LocationSelectionController {
    
    func focus(on location: Location) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
}

extension LocationSelectionController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard !addressTextField.isFirstResponder && viewModel.selectedLocation.value != nil else { return }
        let center = mapView.centerCoordinate
        viewModel
            .search(with: center.latitude, and: center.longitude)
            .subscribe(onSuccess: { (location) in
                if let location = location {
                    self.addressTextField.text = location.address
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
}
