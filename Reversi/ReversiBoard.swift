//
//  ReversiBoard.swift
//  Reversi
//
//  Created by Alexander on 7/26/19.
//  Copyright © 2019 gonsalves.alexander. All rights reserved.
//

import Foundation

struct ReversiBoard {
	enum ReversiSpace {
		case blank
		case white
		case black
		
		var oppositeTribe: ReversiSpace {
			switch self {
			case .blank: return .blank
			case .white: return .black
			case .black: return .white
			}
		}
	}
	
	private(set) var board: [ReversiSpace] = Array(repeating: ReversiSpace.blank, count: 64)
	private(set) var whiteOptions: [Int] = [27,28,35,36]
	private(set) var blackOptions = [Int]()
	private(set) var whiteScore = 0
	private(set) var blackScore = 0
	private(set) var turn = true // 0 = black turn, 1 = white turn
	private var firstTurnFinished = false
	private var previousPass = false
	private(set) var victor: ReversiSpace? = nil
	
	mutating func spaceIsPlayable(space: Int, tribe: ReversiSpace) -> Bool {
		// check if player can make a move
		if (turn && whiteOptions.count == 0) {
			turn = !turn
			return false
		}
		if (!turn && blackOptions.count == 0) {
			turn = !turn
			return false
		}
		
		// check if the space is appropriate
		if (tribe == ReversiSpace.white && whiteOptions.contains(space)) {
			return true
		}
		else if (tribe == ReversiSpace.black && blackOptions.contains(space)) {
			return true
		}
		else {
			return false
		}
	}
	
	mutating func updateScore() {
		whiteScore = board.filter {$0 == ReversiSpace.white}.count
		blackScore = board.filter {$0 == ReversiSpace.black}.count
	}
	
	mutating func pass() {
		turn = !turn
		if previousPass {
			if whiteScore > blackScore {
				victor = ReversiSpace.white
			}
			else if blackScore > whiteScore {
				victor = ReversiSpace.white
			}
			else {
				victor = ReversiSpace.blank
			}
		}
		previousPass = true
	}
	
	func NinBounds(space: Int) -> Bool {
		if (space < 8 || space > 63) {
			return false
		}
		else {
			return true
		}
	}
	
	func EinBounds(space: Int) -> Bool {
		if (space < 0 || space % 8 == 7 || space > 62) {
			return false
		}
		else {
			return true
		}
	}
	
	func SinBounds(space: Int) -> Bool {
		if (space < 0 || space > 55) {
			return false
		}
		else {
			return true
		}
	}
	
	func WinBounds(space: Int) -> Bool {
		if (space < 0 || space % 8 == 0 || space > 63) {
			return false
		}
		else {
			return true
		}
	}
	
	func NEinBounds(space: Int) -> Bool {
		if (space < 8 || space % 8 == 7 || space > 63) {
			return false
		}
		else {
			return true
		}
	}
	
	func SEinBounds(space: Int) -> Bool {
		if (space < 0 || space % 8 == 7 || space > 54) {
			return false
		}
		else {
			return true
		}
	}
	
	func SWinBounds(space: Int) -> Bool {
		if (space < 0 || space % 8 == 0 || space > 55) {
			return false
		}
		else {
			return true
		}
	}
	
	func NWinBounds(space: Int) -> Bool {
		if (space < 9 || space % 8 == 0 || space > 63) {
			return false
		}
		else {
			return true
		}
	}
	
	mutating func addToOptions(space: Int, tribe: ReversiSpace) {
		// North
		if (NinBounds(space: space) && board[space - 8] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space - 8)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space - 8)
			}
		}
		
		// Northeast
		if (NEinBounds(space: space) && board[space - 7] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space - 7)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space - 7)
			}
		}
		
		// East
		if (EinBounds(space: space) && board[space + 1] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space + 1)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space + 1)
			}
		}
		
		// Southeast
		if (SEinBounds(space: space) && board[space + 9] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space + 9)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space + 9)
			}
		}
		
		// South
		if (SinBounds(space: space) && board[space + 8] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space + 8)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space + 8)
			}
		}
		
		// Southwest
		if (SWinBounds(space: space) && board[space + 7] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space + 7)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space + 7)
			}
		}
		
		// West
		if (WinBounds(space: space) && board[space - 1] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space - 1)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space - 1)
			}
		}
		
		// Northwest
		if (NWinBounds(space: space) && board[space - 9] == ReversiSpace.blank) {
			if (tribe == ReversiSpace.white) {
				blackOptions.append(space - 9)
			}
			else if (tribe == ReversiSpace.black) {
				whiteOptions.append(space - 9)
			}
		}
	}
	
	mutating func play(origin: Int, tribe: ReversiSpace) {
		if (!spaceIsPlayable(space: origin, tribe: tribe)) {
			return
		}
		
		board[origin] = tribe
		
		// North
		var endPoint = origin - 8
		while (NinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 8
		}
		if (NinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point -= 8
			}
		}
		
		// Northeast
		endPoint = origin - 7
		while (NEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 7
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point -= 7
			}
		}
		
		// East
		endPoint = origin + 1
		while (EinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 1
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point += 1
			}
		}
		
		// Southeast
		endPoint = origin + 9
		while (SEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 9
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point += 9
			}
		}
		
		// South
		endPoint = origin + 8
		while (SinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 8
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point += 8
			}
		}
		
		// Southwest
		endPoint = origin + 7
		while (SWinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 7
		}
		if (SEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point += 7
			}
		}
		
		// West
		endPoint = origin - 1
		while (WinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 1
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point -= 1
			}
		}
		
		// Northwest
		endPoint = origin - 9
		while (NEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 9
		}
		if (NEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				addToOptions(space: point, tribe: tribe)
				point -= 9
			}
		}
		
		// Remove origin from options
		if let originIndex = whiteOptions.firstIndex(of: origin) {
			whiteOptions.remove(at: originIndex)
		}
		if let originIndex = blackOptions.firstIndex(of: origin) {
			blackOptions.remove(at: originIndex)
		}
		// if first turn, remove everything from whiteOptions
		if firstTurnFinished {
			whiteOptions.removeAll()
		}
		
		// end turn semantics
		updateScore()
		addToOptions(space: origin, tribe: tribe)
		turn = !turn
		previousPass = false
	}
}
