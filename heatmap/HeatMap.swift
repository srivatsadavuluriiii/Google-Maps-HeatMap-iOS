//
//  ViewController.swift
//  heatmap
//
//  Created by srivatsa davuluri on 21/02/24.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils




class Heatmap: UIViewController {

  private var mapView: GMSMapView!
  private var heatmapLayer: GMUHeatmapTileLayer!

  override func viewDidLoad() {
    super.viewDidLoad()
    heatmapLayer = GMUHeatmapTileLayer()
    heatmapLayer.map = mapView
  }

  // ...

  func addHeatmap() {

    // Get the data: latitude/longitude positions of police stations.
    guard let path = Bundle.main.url(forResource: "police_stations", withExtension: "json") else {
      return
    }
    guard let data = try? Data(contentsOf: path) else {
      return
    }
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
      return
    }
    guard let object = json as? [[String: Any]] else {
      print("Could not read the JSON.")
      return
    }

    var list = [GMUWeightedLatLng]()
    for item in object {
      let lat = item["lat"] as! CLLocationDegrees
      let lng = item["lng"] as! CLLocationDegrees
      let coords = GMUWeightedLatLng(
        coordinate: CLLocationCoordinate2DMake(lat, lng),
        intensity: 1.0
      )
      list.append(coords)
    }

    // Add the latlngs to the heatmap layer.
    heatmapLayer.weightedData = list
  }
}
      
