//
//  LocationSelectionViewModelTest.swift
//  garbageCollectionTests
//
//  Created by Raphael Souza on 2020-04-26.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import XCTest
import RxSwift

@testable import garbageCollection

class LocationSelectionViewModelTest: XCTestCase {

    var viewModel: LocationSelectionViewModel!
    
    var bag: DisposeBag?
    
    override func setUp() {
        viewModel = LocationSelectionViewModel(geocoderManager: MockGeocoderManager())
        bag = DisposeBag()
    }
    
    override func tearDown() {
        bag = nil
    }

    func test_valid_address() {
        viewModel.search(for: "Any valid Address").subscribe(onSuccess: { (location) in
            XCTAssertNotNil(location, "Location should not be nil for a given test address")
        }, onError: { error in
            XCTFail(error.localizedDescription)
        }).disposed(by: bag!)
    }

    func test_invalid_address() {
         viewModel.search(for: "").subscribe(onSuccess: { (location) in
             XCTAssertNil(location, "Location should be nil for an empty address")
         }, onError: { error in
             XCTFail(error.localizedDescription)
         }).disposed(by: bag!)
    }
    
    func test_valid_coordinates() {
        viewModel.search(with: 10, and: 20).subscribe(onSuccess: { (location) in
             XCTAssertNotNil(location, "Location should not be nil for given coordnates")
         }, onError: { error in
             XCTFail(error.localizedDescription)
         }).disposed(by: bag!)
    }

    func test_invalid_coordinates() {
        viewModel.search(with: 0, and: 0).subscribe(onSuccess: { (location) in
             XCTAssertNil(location, "Location should be nil for invalid coordinates")
         }, onError: { error in
             XCTFail(error.localizedDescription)
         }).disposed(by: bag!)
    }
    
}
