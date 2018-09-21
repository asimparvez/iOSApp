//
//  DeliveryDetailsVCViewController.swift
//  iOSApp
//
//  Created by Asim Parvez on 9/21/18.
//  Copyright © 2018 Asim Parvez. All rights reserved.
//

import UIKit
import GoogleMaps

class DeliveryDetailsVC: BaseViewController {

   var delivery: Delivery!
    private lazy var mapView: GMSMapView  = {
        let camera = GMSCameraPosition.camera(withLatitude: delivery.lat.doubleValue, longitude: delivery.lng.doubleValue, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: delivery.lat.doubleValue, longitude: delivery.lng.doubleValue)
        marker.title = delivery.address
        marker.snippet = String(format: "Latitude: %.2f, Longitude: %.2f", delivery.lat.floatValue,delivery.lng.floatValue)
        marker.map = mapView
        return mapView
    }()
   private lazy var lblDescription: UILabel  = {
        let lblDescription = UILabel()
        lblDescription.numberOfLines = 0
        lblDescription.text = delivery.descriptionStr
        return lblDescription
    }()
   private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        let imgURL = URL.init(string: delivery.imageUrl)
        imgView.sd_setImage(with: imgURL, completed: nil)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    //MARK: - SetUpView
    
    private func setUI() {
        title = "Delivery Details"
        view.addSubview(mapView)
        view.addSubview(imgView)
        view.addSubview(lblDescription)

        mapView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.6)
        }
        
        imgView.snp.makeConstraints{(make) -> Void in
            make.leading.equalToSuperview().offset(8)
            make.top.equalTo(mapView.snp.bottom).offset(24)
            make.width.height.equalTo(60)
        }
        
        lblDescription.snp.makeConstraints{(make) -> Void in
            make.leading.equalTo(imgView.snp.trailing).offset(8)
            make.top.equalTo(imgView)
            make.centerY.equalTo(imgView)
        }

    }
    
}


//MARK: -  ViewComponents
extension DeliveryDetailsVC {
    fileprivate func createMapView() -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: delivery.lat.doubleValue, longitude: delivery.lng.doubleValue, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: delivery.lat.doubleValue, longitude: delivery.lng.doubleValue)
        marker.title = delivery.address
        marker.snippet = String(format: "Latitude: %.2f, Longitude: %.2f", delivery.lat.floatValue,delivery.lng.floatValue)
        marker.map = mapView
        return mapView
    }
}
