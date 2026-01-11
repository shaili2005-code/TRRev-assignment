//
//  RegistrationViewController.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressBarOrange: UIView!
    @IBOutlet weak var progressBarGray: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var whatsappTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageUnitTextField: UITextField!
    @IBOutlet weak var monthsTextField: UITextField!
    @IBOutlet weak var yearsTextField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let viewModel = RegistrationViewModel()
    private var selectedGender: String = "Male"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGenderButtons()
        setupTextFieldDelegates()
        setupKeyboardDismissal()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        submitButton.layer.cornerRadius = submitButton.bounds.width / 2
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Progress bars
        progressBarOrange.addCornerRadius(2)
        progressBarGray.addCornerRadius(2)
        
        // Title styling
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .gray
        
        // Text fields styling
        let textFields = [nameTextField, emailTextField, phoneTextField, whatsappTextField,
                         countryCodeTextField, ageTextField, ageUnitTextField,
                         monthsTextField, yearsTextField]
        
        textFields.forEach { textField in
            textField?.styleAsRoundedField()
            textField?.font = UIFont.systemFont(ofSize: 16)
        }
        
        // Set placeholders
        nameTextField.placeholder = "Name"
        emailTextField.placeholder = "Email ID"
        phoneTextField.placeholder = "Phone Number"
        whatsappTextField.placeholder = "WhatsApp Number"
        countryCodeTextField.placeholder = "+91"
        countryCodeTextField.text = "+91"
        ageTextField.placeholder = "Age"
        ageUnitTextField.placeholder = "Years"
        ageUnitTextField.text = "Years"
        monthsTextField.placeholder = "Months"
        yearsTextField.placeholder = "Years"
        
        // Phone number keyboards
        phoneTextField.keyboardType = .phonePad
        whatsappTextField.keyboardType = .phonePad
        ageTextField.keyboardType = .numberPad
        monthsTextField.keyboardType = .numberPad
        yearsTextField.keyboardType = .numberPad
        
        // Email keyboard
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Submit button
        submitButton.backgroundColor = UIColor(red: 0.25, green: 0.35, blue: 0.65, alpha: 1.0)
        submitButton.tintColor = .white
        submitButton.addShadow(color: .black, opacity: 0.2, offset: CGSize(width: 0, height: 4), radius: 8)
        
        // Back button
        backButton.addCornerRadius(8)
        backButton.addBorder(color: .lightGray, width: 1)
        
        // Activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    private func setupGenderButtons() {
        let orangeColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        
        // Male button - selected by default
        maleButton.styleAsFilledButton(backgroundColor: orangeColor, titleColor: .white)
        maleButton.setTitle("Male", for: .normal)
        
        // Female button
        femaleButton.styleAsBorderedButton(borderColor: orangeColor, titleColor: orangeColor)
        femaleButton.setTitle("Female", for: .normal)
        
        // Others button
        othersButton.styleAsBorderedButton(borderColor: orangeColor, titleColor: orangeColor)
        othersButton.setTitle("Others", for: .normal)
        
        // Add corner radius to all
        [maleButton, femaleButton, othersButton].forEach { $0?.addCornerRadius(18) }
    }
    
    private func setupTextFieldDelegates() {
        let textFields = [nameTextField, emailTextField, phoneTextField, whatsappTextField,
                         countryCodeTextField, ageTextField, ageUnitTextField,
                         monthsTextField, yearsTextField]
        textFields.forEach { $0?.delegate = self }
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        selectGender("Male")
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        selectGender("Female")
    }
    
    @IBAction func othersButtonTapped(_ sender: UIButton) {
        selectGender("Others")
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        registerDoctor()
    }
    
    // MARK: - Gender Selection
    
    private func selectGender(_ gender: String) {
        selectedGender = gender
        let orangeColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0)
        
        // Reset all buttons
        [maleButton, femaleButton, othersButton].forEach { button in
            button?.styleAsBorderedButton(borderColor: orangeColor, titleColor: orangeColor)
            button?.addCornerRadius(18)
        }
        
        // Highlight selected button
        switch gender {
        case "Male":
            maleButton.styleAsFilledButton(backgroundColor: orangeColor, titleColor: .white)
            maleButton.addCornerRadius(18)
        case "Female":
            femaleButton.styleAsFilledButton(backgroundColor: orangeColor, titleColor: .white)
            femaleButton.addCornerRadius(18)
        case "Others":
            othersButton.styleAsFilledButton(backgroundColor: orangeColor, titleColor: .white)
            othersButton.addCornerRadius(18)
        default:
            break
        }
    }
    
    // MARK: - Registration
    
    private func registerDoctor() {
        // Update ViewModel with form values
        viewModel.name = nameTextField.text ?? ""
        viewModel.email = emailTextField.text ?? ""
        viewModel.phoneNumber = phoneTextField.text ?? ""
        viewModel.whatsappNumber = whatsappTextField.text ?? ""
        viewModel.countryCode = countryCodeTextField.text ?? "+91"
        viewModel.gender = selectedGender
        viewModel.age = ageTextField.text ?? ""
        viewModel.ageUnit = ageUnitTextField.text ?? "Years"
        viewModel.practFromMonth = monthsTextField.text ?? ""
        viewModel.practFromYear = yearsTextField.text ?? ""
        
        // Validate inputs
        do {
            try viewModel.validateInputs()
        } catch {
            showAlert(title: "Validation Error", message: error.localizedDescription)
            return
        }
        
        // Show loading
        setLoading(true)
        
        // Call API
        viewModel.register { [weak self] result in
            self?.setLoading(false)
            
            switch result {
            case .success(_):
                self?.showSuccessAndNavigate()
            case .failure(let error):
                // Show option to continue with demo mode when API fails
                self?.showAPIErrorWithDemoOption(error: error)
            }
        }
    }
    
    private func showAPIErrorWithDemoOption(error: APIError) {
        let alert = UIAlertController(
            title: "Registration Failed",
            message: "\(error.localizedDescription)\n\nWould you like to continue with demo mode?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.registerDoctor()
        })
        
        alert.addAction(UIAlertAction(title: "Demo Mode", style: .default) { [weak self] _ in
            self?.navigateToDoctorsList()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            submitButton.isEnabled = false
            submitButton.alpha = 0.6
        } else {
            activityIndicator.stopAnimating()
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        }
    }
    
    private func showSuccessAndNavigate() {
        let alert = UIAlertController(
            title: "Success!",
            message: "Registration completed successfully.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.navigateToDoctorsList()
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToDoctorsList() {
        performSegue(withIdentifier: "showDoctorsList", sender: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
