//
//  DoctorsListViewController.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import UIKit

class DoctorsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // MARK: - Properties
    
    private let viewModel = DoctorsListViewModel()
    private let refreshControl = UIRefreshControl()
    private var selectedDoctor: Doctor?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupRefreshControl()
        fetchDoctors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Doctors"
        
        // Navigation bar styling
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        // Empty state
        emptyStateLabel.text = "No doctors found.\nPull to refresh."
        emptyStateLabel.textColor = .gray
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.isHidden = true
        
        // Hide back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        // Register cell
        tableView.register(DoctorTableViewCell.self, forCellReuseIdentifier: DoctorTableViewCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Data Fetching
    
    private func fetchDoctors() {
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
        
        viewModel.fetchDoctors { [weak self] error in
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                self?.updateEmptyState()
                return
            }
            
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
    }
    
    @objc private func refreshData() {
        fetchDoctors()
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !viewModel.isEmpty
        tableView.isHidden = viewModel.isEmpty
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDashboard",
           let dashboardVC = segue.destination as? DashboardViewController,
           let doctor = selectedDoctor {
            dashboardVC.viewModel.setDoctor(doctor)
        }
    }
}

// MARK: - UITableViewDataSource

extension DoctorsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDoctors
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoctorTableViewCell.identifier, for: indexPath) as? DoctorTableViewCell,
              let doctor = viewModel.doctor(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: doctor)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DoctorsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let doctor = viewModel.doctor(at: indexPath.row) {
            selectedDoctor = doctor
            performSegue(withIdentifier: "showDashboard", sender: nil)
        }
    }
}
