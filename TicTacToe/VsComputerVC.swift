import UIKit

class VsComputerVC: UIViewController {
    
    var currentPlayer: Int = 1
    let playerLabel = UILabel()
    let crossImage = UIImage(named: "cross")
    let circleImage = UIImage(named: "circle")
    
    let winningMoves = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
    var player1Moves = [Int]()
    var player2Moves = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
        titleLabel.text = "Tic Tac Toe"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        playerLabel.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: 30)
        playerLabel.text = "Player \(currentPlayer)'s turn"
        playerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        playerLabel.textAlignment = .center
        view.addSubview(playerLabel)
        
        let cellSize: CGFloat = 100
        let margin: CGFloat = 20
        let startX = (view.frame.width - (cellSize * 3 + margin * 2)) / 2
        let startY = (view.frame.height - (cellSize * 3 + margin * 2)) / 5
        for i in 1...9 {
            let cell = UIView(frame: CGRect(x: startX + (cellSize + margin) * CGFloat((i - 1) % 3), y: startY + (cellSize + margin) * CGFloat((i - 1) / 3) + 150, width: cellSize, height: cellSize))
            cell.backgroundColor = .systemGray6
            cell.layer.cornerRadius = 10
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowOpacity = 0.7
            cell.layer.shadowRadius = 4
            cell.tag = i
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            cell.addGestureRecognizer(tapGesture)
            view.addSubview(cell)
        }
        
        let restartButton = UIButton(type: .system)
        restartButton.frame = CGRect(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 50)
        restartButton.setTitle("Restart", for: .normal)
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        view.addSubview(restartButton)
        
    }
    
    @objc func restartButtonTapped() {
        let alertController = UIAlertController(title: "Restart Game?",
                                                message: "Are you sure you want to restart the game?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let restartAction = UIAlertAction(title: "Restart", style: .destructive) { (action) in
            self.restartGame()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func checkForWinningMoves(playerMoves: [Int]) -> Bool {
        for moves in winningMoves {
            var count = 0
            for move in moves {
                if playerMoves.contains(move) {
                    count += 1
                }
            }
            if count == 3 {
                return true
            }
        }
        return false
    }
    
    func restartGame() {
        currentPlayer = 1
        player1Moves = []
        player2Moves = []
        playerLabel.text = "Player \(currentPlayer)'s turn"
        for subview in view.subviews {
            if subview.tag >= 1 && subview.tag <= 9 {
                for imageView in subview.subviews {
                    if let imageView = imageView as? UIImageView {
                        imageView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view else { return }
        
        if cell.subviews.contains(where: { $0 is UIImageView }) {
            return
        }
        
        let imageSize = cell.frame.size.width / 2
        let imageX = (cell.frame.size.width - imageSize) / 2
        let imageY = (cell.frame.size.height - imageSize) / 2
        
        let imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageSize, height: imageSize))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        
        if currentPlayer == 1 {
            player1Moves.append(cell.tag)
            imageView.image = crossImage
        } else {
            player2Moves.append(cell.tag)
            imageView.image = circleImage
        }
        
        cell.addSubview(imageView)
        
        if checkForWinningMoves(playerMoves: player1Moves) {
            presentAlertWithRestart(title: "Game Over", message: "Player 1 wins!")
        } else if checkForWinningMoves(playerMoves: player2Moves) {
            presentAlertWithRestart(title: "Game Over", message: "Player 2 wins!")
        } else if player1Moves.count + player2Moves.count == 9 {
            presentAlertWithRestart(title: "Game Over", message: "It's a Tie")
        } else {
            currentPlayer = 3 - currentPlayer
            playerLabel.text = "Player \(currentPlayer)'s turn"
            
            if currentPlayer == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.makeComputerMove()
                }
            }
        }
    }
    
    func makeComputerMove() {
        var availableCells = [Int]()
        for i in 1...9 {
            if !player1Moves.contains(i) && !player2Moves.contains(i) {
                availableCells.append(i)
            }
        }
        
        if let randomCell = availableCells.randomElement() {
            let cells = view.subviews.filter { $0.tag == randomCell }
            if let cell = cells.first, cell.subviews.count == 0 {
                let imageSize = cell.frame.size.width / 2
                let imageX = (cell.frame.size.width - imageSize) / 2
                let imageY = (cell.frame.size.height - imageSize) / 2
                
                let imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageSize, height: imageSize))
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = 10
                imageView.image = circleImage
                
                player2Moves.append(cell.tag)
                cell.addSubview(imageView)
                
                if checkForWinningMoves(playerMoves: player2Moves) {
                    presentAlertWithRestart(title: "Game Over", message: "Player 2 wins!")
                } else if player1Moves.count + player2Moves.count == 9 {
                    presentAlertWithRestart(title: "Game Over", message: "It's a Tie")
                } else {
                    currentPlayer = 3 - currentPlayer
                    playerLabel.text = "Player \(currentPlayer)'s turn"
                    
                }
            } else {
                makeComputerMove()
            }
        }
    }

    func presentAlertWithRestart(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.restartGame()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
