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

class LocationSelectionController: GCViewModelController<LocationSelectionViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: LocationSelectionControllerCoordinatorDelegate?
    
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
    
    private lazy var addressTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 22
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .no
        tf.leftViewMode = .always
        tf.backgroundColor = .systemBackground
        let imv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imv.contentMode = .center
        imv.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        tf.leftView = imv
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addMarker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
}

// MARK: Private selectors

private extension LocationSelectionController {
    
    @objc func onSaveTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
    @objc func onMapTap() {
        addressTextField.resignFirstResponder()
    }
    
}

// MARK: Map management

private extension LocationSelectionController {
    
    func focus(on location: Location) {
        print("Focusing on \(location.address)")
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
}

extension LocationSelectionController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        viewModel
            .search(with: center.latitude, and: center.longitude)
            .subscribe(onSuccess: { (location) in
                if let location = location {
                    print(location)
                    self.addressTextField.text = location.address
                } else {
                    print("No address found")
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
}
