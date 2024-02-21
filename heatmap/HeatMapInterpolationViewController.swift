import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils

class HeatMapInterpolationViewController: UIViewController {


    private var mapView = GMSMapView()
    private var markers = [GMSMarker]()
    private var rendering = false
    private let interpolationController = HeatMapInterpolationPoints()
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as? [NSNumber]


    @IBOutlet weak var renderButton: UIButton!
    @IBOutlet weak var defaultRender: UIButton!


    private let alert = UIAlertController(
        title: "Render",
        message: "Enter an N value",
        preferredStyle: .alert
    )


    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 145.20, zoom: 5.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
        view.bringSubviewToFront(renderButton)
        view.bringSubviewToFront(defaultRender)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in

            self.executeHeatMap(nVal: Double(alert?.textFields![0].text ?? "0.0") ?? 0.0)
        }))
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256
        )

    }

    @IBAction func startRender(_ sender: Any) {
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func startDefaultRender(_ sender: Any) {
        executeHeatMap(nVal: 2.5)
    }

    private func executeHeatMap(nVal: Double) {


        interpolationController.removeAllData()

        let newGMU = GMUWeightedLatLng(
            coordinate: CLLocationCoordinate2D(latitude: -20.86 , longitude: 145.20),
            intensity: 100
        )
        interpolationController.addWeightedLatLng(latlng: newGMU)

        let listOfPoints = [
            GMUWeightedLatLng(
                coordinate: CLLocationCoordinate2D(latitude: -20.85, longitude: 145.20),
                intensity: 100
            ),
            GMUWeightedLatLng(
                coordinate: CLLocationCoordinate2D(latitude: -32, longitude: 145.20),
                intensity: 300
            ),
            GMUWeightedLatLng(
                coordinate: CLLocationCoordinate2D(latitude: 0, longitude: -145.20),
                intensity: 100
            )
        ]
        interpolationController.addWeightedLatLngs(latlngs: listOfPoints)

        do {
            let generatedPoints = try interpolationController.generatePoints(influence: nVal)

            heatmapLayer.map = nil

            heatmapLayer.weightedData = generatedPoints
            heatmapLayer.map = mapView
        } catch {
            print("\(error)")
        }
    }
}





extension UITextField {
    var floatValue : Float {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = numberFormatter.number(from: text!)
        return nsNumber == nil ? 0.0 : nsNumber!.floatValue
    }
}
