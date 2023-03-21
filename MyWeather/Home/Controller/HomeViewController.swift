//
//  HomeViewController.swift
//  MyWeather
//
//  Created by nidhi.lalani on 19/03/23.
//

import UIKit
import CoreLocation
import GooglePlaces

class HomeViewController: UIViewController {

    //MARK: - Outlets -

    @IBOutlet weak var tblWeatherData: UITableView!

    //MARK: - Properties -

    var homeViewModel: HomeViewModel?
    var getCurrentLocation = CLLocation()
   

    //MARK: - ViewController Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModels()
        homeViewModel?.getLocalCityName()
    }
}

//MARK: - Private Function calls -

private extension HomeViewController {

    /// setup initialUI

    func setUpUI() {
        var image = UIImage(named: "serach")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(searchCity))
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = NSLocalizedString("Weather Information", comment: "")
        tblWeatherData.register(CityWeatherDataTableViewCell.nib(), forCellReuseIdentifier: CityWeatherDataTableViewCell.identifire)
    }
    
    func setUpModels() {
        self.homeViewModel?.onData = { [weak self] data in
            self?.reloadTableView()
        }

        self.homeViewModel?.onError = { [weak self] (title, message) in
            self?.showErrorAlert(title: title, message: message)
        }

        // Api Call for get wether data based on lat, long

        self.homeViewModel?.getLocalWeather()
    }

    ///  GooglePlace autoComplete to serchByCity from USA

    @objc func searchCity() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue) |
                                                                   UInt(GMSPlaceField.placeID.rawValue)))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.countries = ["US"]
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblWeatherData.reloadData()
        }
    }

    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true)
    }
}

//MARK: - UITableview Datasource Delegate -

///  Used tableview with purpose of future integration is required to get historydata or something

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let weatherdataCell = tableView.dequeueReusableCell(
            withIdentifier: "CityWeatherDataTableViewCell",
            for: indexPath) as? CityWeatherDataTableViewCell {

            weatherdataCell.lblCityName.text = homeViewModel?.locality
            if let data = homeViewModel?.weatherData {
                weatherdataCell.updateCityWeatherData(weatherData: data)
            }

            return weatherdataCell
        }
        return UITableViewCell()
    }

    private func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate -

extension HomeViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let locality = place.name {
            self.homeViewModel?.getWeatherForCity(city: locality)
        }
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        showErrorAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
