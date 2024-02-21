import Foundation
import GoogleMaps
import UIKit
import GoogleMapsUtils

class HeatmapViewController: UIViewController, GMSMapViewDelegate {
  private var mapView: GMSMapView!
  private var heatmapLayer: GMUHeatmapTileLayer!
  private var button: UIButton!

  private var gradientColors = [UIColor.green, UIColor.red]
  private var gradientStartPoints = [0.2, 1.0] as [NSNumber]

  override func loadView() {
    let camera = GMSCameraPosition.camera(withLatitude: -37.848, longitude: 145.001, zoom: 10)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    self.view = mapView
    makeButton()
  }

  override func viewDidLoad() {

    heatmapLayer = GMUHeatmapTileLayer()
    heatmapLayer.radius = 80
    heatmapLayer.opacity = 0.8
    heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                        startPoints: gradientStartPoints,
                                        colorMapSize: 256)
    addHeatmap()

    heatmapLayer.map = mapView
  }

  func addHeatmap()  {
    var list = [GMUWeightedLatLng]()
    do {
      if let path = Bundle.main.url(forResource: "samples", withExtension: "json") {
        let data = try Data(contentsOf: path)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = json as? [[String: Any]] {
          for item in object {
            let lat = item["lat"]
            let lng = item["lng"]
            let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
            list.append(coords)
          }
        } else {
          print("Could not read the JSON.")
        }
      }
    } catch {
      print(error.localizedDescription)
    }
    heatmapLayer.weightedData = list
  }

  @objc
  func removeHeatmap() {
    heatmapLayer.map = nil
    heatmapLayer = nil
    button.isEnabled = false
  }

  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
  }

  func makeButton() {
    button = UIButton(frame: CGRect(x: 5, y: 150, width: 200, height: 35))
    button.backgroundColor = .blue
    button.alpha = 0.5
    button.setTitle("Remove heatmap", for: .normal)
    button.addTarget(self, action: #selector(removeHeatmap), for: .touchUpInside)
    self.mapView.addSubview(button)
  }
}


