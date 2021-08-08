//
//  ViewController.swift
//  Weather_Swift
//
//  Created by Priyanka Bandaru on 7/29/21.
//

import UIKit
private var locations = [Location]()
private var locationWeathers = LocationWeather()
var activityIndicatorView = UIActivityIndicatorView()
let loadingTextLabel = UILabel()

class ViewController: UIViewController {
    
    @IBOutlet weak var lblTheTemp: UILabel!
    @IBOutlet weak var lblPredictabilityTitle: UILabel!
    @IBOutlet weak var lblVisibilityTitle: UILabel!
    @IBOutlet weak var lblHumidityTitle: UILabel!
    @IBOutlet weak var lblAirPressureTitle: UILabel!
    @IBOutlet weak var lblWindDirectionTitle: UILabel!
    @IBOutlet weak var lblWindSpeedTitle: UILabel!
    @IBOutlet weak var lblMinTempTitle: UILabel!
    @IBOutlet weak var lblMaxTempTitle: UILabel!
    @IBOutlet weak var lblPredictability: UILabel!
    @IBOutlet weak var lblAirPressure: UILabel!
    @IBOutlet weak var lblApplicableDate: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var lblvisibility: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWeatherState: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initializoing the activity indicator with the customized styles defined in the code below
        activityIndicatorView =  self.activityIndicator(style:.large,center: self.view.center)
        self.view.addSubview(activityIndicatorView)
        self.view.isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
        
        //Methods to load the locations from JSON included in the project and also retrieving the weather information of the locations from the api.
        locations = Helper.loadLocationsfromJSON()
        loadLocationWeathers()
        self.imgWeather.isHidden = true
        self.view.backgroundColor = .black
        self.view.accessibilityIdentifier = "Weather View"
        
        
        //Adding Swipe gestures to swipe and view the temperatures of the different cities.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //adding accessibility identifiers for UITests
        self.lblCity.accessibilityIdentifier = "City Label"
        self.imgWeather.accessibilityIdentifier = "Weather Image"
        self.lblWeatherState.accessibilityIdentifier = "Weather State Label"
        self.lblTheTemp.accessibilityIdentifier = "Temp Label"
        self.lblMinTemp.accessibilityIdentifier = "Min Temp Label"
        self.lblMaxTemp.accessibilityIdentifier = "Max Temp Label"
        self.lblApplicableDate.accessibilityIdentifier = "Applicable Date Label"
    }
    
    //Method to load the locationWeather array from the API
    func loadLocationWeathers(){
        let dateTomorrow =  Helper.getTommorrowsDate()
        let group = DispatchGroup()
        for i in 0..<locations.count{
            group.enter()
            if let woeid = locations[i].woeid{
                APIHelper.fetchlocationWeather(woeid: woeid, date: dateTomorrow,completionHandler: { (locationWea) ->Void in
                    locations[i].locationWeathers = locationWea
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.imgWeather.isHidden = false
            self.loadView(indexTodisplay: 0)
            activityIndicatorView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    
    //Objective-c method to respond Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if let city = lblCity.text{
                    let indexToDisplay = Helper.getIndexToDisplay(swipeDirection:"right",currentLocation:city,fromLocation:locations)
                    loadView(indexTodisplay: indexToDisplay)
                }
            case UISwipeGestureRecognizer.Direction.left:
                if let city = lblCity.text{
                    let indexToDisplay  = Helper.getIndexToDisplay(swipeDirection:"left",currentLocation:city,fromLocation:locations)
                    loadView(indexTodisplay: indexToDisplay)
                }
            default:
                break
            }
        }
    }
    
    //Method to load the view with the location information for the index provided
    func loadView(indexTodisplay:Int){
        let location = locations[indexTodisplay]
        if let locationWeather = location.locationWeathers{
            let weatherState = locationWeather.weatherState
            let (bgImageName,weatherImageName) = Helper.getImageName(state:weatherState ?? " ")
            self.lblCity.accessibilityValue = location.title
            self.lblCity?.text = location.title
            self.imgWeather.accessibilityValue = weatherImageName
            self.imgWeather?.image = UIImage(named: weatherImageName)
            self.lblMaxTemp?.text = String(format: "%.0f",locationWeather.max_Temp ??  0.0) + "°C"
            self.lblMinTemp?.text = String(format: "%.0f",locationWeather.min_Temp ?? 0.0) + "°C"
            self.lblWeatherState?.text = locationWeather.weatherState
            self.lblTheTemp?.text = String(format: "%.0f",locationWeather.the_temp ?? 0.0) + "°C"
            self.lblvisibility?.text = String(format: "%.2f",locationWeather.visibility ?? 0.0)
            self.lblWindSpeed?.text = String(format: "%.2f",locationWeather.wind_speed ?? 0.0) + " " + (locationWeather.wind_direction_compass ?? " ")
            self.lblWindDirection?.text = String(format: "%.2f",locationWeather.wind_direction ?? 0.0)
            self.lblPredictability?.text = String(locationWeather.predictability ?? 0)
            self.lblAirPressure?.text = String(format: "%.2f",locationWeather.air_pressure ?? 0.0)
            self.lblHumidity?.text = String(format: "%.2f", locationWeather.humidity ?? 0.0)
            
            let date = Helper.convertDatefrom(string: locationWeather.applicable_date ?? " ")
            self.lblApplicableDate?.text = date
            if let bgImage = UIImage(named: bgImageName){
                self.view.backgroundColor = UIColor(patternImage:bgImage)
            }
            customizeViewOnWeather(state:weatherState ?? " ")
        }
        
    }
    
    
    //Function to customize the activity indicator as needed.
    func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                           frame: CGRect? = nil,
                           center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        // Initializing an indicator view with the style requested
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        
        // setting the frmae size of the activity indicator with the frame provided
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        
        // setting the position of the activity indicator view
        if let center = center {
            activityIndicatorView.center = center
        }
        
        // returning the customized activity indicator view
        return activityIndicatorView
    }
    
    func customizeViewOnWeather(state:String)->Void{
        if (state == Weather.thunderstorm || state == Weather.showers || state == Weather.heavyCloud || state == Weather.hail || state == Weather.lightRain){
            cutsomizeLabelColor(color:.white)
        }
        else if(state == Weather.sleet) {
            cutsomizeLabelColor(color:.blue)
        }
        else{
            cutsomizeLabelColor(color:.black)
        }
    }
    
    
    func cutsomizeLabelColor(color:UIColor)->Void{
        self.lblCity?.textColor = color
        self.lblMaxTemp?.textColor = color
        self.lblMinTemp?.textColor = color
        self.lblWeatherState?.textColor = color
        self.lblTheTemp?.textColor = color
        self.lblvisibility?.textColor = color
        self.lblWindSpeed?.textColor = color
        self.lblWindDirection?.textColor = color
        self.lblPredictability?.textColor = color
        self.lblAirPressure?.textColor = color
        self.lblHumidity?.textColor = color
        self.lblMaxTempTitle?.textColor = color
        self.lblMinTempTitle?.textColor = color
        self.lblVisibilityTitle?.textColor = color
        self.lblWindSpeedTitle?.textColor = color
        self.lblWindDirectionTitle?.textColor = color
        self.lblPredictabilityTitle?.textColor = color
        self.lblAirPressureTitle?.textColor = color
        self.lblHumidityTitle?.textColor = color
        self.lblApplicableDate?.textColor = color
    }
    
    
}
