//
//  MultiStepRegistrationViewController.swift
//  DoctorRegistrationApp
//
//  Multi-step slidable registration with arrow navigation
//

import UIKit

class MultiStepRegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = RegistrationViewModel()
    private var currentStep = 0
    private let totalSteps = 3  // 3 slides total
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.isScrollEnabled = false
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // Progress Bar
    private let progressContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let progressBarOrange: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 2
        return v
    }()
    
    private let progressBarGray: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 1.0)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 2
        return v
    }()
    
    private var progressWidthConstraint: NSLayoutConstraint?
    
    // Back Button
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("‹", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
        btn.tintColor = .darkGray
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()
    
    // Step Label - Updated format: "1/3"
    private let stepLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "1/3"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Title & Subtitle
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Basic Details"
        lbl.font = UIFont.boldSystemFont(ofSize: 26)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Feel free to fill your details"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Step 1 Fields - Name & Email
    private let nameLabel: UILabel = createFieldLabel("Full Name")
    private let nameTextField: UITextField = createTextField(placeholder: "Name")
    private let emailLabel: UILabel = createFieldLabel("Email ID")
    private let emailTextField: UITextField = createTextField(placeholder: "Email ID")
    
    // Step 2 Fields - Phone & WhatsApp
    private let phoneLabel: UILabel = createFieldLabel("Phone Number")
    private let countryCodeTextField: UITextField = createTextField(placeholder: "+91")
    private let phoneTextField: UITextField = createTextField(placeholder: "Phone Number")
    private let whatsappLabel: UILabel = createFieldLabel("WhatsApp Number")
    private let whatsappTextField: UITextField = createTextField(placeholder: "WhatsApp Number")
    
    // Step 3 Fields - Gender, Age & Practice
    private let genderLabel: UILabel = createFieldLabel("Gender")
    private lazy var maleButton: UIButton = createGenderButton("Male", selected: true)
    private lazy var femaleButton: UIButton = createGenderButton("Female", selected: false)
    private lazy var othersButton: UIButton = createGenderButton("Others", selected: false)
    private let ageLabel: UILabel = createFieldLabel("Age")
    private let ageTextField: UITextField = createTextField(placeholder: "Age")
    private let ageUnitTextField: UITextField = createTextField(placeholder: "Years")
    private let practiceLabel: UILabel = createFieldLabel("Practicing From")
    private let monthsTextField: UITextField = createTextField(placeholder: "Months")
    private let yearsTextField: UITextField = createTextField(placeholder: "Years")
    
    // Submit/Next Button
    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("→", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0)
        btn.layer.cornerRadius = 35
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 8
        return btn
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    // Step containers
    private let step1Container = UIView()
    private let step2Container = UIView()
    private let step3Container = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissal()
        updateProgress()
        updateStepLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(progressContainer)
        progressContainer.addSubview(progressBarGray)
        progressContainer.addSubview(progressBarOrange)
        view.addSubview(stepLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        view.addSubview(actionButton)
        view.addSubview(activityIndicator)
        
        // Setup step containers
        step1Container.translatesAutoresizingMaskIntoConstraints = false
        step2Container.translatesAutoresizingMaskIntoConstraints = false
        step3Container.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(step1Container)
        contentStackView.addArrangedSubview(step2Container)
        contentStackView.addArrangedSubview(step3Container)
        
        setupStep1()
        setupStep2()
        setupStep3()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            progressContainer.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressContainer.heightAnchor.constraint(equalToConstant: 4),
            
            progressBarGray.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressBarGray.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBarGray.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progressBarGray.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            progressBarOrange.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressBarOrange.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBarOrange.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            stepLabel.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 20),
            stepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -30),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            step1Container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            step2Container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            step3Container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            actionButton.widthAnchor.constraint(equalToConstant: 70),
            actionButton.heightAnchor.constraint(equalToConstant: 70),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
        ])
        
        progressWidthConstraint = progressBarOrange.widthAnchor.constraint(equalTo: progressContainer.widthAnchor, multiplier: 1.0/3.0)
        progressWidthConstraint?.isActive = true
    }
    
    private func setupStep1() {
        step1Container.addSubview(nameLabel)
        step1Container.addSubview(nameTextField)
        step1Container.addSubview(emailLabel)
        step1Container.addSubview(emailTextField)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: step1Container.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor, constant: 24),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: step1Container.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor, constant: 24),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: step1Container.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupStep2() {
        countryCodeTextField.text = "+91"
        countryCodeTextField.textAlignment = .center
        phoneTextField.keyboardType = .phonePad
        whatsappTextField.keyboardType = .phonePad
        
        let phoneStack = UIStackView(arrangedSubviews: [countryCodeTextField, phoneTextField])
        phoneStack.axis = .horizontal
        phoneStack.spacing = 12
        phoneStack.translatesAutoresizingMaskIntoConstraints = false
        
        step2Container.addSubview(phoneLabel)
        step2Container.addSubview(phoneStack)
        step2Container.addSubview(whatsappLabel)
        step2Container.addSubview(whatsappTextField)
        
        NSLayoutConstraint.activate([
            countryCodeTextField.widthAnchor.constraint(equalToConstant: 70),
            
            phoneLabel.topAnchor.constraint(equalTo: step2Container.topAnchor, constant: 10),
            phoneLabel.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor, constant: 24),
            
            phoneStack.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            phoneStack.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor, constant: 24),
            phoneStack.trailingAnchor.constraint(equalTo: step2Container.trailingAnchor, constant: -24),
            phoneStack.heightAnchor.constraint(equalToConstant: 50),
            
            whatsappLabel.topAnchor.constraint(equalTo: phoneStack.bottomAnchor, constant: 20),
            whatsappLabel.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor, constant: 24),
            
            whatsappTextField.topAnchor.constraint(equalTo: whatsappLabel.bottomAnchor, constant: 8),
            whatsappTextField.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor, constant: 24),
            whatsappTextField.trailingAnchor.constraint(equalTo: step2Container.trailingAnchor, constant: -24),
            whatsappTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupStep3() {
        let genderStack = UIStackView(arrangedSubviews: [maleButton, femaleButton, othersButton])
        genderStack.axis = .horizontal
        genderStack.spacing = 12
        genderStack.distribution = .fillEqually
        genderStack.translatesAutoresizingMaskIntoConstraints = false
        
        let ageStack = UIStackView(arrangedSubviews: [ageTextField, ageUnitTextField])
        ageStack.axis = .horizontal
        ageStack.spacing = 12
        ageStack.distribution = .fillEqually
        ageStack.translatesAutoresizingMaskIntoConstraints = false
        
        let practiceStack = UIStackView(arrangedSubviews: [monthsTextField, yearsTextField])
        practiceStack.axis = .horizontal
        practiceStack.spacing = 12
        practiceStack.distribution = .fillEqually
        practiceStack.translatesAutoresizingMaskIntoConstraints = false
        
        ageTextField.keyboardType = .numberPad
        ageUnitTextField.text = "Years"
        monthsTextField.keyboardType = .numberPad
        yearsTextField.keyboardType = .numberPad
        
        step3Container.addSubview(genderLabel)
        step3Container.addSubview(genderStack)
        step3Container.addSubview(ageLabel)
        step3Container.addSubview(ageStack)
        step3Container.addSubview(practiceLabel)
        step3Container.addSubview(practiceStack)
        
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: step3Container.topAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            
            genderStack.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 12),
            genderStack.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            genderStack.trailingAnchor.constraint(equalTo: step3Container.trailingAnchor, constant: -24),
            genderStack.heightAnchor.constraint(equalToConstant: 44),
            
            ageLabel.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 20),
            ageLabel.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            
            ageStack.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            ageStack.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            ageStack.widthAnchor.constraint(equalToConstant: 200),
            ageStack.heightAnchor.constraint(equalToConstant: 50),
            
            practiceLabel.topAnchor.constraint(equalTo: ageStack.bottomAnchor, constant: 20),
            practiceLabel.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            
            practiceStack.topAnchor.constraint(equalTo: practiceLabel.bottomAnchor, constant: 8),
            practiceStack.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor, constant: 24),
            practiceStack.widthAnchor.constraint(equalToConstant: 200),
            practiceStack.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    private static func createFieldLabel(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    private static func createTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    private func createGenderButton(_ title: String, selected: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 22
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(genderTapped(_:)), for: .touchUpInside)
        
        let orange = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        if selected {
            btn.backgroundColor = orange
            btn.setTitleColor(.white, for: .normal)
        } else {
            btn.backgroundColor = .clear
            btn.layer.borderWidth = 1
            btn.layer.borderColor = orange.cgColor
            btn.setTitleColor(orange, for: .normal)
        }
        return btn
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        if currentStep > 0 {
            currentStep -= 1
            animateToStep(currentStep)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func actionButtonTapped() {
        dismissKeyboard()
        
        switch currentStep {
        case 0:
            // Validate step 1
            guard let name = nameTextField.text, !name.isEmpty else {
                showAlert("Please enter your name")
                return
            }
            guard let email = emailTextField.text, !email.isEmpty else {
                showAlert("Please enter your email")
                return
            }
            viewModel.name = name
            viewModel.email = email
            currentStep = 1
            animateToStep(currentStep)
            
        case 1:
            // Validate step 2
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlert("Please enter your phone number")
                return
            }
            viewModel.countryCode = countryCodeTextField.text ?? "+91"
            viewModel.phoneNumber = phone
            viewModel.whatsappNumber = whatsappTextField.text?.isEmpty == false ? whatsappTextField.text! : phone
            currentStep = 2
            animateToStep(currentStep)
            
        case 2:
            // Validate step 3 and submit
            guard let age = ageTextField.text, !age.isEmpty else {
                showAlert("Please enter your age")
                return
            }
            guard let months = monthsTextField.text, !months.isEmpty else {
                showAlert("Please enter months")
                return
            }
            guard let years = yearsTextField.text, !years.isEmpty else {
                showAlert("Please enter years")
                return
            }
            viewModel.age = age
            viewModel.ageUnit = ageUnitTextField.text ?? "Years"
            viewModel.practFromMonth = months
            viewModel.practFromYear = years
            submitRegistration()
            
        default:
            break
        }
    }
    
    @objc private func genderTapped(_ sender: UIButton) {
        let orange = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        
        [maleButton, femaleButton, othersButton].forEach { btn in
            btn.backgroundColor = .clear
            btn.layer.borderWidth = 1
            btn.layer.borderColor = orange.cgColor
            btn.setTitleColor(orange, for: .normal)
        }
        
        sender.backgroundColor = orange
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderWidth = 0
        
        if sender == maleButton {
            viewModel.gender = "M"
        } else if sender == femaleButton {
            viewModel.gender = "F"
        } else {
            viewModel.gender = "O"
        }
    }
    
    // MARK: - Navigation & Animation
    
    private func animateToStep(_ step: Int) {
        let offsetX = CGFloat(step) * scrollView.bounds.width
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = offsetX
        }
        updateProgress()
        updateStepLabel()
    }
    
    private func updateProgress() {
        progressWidthConstraint?.isActive = false
        let multiplier = CGFloat(currentStep + 1) / CGFloat(totalSteps)
        progressWidthConstraint = progressBarOrange.widthAnchor.constraint(equalTo: progressContainer.widthAnchor, multiplier: multiplier)
        progressWidthConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateStepLabel() {
        // Format: "1/3", "2/3", "3/3"
        stepLabel.text = "\(currentStep + 1)/\(totalSteps)"
        
        switch currentStep {
        case 0:
            titleLabel.text = "Basic Details"
            subtitleLabel.text = "Enter your name and email"
        case 1:
            titleLabel.text = "Contact Info"
            subtitleLabel.text = "Enter your phone numbers"
        case 2:
            titleLabel.text = "Additional Info"
            subtitleLabel.text = "Complete your profile"
        default:
            break
        }
    }
    
    // MARK: - Registration
    
    private func submitRegistration() {
        activityIndicator.startAnimating()
        actionButton.isEnabled = false
        actionButton.alpha = 0.6
        
        do {
            try viewModel.validateInputs()
        } catch {
            activityIndicator.stopAnimating()
            actionButton.isEnabled = true
            actionButton.alpha = 1.0
            showAlert(error.localizedDescription)
            return
        }
        
        viewModel.register { [weak self] result in
            self?.activityIndicator.stopAnimating()
            self?.actionButton.isEnabled = true
            self?.actionButton.alpha = 1.0
            
            switch result {
            case .success(_):
                self?.showSuccessAndNavigate()
            case .failure(let error):
                self?.showAlert("Registration failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func showSuccessAndNavigate() {
        let alert = UIAlertController(title: "Success!", message: "Registration completed successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "showDoctorsList", sender: nil)
        })
        present(alert, animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
