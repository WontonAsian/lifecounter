import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var loserLabel: UILabel!
    
    // MARK: - Properties
    var players: [Int] = [20, 20, 20, 20]  // Start with four players with 20 life each
    var gameStarted = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialPlayerViews()
        loserLabel.isHidden = true
    }

    // MARK: - Setup Initial Player Views
    func setupInitialPlayerViews() {
        for index in 0..<players.count {
            addPlayerModule(playerIndex: index)
        }
    }

    // MARK: - Add Player Module
    private func addPlayerModule(playerIndex: Int) {
        // Create a horizontal stack view for the player module
        let playerModuleStackView = UIStackView()
        playerModuleStackView.axis = .horizontal
        playerModuleStackView.distribution = .fillProportionally
        playerModuleStackView.alignment = .center
        playerModuleStackView.spacing = 8
        playerModuleStackView.translatesAutoresizingMaskIntoConstraints = false

        // Create and configure the decrement button
        let decrementButton = UIButton()
        decrementButton.setTitle("-", for: .normal)
        decrementButton.backgroundColor = .red
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        decrementButton.tag = playerIndex // Set tag to player index
        decrementButton.addTarget(self, action: #selector(lifeButtonTapped(_:)), for: .touchUpInside)

        // Create and configure the increment button
        let incrementButton = UIButton()
        incrementButton.setTitle("+", for: .normal)
        incrementButton.backgroundColor = .blue
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.tag = playerIndex // Set tag to player index
        incrementButton.addTarget(self, action: #selector(lifeButtonTapped(_:)), for: .touchUpInside)
        
        // Create and configure the remove player button
        let removePlayerButton = UIButton()
        removePlayerButton.setTitle("X", for: .normal)
        removePlayerButton.backgroundColor = .systemGray
        removePlayerButton.translatesAutoresizingMaskIntoConstraints = false
        removePlayerButton.tag = playerIndex // Set tag to player index
        removePlayerButton.addTarget(self, action: #selector(removePlayer(_:)), for: .touchUpInside)

        // Create and configure the life total label
        let lifeTotalLabel = UILabel()
        lifeTotalLabel.text = "Player \(playerIndex + 1): \(players[playerIndex])"
        lifeTotalLabel.textAlignment = .center
        lifeTotalLabel.translatesAutoresizingMaskIntoConstraints = false

        // Create and configure the life adjustment text field
        let lifeAdjustmentTextField = UITextField()
        lifeAdjustmentTextField.keyboardType = .numberPad
        lifeAdjustmentTextField.backgroundColor = .lightGray
        lifeAdjustmentTextField.translatesAutoresizingMaskIntoConstraints = false
        lifeAdjustmentTextField.delegate = self
        lifeAdjustmentTextField.placeholder = "Enter life change"
        lifeAdjustmentTextField.textAlignment = .center
        lifeAdjustmentTextField.tag = playerIndex

        // Add elements to the player module stack view
        playerModuleStackView.addArrangedSubview(decrementButton)
        playerModuleStackView.addArrangedSubview(lifeTotalLabel)
        playerModuleStackView.addArrangedSubview(incrementButton)
        playerModuleStackView.addArrangedSubview(lifeAdjustmentTextField)
        playerModuleStackView.addArrangedSubview(removePlayerButton)

        // Add constraints to buttons and text field
        let buttonSize: CGFloat = 44
        NSLayoutConstraint.activate([
            decrementButton.widthAnchor.constraint(equalToConstant: buttonSize),
            decrementButton.heightAnchor.constraint(equalToConstant: buttonSize),
            incrementButton.widthAnchor.constraint(equalToConstant: buttonSize),
            incrementButton.heightAnchor.constraint(equalToConstant: buttonSize),
            lifeAdjustmentTextField.widthAnchor.constraint(equalToConstant: 60),
            removePlayerButton.widthAnchor.constraint(equalToConstant: buttonSize),
            removePlayerButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])

        // Add the player module stack view to the main stack view
        playerStackView.addArrangedSubview(playerModuleStackView)
    }


    // MARK: - IBActions
    @IBAction func addPlayer(_ sender: UIButton) {
        guard players.count < 8 && !players.contains(where: { $0 != 20 }) else { return }
        players.append(20)
        addPlayerModule(playerIndex: players.count - 1)
        addPlayerButton.isEnabled = players.count < 8
    }
    
    @objc func removePlayer(_ sender: UIButton) {
        let playerIndex = sender.tag
        guard players.count > 2, playerIndex < players.count else { return }
        
        players.remove(at: playerIndex)
        playerStackView.arrangedSubviews[playerIndex].removeFromSuperview()
        
        // Update the tags for buttons, text fields, and labels in remaining player modules.
        for (index, view) in playerStackView.arrangedSubviews.enumerated() {
            if let stackView = view as? UIStackView {
                for subview in stackView.arrangedSubviews {
                    if let button = subview as? UIButton {
                        button.tag = index
                    } else if let textField = subview as? UITextField {
                        textField.tag = index
                    }
                }
            }
        }
        
        updateLifeTotalLabels()
    }

    
    

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Life Button Tapped
    @objc func lifeButtonTapped(_ sender: UIButton) {
            guard let textField = findTextField(for: sender),
                  let text = textField.text,
                  let adjustment = Int(text) else {
                return
            }
            let increment = sender.currentTitle == "+"
            let playerIndex = sender.tag
            let adjustedValue = increment ? adjustment : -adjustment
            players[playerIndex] += adjustedValue
            players[playerIndex] = max(players[playerIndex], 0)
            textField.text = ""
            updateLifeTotalLabels()
            checkForLoser()
            if adjustedValue != 0 && !gameStarted {
                gameStarted = true
                addPlayerButton.isEnabled = false  // Disable adding new players when game starts
            }
        }

        func checkForLoser() {
            for (index, lifeTotal) in players.enumerated() {
                if lifeTotal <= 0 {
                    loserLabel.text = "Player \(index + 1) LOSES!"
                    loserLabel.isHidden = false
                    break
                }
            }
        }


    private func findTextField(for button: UIButton) -> UITextField? {
        guard let stackView = button.superview as? UIStackView else { return nil }
        return stackView.arrangedSubviews.compactMap { $0 as? UITextField }.first
    }

    // MARK: - Update Life Total Labels
    func updateLifeTotalLabels() {
        for (index, view) in playerStackView.arrangedSubviews.enumerated() {
            if let stackView = view as? UIStackView,
               let lifeTotalLabel = stackView.arrangedSubviews.first(where: { $0 is UILabel }) as? UILabel {
                lifeTotalLabel.text = "Player \(index + 1): \(players[index])"
            }
        }
    }
}
