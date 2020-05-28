//
//  ViewController.swift
//  Labb_1
//
//  Created by Eric Johansson on 2020-02-13.
//  Copyright © 2020 Eric Johansson. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var searchInput: String = ""
    var cities: [String] = citiesFromFile()
    var filteredCities: [String] = []
    var index: Int = 0
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Sök på en stad"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchInput = searchController.searchBar.text ?? ""
        filteredCities = cities.filter( { $0.lowercased().contains(searchInput.lowercased()) } )
        animateTable()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "mySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       if segue.identifier == "mySegue" {
            let vc = segue.destination as? SelectedWeatherViewController
            vc?.currentCity = filteredCities[index]
        }
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        var delayCounter = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX:  0, y: tableViewHeight)
        }
        
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

func citiesFromFile() -> [String] {
    let fileName: String = "swedishCities"
    do {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data.init(contentsOf: file)
            let decoder = JSONDecoder()
            let cityObjects: [cityJSON] = try decoder.decode([cityJSON].self, from: data)
            var searchableCities: [String] = []
            for object in cityObjects {
                searchableCities.append(object.city)
            }
            return searchableCities
        }
    } catch {
        print("Json error")
    }
    return [String]()
}

struct cityJSON: Codable {
    let city: String
    let admin: String
    let country: String
    let population_proper: String
    let iso2: String
    let capital: String
    let lat: String
    let lng: String
    let population: String
}
