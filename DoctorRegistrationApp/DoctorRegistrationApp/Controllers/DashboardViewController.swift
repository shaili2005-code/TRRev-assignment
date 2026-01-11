//
//  DashboardViewController.swift
//  DoctorRegistrationApp
//
//  Complete programmatic Dashboard with all UI elements
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = DashboardViewModel()
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // Header
    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.91, green: 0.96, blue: 0.99, alpha: 1.0)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(red: 0.9, green: 0.85, blue: 0.95, alpha: 1.0)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let greetingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Hello,"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Doctor!"
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var notificationButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bell"), for: .normal)
        btn.tintColor = .darkGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        btn.tintColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return btn
    }()
    
    // Search
    private let searchContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 25
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search..."
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Banner
    private let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.35, green: 0.45, blue: 0.85, alpha: 1.0)
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let bannerTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Stay Safe\nStay Healthy!"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bannerSubtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "An apple a day\nkeeps the doctor away."
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.white.withAlphaComponent(0.9)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var bannerCloseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 0.95, green: 0.45, blue: 0.35, alpha: 1.0)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeBannerTapped), for: .touchUpInside)
        return btn
    }()
    
    // Section Title
    private let sectionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "At your Fingertip"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Quick Action Buttons
    private let buttonsRow1: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let buttonsRow2: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    // Footer Tab Bar
    private let footerTabBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDoctorData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1, alpha: 1.0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to content
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(greetingLabel)
        headerView.addSubview(nameLabel)
        headerView.addSubview(notificationButton)
        headerView.addSubview(logoutButton)
        
        contentView.addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        contentView.addSubview(bannerView)
        bannerView.addSubview(bannerTitleLabel)
        bannerView.addSubview(bannerSubtitleLabel)
        bannerView.addSubview(bannerCloseButton)
        
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(buttonsRow1)
        contentView.addSubview(buttonsRow2)
        contentView.addSubview(activityIndicator)
        
        // Add footer tab bar
        view.addSubview(footerTabBar)
        
        // Setup quick action buttons
        setupQuickActionButtons()
        
        // Setup footer
        setupFooterTabBar()
        
        setupConstraints()
    }
    
    private func setupQuickActionButtons() {
        let buttons1 = [
            createQuickButton(icon: "qrcode.viewfinder", title: "Scan", highlighted: true),
            createQuickButton(icon: "cross.vial", title: "Vaccine", highlighted: false),
            createQuickButton(icon: "calendar", title: "My Bookings", highlighted: false)
        ]
        
        let buttons2 = [
            createQuickButton(icon: "building.2", title: "Clinic", highlighted: false),
            createQuickButton(icon: "cross.case", title: "Ambulance", highlighted: false),
            createQuickButton(icon: "person.crop.circle.badge.plus", title: "Nurse", highlighted: false)
        ]
        
        buttons1.forEach { buttonsRow1.addArrangedSubview($0) }
        buttons2.forEach { buttonsRow2.addArrangedSubview($0) }
    }
    
    private func createQuickButton(icon: String, title: String, highlighted: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = highlighted ? UIColor(red: 0.96, green: 0.55, blue: 0.25, alpha: 1.0) : .white
        container.layer.cornerRadius = 16
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.08
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 6
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = highlighted ? .white : UIColor(red: 0.45, green: 0.55, blue: 0.85, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = highlighted ? .white : UIColor(red: 0.45, green: 0.55, blue: 0.85, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconView)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 90),
            
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4)
        ])
        
        return container
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerTabBar.topAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Profile Image
            profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Greeting
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            greetingLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            
            // Name
            nameLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 2),
            
            // Notification
            notificationButton.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -8),
            notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 40),
            notificationButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Logout
            logoutButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 40),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Search Container
            searchContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            searchContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            searchContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Search Icon
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // Search TextField
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            
            // Banner
            bannerView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 20),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bannerView.heightAnchor.constraint(equalToConstant: 140),
            
            // Banner Title
            bannerTitleLabel.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 20),
            bannerTitleLabel.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 20),
            
            // Banner Subtitle
            bannerSubtitleLabel.leadingAnchor.constraint(equalTo: bannerTitleLabel.leadingAnchor),
            bannerSubtitleLabel.topAnchor.constraint(equalTo: bannerTitleLabel.bottomAnchor, constant: 8),
            
            // Banner Close
            bannerCloseButton.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 12),
            bannerCloseButton.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: -12),
            bannerCloseButton.widthAnchor.constraint(equalToConstant: 32),
            bannerCloseButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Section Title
            sectionTitleLabel.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 24),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Buttons Row 1
            buttonsRow1.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 16),
            buttonsRow1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsRow1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Buttons Row 2
            buttonsRow2.topAnchor.constraint(equalTo: buttonsRow1.bottomAnchor, constant: 16),
            buttonsRow2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsRow2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsRow2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -120),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Footer Tab Bar
            footerTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerTabBar.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    private func setupFooterTabBar() {
        footerTabBar.backgroundColor = .white
        footerTabBar.layer.shadowColor = UIColor.black.cgColor
        footerTabBar.layer.shadowOpacity = 0.1
        footerTabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        footerTabBar.layer.shadowRadius = 8
        
        let tabItems = [
            ("house.fill", "Home", true),
            ("calendar", "Appointments", false),
            ("message", "Chat", false),
            ("clock.arrow.circlepath", "History", false),
            ("person.circle", "Profile", false)
        ]
        
        let tabStack = UIStackView()
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        
        for (icon, title, isSelected) in tabItems {
            let tabButton = createTabButton(icon: icon, title: title, selected: isSelected)
            tabStack.addArrangedSubview(tabButton)
        }
        
        footerTabBar.addSubview(tabStack)
        
        NSLayoutConstraint.activate([
            tabStack.topAnchor.constraint(equalTo: footerTabBar.topAnchor, constant: 8),
            tabStack.leadingAnchor.constraint(equalTo: footerTabBar.leadingAnchor, constant: 8),
            tabStack.trailingAnchor.constraint(equalTo: footerTabBar.trailingAnchor, constant: -8),
            tabStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createTabButton(icon: String, title: String, selected: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = selected ? UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0) : .gray
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 10, weight: selected ? .semibold : .regular)
        label.textColor = selected ? UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0) : .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconView)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        return container
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
    
    // MARK: - Actions
    
    @objc private func closeBannerTapped() {
        UIView.animate(withDuration: 0.3) {
            self.bannerView.alpha = 0
        } completion: { _ in
            self.bannerView.isHidden = true
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            // Pop to root (registration screen)
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

