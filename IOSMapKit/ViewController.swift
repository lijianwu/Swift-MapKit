//
//  ViewController.swift
//  IOSMapKit
//
//  Created by gdql－Apple on 16/3/28.
//  Copyright © 2016年 gdql－Apple. All rights reserved.
//

import UIKit
import MapKit


//地图代理自身protocol
class ViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        //地理编码
        //起始位置
        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        //终点位置
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        //起始标注
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location{
            sourceAnnotation.coordinate = location.coordinate
        }
        
        /// var字符串表示可以修改
        /// let字符串表示不允许修改
        //终点标注
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        if let location = destinationPlacemark.location{
            destinationAnnotation.coordinate = location.coordinate
        }
        
        //显示大头针标注
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        //定义方向请求
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        //计算方向位置
        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
            guard let response = response else{
                if let error = error{
                    print("Error: \(error)")
                }
                return
            }
            //路线
            let route = response.routes[0]
            //view中画线
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    //实现delegate方法
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    @IBOutlet weak var mapView: MKMapView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

