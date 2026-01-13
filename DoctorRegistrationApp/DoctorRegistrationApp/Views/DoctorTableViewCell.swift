//
//  DoctorTableViewCell.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import UIKit

class DoctorTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "DoctorTableViewCell"
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let guidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let practisingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(genderLabel)
        containerView.addSubview(guidLabel)
        containerView.addSubview(practisingLabel)
        containerView.addSubview(chevronImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Avatar
            avatarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 50),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Chevron
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 15),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Email
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Gender
            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // GUID
            guidLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 4),
            guidLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            guidLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Practising From
            practisingLabel.topAnchor.constraint(equalTo: guidLabel.bottomAnchor, constant: 4),
            practisingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            practisingLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.layer.cornerRadius = 25
        containerView.addCornerRadius(12)
        containerView.addShadow(opacity: 0.05, offset: CGSize(width: 0, height: 1), radius: 3)
    }
    
    // MARK: - Configuration
    
    func configure(with doctor: Doctor) {
        nameLabel.text = doctor.name
        emailLabel.text = doctor.email
        genderLabel.text = "Gender: \(doctor.gender)"
        guidLabel.text = "ID: \(doctor.shortGuid)"
        practisingLabel.text = "Age: \(doctor.age) \(doctor.ageUnit)"
        
        // Avatar initials
        let initials = doctor.name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
        avatarLabel.text = initials.isEmpty ? "?" : initials
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        emailLabel.text = nil
        genderLabel.text = nil
        guidLabel.text = nil
        practisingLabel.text = nil
        avatarLabel.text = nil
    }
}
