//
//  MultiStepRegistrationViewController.swift
//  DoctorRegistrationApp
//
//  Multi-step registration - hybrid approach with programmatic text fields
//

import UIKit

class MultiStepRegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets (from storyboard)
    
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progressBarOrange: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Programmatic Text Fields (for reliable touch handling)
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email ID"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let countryCodeTextField: UITextField = {
        let tf = UITextField()
        tf.text = "+91"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let whatsappTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "WhatsApp Number"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let ageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Age"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let monthsTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Month"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let yearsTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Year"
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 16)
        tf.keyboardType = .numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var maleButton: UIButton = createGenderButton(title: "Male")
    private lazy var femaleButton: UIButton = createGenderButton(title: "Female")
    private lazy var othersButton: UIButton = createGenderButton(title: "Others")
    
    // Step containers
    private let step1Container = UIView()
    private let step2Container = UIView()
    private let step3Container = UIView()
    
    // MARK: - Properties
    
    private let viewModel = RegistrationViewModel()
    private var currentStep = 0
    private let totalSteps = 3
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgrammaticUI()
        setupKeyboardDismissal()
        updateProgress()
        updateStepUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetForm()
    }
    
    private func resetForm() {
        // Reset inputs
        nameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        whatsappTextField.text = ""
        countryCodeTextField.text = "+91"
        ageTextField.text = ""
        
        // Reset unused fields just in case
        yearsTextField.text = ""
        monthsTextField.text = ""
        
        // Reset selection buttons
        [maleButton, femaleButton, othersButton].forEach {
            $0.backgroundColor = .clear
            $0.setTitleColor(UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0), for: .normal)
            $0.layer.borderColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0).cgColor
        }
        
        // Reset state
        currentStep = 0
        updateProgress()
        updateStepUI()
        
        // Reset container visibility
        step1Container.isHidden = false
        step2Container.isHidden = true
        step3Container.isHidden = true
        
        // Select default gender
        selectGender(maleButton)
    }
    
    // MARK: - Setup Programmatic UI
    
    private func setupProgrammaticUI() {
        // Setup progress bar corner radius
        progressBarOrange?.layer.cornerRadius = 2
        progressContainer?.layer.cornerRadius = 2
        
        // Setup action button
        actionButton?.layer.cornerRadius = 35
        actionButton?.layer.shadowColor = UIColor.black.cgColor
        actionButton?.layer.shadowOpacity = 0.2
        actionButton?.layer.shadowOffset = CGSize(width: 0, height: 4)
        actionButton?.layer.shadowRadius = 8
        
        setupStep1()
        setupStep2()
        setupStep3()
        
        // Initial state
        step1Container.isHidden = false
        step2Container.isHidden = true
        step3Container.isHidden = true
    }
    
    private func setupStep1() {
        step1Container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(step1Container)
        
        let nameLabel = createFieldLabel(text: "Full Name")
        let emailLabel = createFieldLabel(text: "Email ID")
        
        step1Container.addSubview(nameLabel)
        step1Container.addSubview(nameTextField)
        step1Container.addSubview(emailLabel)
        step1Container.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            step1Container.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            step1Container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            step1Container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: step1Container.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: step1Container.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: step1Container.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: step1Container.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.bottomAnchor.constraint(equalTo: step1Container.bottomAnchor)
        ])
    }
    
    private func setupStep2() {
        step2Container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(step2Container)
        
        let phoneLabel = createFieldLabel(text: "Phone Number")
        let whatsappLabel = createFieldLabel(text: "WhatsApp Number")
        
        step2Container.addSubview(phoneLabel)
        step2Container.addSubview(countryCodeTextField)
        step2Container.addSubview(phoneTextField)
        step2Container.addSubview(whatsappLabel)
        step2Container.addSubview(whatsappTextField)
        
        NSLayoutConstraint.activate([
            step2Container.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            step2Container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            step2Container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            phoneLabel.topAnchor.constraint(equalTo: step2Container.topAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor),
            
            countryCodeTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            countryCodeTextField.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor),
            countryCodeTextField.widthAnchor.constraint(equalToConstant: 70),
            countryCodeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeTextField.trailingAnchor, constant: 12),
            phoneTextField.trailingAnchor.constraint(equalTo: step2Container.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            whatsappLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 24),
            whatsappLabel.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor),
            
            whatsappTextField.topAnchor.constraint(equalTo: whatsappLabel.bottomAnchor, constant: 8),
            whatsappTextField.leadingAnchor.constraint(equalTo: step2Container.leadingAnchor),
            whatsappTextField.trailingAnchor.constraint(equalTo: step2Container.trailingAnchor),
            whatsappTextField.heightAnchor.constraint(equalToConstant: 50),
            whatsappTextField.bottomAnchor.constraint(equalTo: step2Container.bottomAnchor)
        ])
    }
    
    private func setupStep3() {
        step3Container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(step3Container)
        
        let genderLabel = createFieldLabel(text: "Gender")
        let ageLabel = createFieldLabel(text: "Age")
        
        let genderStack = UIStackView(arrangedSubviews: [maleButton, femaleButton, othersButton])
        genderStack.axis = .horizontal
        genderStack.spacing = 12
        genderStack.distribution = .fillEqually
        genderStack.translatesAutoresizingMaskIntoConstraints = false
        
        step3Container.addSubview(genderLabel)
        step3Container.addSubview(genderStack)
        step3Container.addSubview(ageLabel)
        step3Container.addSubview(ageTextField)
        
        // Select male by default
        selectGender(maleButton)
        
        NSLayoutConstraint.activate([
            step3Container.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            step3Container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            step3Container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            genderLabel.topAnchor.constraint(equalTo: step3Container.topAnchor),
            genderLabel.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor),
            
            genderStack.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            genderStack.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor),
            genderStack.trailingAnchor.constraint(equalTo: step3Container.trailingAnchor),
            genderStack.heightAnchor.constraint(equalToConstant: 44),
            
            ageLabel.topAnchor.constraint(equalTo: genderStack.bottomAnchor, constant: 24),
            ageLabel.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor),
            
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            ageTextField.leadingAnchor.constraint(equalTo: step3Container.leadingAnchor),
            ageTextField.widthAnchor.constraint(equalToConstant: 100),
            ageTextField.heightAnchor.constraint(equalToConstant: 50),
            ageTextField.bottomAnchor.constraint(equalTo: step3Container.bottomAnchor)
        ])
    }
    
    private func createFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createGenderButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0).cgColor
        button.setTitleColor(UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(genderTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func backTapped(_ sender: UIButton) {
        if currentStep > 0 {
            currentStep -= 1
            animateStepTransition()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        
        switch currentStep {
        case 0:
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
            animateStepTransition()
            
        case 1:
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlert("Please enter your phone number")
                return
            }
            viewModel.countryCode = countryCodeTextField.text ?? "+91"
            viewModel.phoneNumber = phone
            viewModel.whatsappNumber = whatsappTextField.text?.isEmpty == false ? whatsappTextField.text! : phone
            currentStep = 2
            animateStepTransition()
            
        case 2:
            guard let age = ageTextField.text, !age.isEmpty else {
                showAlert("Please enter your age")
                return
            }
            viewModel.age = age
            viewModel.ageUnit = "Y"
            submitRegistration()
            
        default:
            break
        }
    }
    
    @objc private func genderTapped(_ sender: UIButton) {
        selectGender(sender)
    }
    
    private func selectGender(_ sender: UIButton) {
        let orange = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        
        // Reset all buttons
        [maleButton, femaleButton, othersButton].forEach { btn in
            btn.backgroundColor = .clear
            btn.layer.borderWidth = 1
            btn.layer.borderColor = orange.cgColor
            btn.setTitleColor(orange, for: .normal)
        }
        
        // Highlight selected
        sender.backgroundColor = orange
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderWidth = 0
        
        // Set gender value
        if sender == maleButton {
            viewModel.gender = "M"
        } else if sender == femaleButton {
            viewModel.gender = "F"
        } else {
            viewModel.gender = "O"
        }
    }
    
    // MARK: - Step Navigation
    
    private func animateStepTransition() {
        UIView.animate(withDuration: 0.3) {
            self.step1Container.isHidden = self.currentStep != 0
            self.step2Container.isHidden = self.currentStep != 1
            self.step3Container.isHidden = self.currentStep != 2
        }
        updateProgress()
        updateStepUI()
    }
    
    private func updateProgress() {
        let progress = CGFloat(currentStep + 1) / CGFloat(totalSteps)
        
        guard let progressContainer = progressContainer else { return }
        
        // Remove existing width constraint
        progressBarOrange?.constraints.filter { $0.firstAttribute == .width }.forEach {
            progressBarOrange?.removeConstraint($0)
        }
        
        // Add new width constraint
        let containerWidth = progressContainer.frame.width
        let progressWidth = containerWidth * progress
        progressBarOrange?.widthAnchor.constraint(equalToConstant: progressWidth).isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateStepUI() {
        stepLabel?.text = "\(currentStep + 1)/\(totalSteps)"
        
        switch currentStep {
        case 0:
            titleLabel?.text = "Basic Details"
            subtitleLabel?.text = "Enter your name and email"
        case 1:
            titleLabel?.text = "Contact Info"
            subtitleLabel?.text = "Enter your phone numbers"
        case 2:
            titleLabel?.text = "Additional Info"
            subtitleLabel?.text = "Complete your profile"
        default:
            break
        }
    }
    
    // MARK: - Registration
    
    private func submitRegistration() {
        activityIndicator?.startAnimating()
        actionButton?.isEnabled = false
        actionButton?.alpha = 0.6
        
        do {
            try viewModel.validateInputs()
        } catch {
            activityIndicator?.stopAnimating()
            actionButton?.isEnabled = true
            actionButton?.alpha = 1.0
            showAlert(error.localizedDescription)
            return
        }
        
        viewModel.register { [weak self] result in
            self?.activityIndicator?.stopAnimating()
            self?.actionButton?.isEnabled = true
            self?.actionButton?.alpha = 1.0
            
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
