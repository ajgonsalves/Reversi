//
//  ViewController.swift
//  Reversi
//
//  Created by Alexander on 7/10/19.
//  Copyright © 2019 gonsalves.alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	private lazy var game = ReversiBoard()
	
	func initializeView() {
		for i in 0..<boardSpaces.count {			boardSpaces[i].backgroundColor = #colorLiteral(red: 0.7052466688, green: 0.6034583201, blue: 0, alpha: 1)
			boardSpaces[i].setTitle("", for: UIControl.State.normal)
			boardSpaces[i].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			boardSpaces[i].layer.borderWidth = 3.0
			boardSpaces[i].setTitle("\(i)", for: UIControl.State.normal)
		}
		passButton.backgroundColor = #colorLiteral(red: 0.7052466688, green: 0.6034583201, blue: 0, alpha: 1)
		whiteLabel.layer.borderWidth = 3.0
		blackLabel.layer.borderWidth = 3.0
		endGameLabel.text = ""
		updateViewFromModel()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		game.othelloInit()
		initializeView()
	}

	func updateViewFromModel() {
		// update board
		for i in 0..<boardSpaces.count {
			var pieceColor: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.7052466688, green: 0.6034583201, blue: 0, alpha: 1)]
			if game.board[i] == ReversiBoard.ReversiSpace.white {
				pieceColor[.foregroundColor] = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			}
			else if game.board[i] == ReversiBoard.ReversiSpace.black {
				pieceColor[.foregroundColor] = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			}
			let piece = NSAttributedString(string: "●", attributes: pieceColor)
			boardSpaces[i].setAttributedTitle(piece, for: UIControl.State.normal)
			
			// unhighlight all spaces
			boardSpaces[i].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		}
		
		if let endGame = game.victor {
			if endGame == ReversiBoard.ReversiSpace.white {
				endGameLabel.text = "White wins"
			}
			else if endGame == ReversiBoard.ReversiSpace.black {
				endGameLabel.text = "Black wins"
			}
			else {
				endGameLabel.text = "Draw"
			}
		}
		else {
			// highlight possible positions
			if game.turn == true {
				for i in 0..<game.whiteOptions.count {
					boardSpaces[game.whiteOptions[i]].layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
					whiteLabel.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
					blackLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				}
			}
			else {
				for i in 0..<game.blackOptions.count {
					boardSpaces[game.blackOptions[i]].layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
					whiteLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
					blackLabel.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
				}
			}
		}
		
		// update score labels
		whiteLabel.text = "White: \(game.whiteScore)"
		whiteLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		whiteLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		blackLabel.text = "Black: \(game.blackScore)"
		blackLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		blackLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		// pass button text
		if game.previousPass {
			passButton.setTitle("End game", for: UIControl.State.normal)
		}
		else {
			passButton.setTitle("Pass", for: UIControl.State.normal)
		}
	}
	
	
	

	@IBOutlet var boardSpaces: [UIButton]!
	
	@IBAction func playSpace(_ sender: UIButton) {
		if let space = boardSpaces.index(of: sender) {
			var playerTribe = ReversiBoard.ReversiSpace.black
			if game.turn == true {
				playerTribe = ReversiBoard.ReversiSpace.white
			}
			if (game.spaceIsPlayable(space: space, tribe: playerTribe)) {
				game.play(origin: space, tribe: playerTribe)
				updateViewFromModel()
			}
			else {
				print("\(space)")
			}
		}
	}
	
	@IBOutlet var passButton: UIButton!
	
	@IBAction func pressPass(_ sender: UIButton) {
		game.pass()
		updateViewFromModel()
	}
	
	@IBOutlet var whiteLabel: UILabel!
	
	@IBOutlet var blackLabel: UILabel!
	
	
	@IBOutlet var endGameLabel: UILabel!
}
