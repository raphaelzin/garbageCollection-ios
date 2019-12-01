//
//  MapController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

protocol MapControllerCoordinatorDelegate: class {
    func didRequestFilterSelection(from controller: MapController, with currentFilters: [CollectionPoint.PointType])
    func didRequestRubbishReport(from controller: MapController)
}

class MapController: GCViewModelController<MapViewModelType> {
    
    weak var coordinatorDelegate: MapControllerCoordinatorDelegate?
    
    private let locationManager = CLLocationManager()

    private let disposeBag = DisposeBag()
    
    // MARK: Subviews
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        return map
    }()
    
    private lazy var filterButton: GCExpandableButton = {
        let btn = GCExpandableButton()
        btn.contentTextColor = .brownGrey
        btn.delegate = self
        
        let image = UIImage(systemName: "line.horizontal.3.decrease.circle")?.withTintColor(.defaultBlue, renderingMode: .alwaysOriginal)
        btn.buttonIcon = image
        
        return btn
    }()
    
    private lazy var reportButton: GCExpandableButton = {
        let btn = GCExpandableButton()
        btn.contentTextColor = .white
        btn.buttonBackgroundColor = .orangeyRed
        btn.contentBackgroundColor = .orangeyRed
        btn.delegate = self
        
        let image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.buttonIcon = image
        
        return btn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: 115)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.registerCell(cellClass: CollectionPointCollectionViewCell.self)
        cv.clipsToBounds = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        cv.rx.setDelegate(self).disposed(by: disposeBag)
        return cv
    }()
    
    // MARK: Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reportButton.setState(.expanded, afterInterval: 1)
        reportButton.setState(.collapsed, afterInterval: 3)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override init(viewModel: MapViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureView()
        
        bindCollectionPoints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private Layout methods

private extension MapController {
    
    func configureView() {
        navigationItem.title = "Pontos de coleta"
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Mapa", image: UIImage(systemName: "map"), tag: 0)
        }
    }
    
    func configureLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(24)
            make.trailing.equalTo(view).offset(-16)
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(36)
        }
        
        view.addSubview(reportButton)
        reportButton.snp.makeConstraints { (make) in
            make.top.equalTo(filterButton.snp.bottom).offset(12)
            make.trailing.equalTo(view).offset(-16)
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(36)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(115)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
    
}

// MARK: Bindings

private extension MapController {
    
    func bindCollectionPoints() {
        viewModel
            .collectionPoints
            .bind { [weak self] (collectionPoints) in
                self?.setupMarkers(with: collectionPoints)
        }.disposed(by: disposeBag)
        
        viewModel
            .collectionPoints
            .bind(to: collectionView.rx.items(cellIdentifier: CollectionPointCollectionViewCell.defaultIdentifier,
                                              cellType: CollectionPointCollectionViewCell.self)) { _, model, cell in
                                                cell.configure(with: model)
        }.disposed(by: disposeBag)
    }
    
}

// MARK: Map management

extension MapController: MKMapViewDelegate {
    
    func setupMarkers(with collectionPoints: [CollectionPoint]) {
        mapView.removeAnnotations(mapView.annotations)
        let markers = collectionPoints.map { CollectionPointMarker(collectionPoint: $0) }
        
        for marker in markers {
            mapView.addAnnotation(marker)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CollectionPointMarker else { return nil }
        return CollectionPointAnnotationView(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CollectionPointMarker,
            let index = viewModel.indexPath(of: annotation.collectionPoint) else { return }
        focus(on: annotation.collectionPoint)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    func focus(on collectionPoint: CollectionPoint) {
        guard let annotation = (mapView.annotations.filter { ($0 as? CollectionPointMarker)?.collectionPoint == collectionPoint }.first) else { return }
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
    }
    
    func select(collectionPoint: CollectionPoint) {
        
    }
    
 }

// MARK: Delegate conformances

extension MapController: GCExpandableButtonDelegate {
    
    func didTap(button: GCExpandableButton) {
        if button == filterButton {
            coordinatorDelegate?.didRequestFilterSelection(from: self, with: viewModel.selectedFilters)
        } else {
            coordinatorDelegate?.didRequestRubbishReport(from: self)
        }
    }
    
}

extension MapController: FilterSelectorDelegate {
    
    func didSelect(filters: [CollectionPoint.PointType]) {
        let content = filters.count == CollectionPoint.PointType.allCases.count ? "" : filters.map { $0.shortName }.joined(separator: " / ")
        filterButton.setContent(content)
        viewModel.updateSelected(filters: filters)
    }
    
}

extension MapController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + scrollView.bounds.width/2
        guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: offset, y: 0)) else { return }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        mapView.selectAnnotation(mapView.annotations[indexPath.row], animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
}