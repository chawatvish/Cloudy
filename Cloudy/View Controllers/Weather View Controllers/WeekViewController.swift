//
//  WeekViewController.swift
//  Cloudy
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit

protocol WeekViewControllerDelegate {
    func controllerDidRefresh(controller: WeekViewController)
}

class WeekViewController: WeatherViewController {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: -
    
    var delegate: WeekViewControllerDelegate?
    
    // MARK: -
    
    var viewModel: WeekViewViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Public Interface
    
    override func reloadData() {
        updateView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupTableView()
        setupRefreshControl()
    }
    
    private func updateView() {
        activityIndicatorView.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        
        if let viewModel = viewModel {
            updateWeatherDataContainer(withViewModel: viewModel)
            
        } else {
            messageLabel.isHidden = false
            messageLabel.text = "Cloudy was unable to fetch weather data."
            
        }
    }
    
    // MARK: -
    
    private func setupTableView() {
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    private func setupRefreshControl() {
        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(WeekViewController.didRefresh(sender:)), for: .valueChanged)
        
        // Update Table View)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: -
    
    private func updateWeatherDataContainer(withViewModel viewModel: WeekViewViewModel) {
        weatherDataContainer.isHidden = false
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func didRefresh(sender: UIRefreshControl) {
        delegate?.controllerDidRefresh(controller: self)
    }
    
}

extension WeekViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableViewCell.reuseIdentifier, for: indexPath) as? WeatherDayTableViewCell else { fatalError("Unexpected Table View Cell") }
        
        if let viewModel = viewModel {
            // Configure Cell
            cell.dayLabel.text = viewModel.day(for: indexPath.row)
            cell.dateLabel.text = viewModel.date(for: indexPath.row)
            cell.temperatureLabel.text = viewModel.temperature(for: indexPath.row)
            cell.windSpeedLabel.text = viewModel.windSpeed(for: indexPath.row)
            cell.iconImageView.image = viewModel.image(for: indexPath.row)
        }
        return cell
    }
}
