//
//  MapViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/16/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - Properties
    var viewModel: MapViewModel?
    let locationManager = CLLocationManager()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        mapView.delegate = self
        mapView.showsUserLocation = true
        draw()
    }
    
    func draw() {
        guard let viewModel = viewModel else { return }
        let source = CLLocationCoordinate2D(latitude: viewModel.latCurrent, longitude: viewModel.longCurrent)
        let destination = CLLocationCoordinate2D(latitude: viewModel.venue.location?.lat ?? 0.0, longitude: viewModel.venue.location?.long ?? 0.0)
        addPin(coordinate: destination, title: viewModel.venue.name ?? "", subTitle: viewModel.titleForVenue())
        routing(source: source, destination: destination)
    }

    func addPin(coordinate: CLLocationCoordinate2D, title: String, subTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }

    func routing(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, _ in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 3
            return renderer
        } else if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            circleRenderer.strokeColor = .blue
            circleRenderer.lineWidth = 1
            circleRenderer.lineDashPhase = 10
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
    }
}
