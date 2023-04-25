import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tic Tac Toe"
        label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Player Vs Player", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(playerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let computerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Player Vs Computer", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(computerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(playerButton)
        view.addSubview(computerButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            
            playerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            playerButton.widthAnchor.constraint(equalToConstant: 200),
            playerButton.heightAnchor.constraint(equalToConstant: 50),
            
            computerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            computerButton.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: 20),
            computerButton.widthAnchor.constraint(equalToConstant: 200),
            computerButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    @objc func playerButtonTapped() {
        let vc = VsPlayerVC()
        present(vc, animated: true)
    }
    
    @objc func computerButtonTapped() {
        let vc = VsComputerVC()
        present(vc, animated: true)
    }
}

