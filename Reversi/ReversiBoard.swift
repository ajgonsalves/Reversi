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
	private(set) var whiteOptions = [Int]()
	private(set) var blackOptions = [Int]()
	private(set) var whiteScore = 0
	private(set) var blackScore = 0
	private(set) var turn = true // 0 = black turn, 1 = white turn
	private(set) var previousPass = false
	private(set) var victor: ReversiSpace? = nil
	
	mutating func othelloInit() {
		board[27] = ReversiSpace.white
		board[36] = ReversiSpace.white
		board[28] = ReversiSpace.black
		board[35] = ReversiSpace.black
		updateScore()
		updateOptions()
	}
	
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
	
	func SpaceinBounds(space: Int) -> Bool {
		if (space < 0 || space > 63) {
			return false
		}
		else {
			return true
		}
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
	
	mutating func updateOptions() {
		whiteOptions.removeAll()
		blackOptions.removeAll()
		
		for i in 0..<64 {
			if board[i] == ReversiSpace.blank {
				
				// North
				if NinBounds(space: i) && board[i - 8] != ReversiSpace.blank {
					var endPoint = i - 8
					let skipTribe = board[endPoint]
					
					while (NinBounds(space: endPoint) && board[endPoint - 8] == skipTribe) {
						endPoint -= 8
					}
					
					if NinBounds(space: endPoint) && board[endPoint - 8] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// Northeast
				if NEinBounds(space: i) && board[i - 7] != ReversiSpace.blank{
					var endPoint = i - 7
					let skipTribe = board[endPoint]
					
					while (NEinBounds(space: endPoint) && board[endPoint - 7] == skipTribe) {
						endPoint -= 7
					}
					
					if NEinBounds(space: endPoint) && board[endPoint - 7] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// East
				if EinBounds(space: i) && board[i + 1] != ReversiSpace.blank {
					var endPoint = i + 1
					let skipTribe = board[endPoint]
					
					while (EinBounds(space: endPoint) && board[endPoint + 1] == skipTribe) {
						endPoint += 1
					}
					
					if EinBounds(space: endPoint) && board[endPoint + 1] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// Southast
				if SEinBounds(space: i) && board[i + 9] != ReversiSpace.blank {
					var endPoint = i + 9
					let skipTribe = board[endPoint]
					
					while (SEinBounds(space: endPoint) && board[endPoint + 9] == skipTribe) {
						endPoint += 9
					}
					
					if SEinBounds(space: endPoint) && board[endPoint + 9] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// South
				if SinBounds(space: i) && board[i + 8] != ReversiSpace.blank {
					var endPoint = i + 8
					let skipTribe = board[endPoint]
					
					while (SinBounds(space: endPoint) && board[endPoint + 8] == skipTribe) {
						endPoint += 8
					}
					
					if SinBounds(space: endPoint) && board[endPoint + 8] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// Southwest
				if SWinBounds(space: i) && board[i + 7] != ReversiSpace.blank {
					var endPoint = i + 7
					let skipTribe = board[endPoint]
					
					while (SWinBounds(space: endPoint) && board[endPoint + 7] == skipTribe) {
						endPoint += 7
					}
					
					if SWinBounds(space: endPoint) && board[endPoint + 7] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// West
				if WinBounds(space: i) && board[i - 1] != ReversiSpace.blank {
					var endPoint = i - 1
					let skipTribe = board[endPoint]
					
					while (WinBounds(space: endPoint) && board[endPoint - 1] == skipTribe) {
						endPoint -= 1
					}
					
					if WinBounds(space: endPoint) && board[endPoint - 1] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
				
				// Northwest
				if NWinBounds(space: i) && board[i - 9] != ReversiSpace.blank {
					var endPoint = i - 9
					let skipTribe = board[endPoint]
					
					while (NWinBounds(space: endPoint) && board[endPoint - 9] == skipTribe) {
						endPoint -= 9
					}
					
					if NWinBounds(space: endPoint) && board[endPoint - 9] == skipTribe.oppositeTribe {
						if skipTribe == ReversiSpace.white && !blackOptions.contains(i) {
							blackOptions.append(i)
						}
						if skipTribe == ReversiSpace.black && !whiteOptions.contains(i) {
							whiteOptions.append(i)
						}
					}
				}
			}
		}
	}
	
	mutating func updateScore() {
		whiteScore = board.filter {$0 == ReversiSpace.white}.count
		blackScore = board.filter {$0 == ReversiSpace.black}.count
	}
	
	mutating func pass() {
		turn = !turn
		updateOptions()
		
		if previousPass {
			whiteOptions.removeAll()
			blackOptions.removeAll()
			
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
	
	mutating func play(origin: Int, tribe: ReversiSpace) {
		// check if tribe can play at all
		if (tribe == ReversiSpace.white && whiteOptions.isEmpty) || (tribe == ReversiSpace.black && blackOptions.isEmpty) {
			pass()
			return
		}
		if (!spaceIsPlayable(space: origin, tribe: tribe)) {
			return
		}
		
		board[origin] = tribe
		
		// North
		var endPoint = origin - 8
		while (NinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 8
		}
		if (NinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
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
				point -= 7
			}
		}
		
		// East
		endPoint = origin + 1
		while (EinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 1
		}
		if (EinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point += 1
			}
		}
		
		// Southeast
		endPoint = origin + 9
		while (SEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 9
		}
		if (SEinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point += 9
			}
		}
		
		// South
		endPoint = origin + 8
		while (SinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 8
		}
		if (SinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point += 8
			}
		}
		
		// Southwest
		endPoint = origin + 7
		while (SWinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint += 7
		}
		if (SWinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point += 7
			}
		}
		
		// West
		endPoint = origin - 1
		while (WinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 1
		}
		if (WinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point -= 1
			}
		}
		
		// Northwest
		endPoint = origin - 9
		while (NEinBounds(space: endPoint) && board[endPoint] == tribe.oppositeTribe) {
			endPoint -= 9
		}
		if (NWinBounds(space: endPoint) && board[endPoint] == tribe) {
			var point = origin
			while (point != endPoint) {
				board[point] = tribe
				point -= 9
			}
		}
		
		// end turn semantics
		turn = !turn
		updateScore()
		updateOptions()
		previousPass = false
	}
}
