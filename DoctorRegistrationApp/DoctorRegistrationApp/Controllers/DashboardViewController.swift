//
//  DashboardViewController.swift
//  DoctorRegistrationApp
//
//  Dashboard with storyboard UI - only name is dynamic
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let viewModel = DashboardViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgrammaticUI()
        loadDoctorData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Data Loading
    
    private func loadDoctorData() {
        if viewModel.doctor != nil {
            updateUI()
            return
        }
        
        guard viewModel.doctorGuid != nil else {
            nameLabel.text = "Doctor!"
            return
        }
        
        activityIndicator.startAnimating()
        
        viewModel.fetchDoctorDetails { [weak self] error in
            self?.activityIndicator.stopAnimating()
            
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.doctorName + "!"
    }
    
    // MARK: - IBActions
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Dashboard Button View
class DashboardButton: UIView {
    
    private let container: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.05
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    init(title: String, iconName: String, isPrimary: Bool = false) {
        super.init(frame: .zero)
        setupUI(title: title, iconName: iconName, isPrimary: isPrimary)
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupUI(title: String, iconName: String, isPrimary: Bool) {
        addSubview(container)
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        
        // Colors
        if isPrimary {
            container.backgroundColor = UIColor(red: 1.0, green: 0.584, blue: 0.282, alpha: 1.0) // Orange
            iconImageView.tintColor = .white
            titleLabel.textColor = .white
        } else {
            container.backgroundColor = .white
            iconImageView.tintColor = UIColor(red: 0.35, green: 0.45, blue: 0.9, alpha: 1.0) // Soft Blue
            titleLabel.textColor = UIColor(red: 0.35, green: 0.45, blue: 0.9, alpha: 1.0)
        }
        
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4)
        ])
    }
}

// MARK: - Dashboard UI Extension
extension DashboardViewController {
    
    func setupProgrammaticUI() {
        // 1. Logout Button (Top Right)
        let logoutBtn = UIButton(type: .system)
        logoutBtn.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutBtn.tintColor = .systemRed
        logoutBtn.addTarget(self, action: #selector(logoutTapped(_:)), for: .touchUpInside)
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutBtn)
        
        // 2. Grid Container
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 16
        gridStack.distribution = .fillEqually
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridStack)
        
        // Rows
        let row1 = createRow(items: [
            ("Scan", "qrcode.viewfinder", true), // Orange
            ("Vaccine", "cross.case.fill", false),
            ("My Bookings", "calendar", false)
        ])
        
        let row2 = createRow(items: [
            ("Clinic", "building.2.fill", false),
            ("Ambulance", "staroflife.fill", false),
            ("Nurse", "person.fill.checkmark", false)
        ])
        
        gridStack.addArrangedSubview(row1)
        gridStack.addArrangedSubview(row2)
        
        // 3. Bottom Bar
        let bottomBar = createBottomBar()
        view.addSubview(bottomBar)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Logout Button
            logoutBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutBtn.widthAnchor.constraint(equalToConstant: 30),
            logoutBtn.heightAnchor.constraint(equalToConstant: 30),
            
            // Grid - Positioned lower to avoid overlapping existing "At your fingertip" label
            gridStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 360),
            gridStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            gridStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            gridStack.heightAnchor.constraint(equalToConstant: 240),
            
            // Bottom Bar
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func createRow(items: [(String, String, Bool)]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        for item in items {
            let btn = DashboardButton(title: item.0, iconName: item.1, isPrimary: item.2)
            stack.addArrangedSubview(btn)
        }
        return stack
    }
    
    private func createBottomBar() -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: -2)
        container.layer.shadowRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let items = [
            ("Home", "house.fill", true),
            ("Appointments", "calendar", false),
            ("Chat", "message.fill", false),
            ("History", "clock.fill", false),
            ("Profile", "person.circle", false)
        ]
        
        for item in items {
            let itemStack = UIStackView()
            itemStack.axis = .vertical
            itemStack.alignment = .center
            itemStack.spacing = 4
            
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: item.1, withConfiguration: config)
            let imageView = UIImageView(image: image)
            imageView.tintColor = item.2 ? UIColor(red: 0.35, green: 0.45, blue: 0.9, alpha: 1.0) : .gray
            
            let label = UILabel()
            label.text = item.0
            label.font = .systemFont(ofSize: 10)
            label.textColor = item.2 ? UIColor(red: 0.35, green: 0.45, blue: 0.9, alpha: 1.0) : .gray
            
            itemStack.addArrangedSubview(imageView)
            itemStack.addArrangedSubview(label)
            
            stack.addArrangedSubview(itemStack)
        }
        
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            // stack.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        return container
    }
}
