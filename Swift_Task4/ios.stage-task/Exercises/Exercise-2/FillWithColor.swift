import Foundation

final class FillWithColor {
	
	func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
		// check data to correct
		let m = image.count
		if !isCorrect(arrayLen: m) || !isCorrect(index: row, of: m) || !isCorrect(color: newColor) {
			return image
		}
		
		// copy image to change it
		var newImage = image;
		
		// create queue to check and fill coordinates
		var checkedPositions: [Pos] = []
		var checkQueue: [Pos] = [
			Pos(row: row, col: column)
		]
		while !checkQueue.isEmpty {
			let pos = checkQueue.removeFirst()
			// check data to correct
			let n = newImage[pos.row].count
			if !isCorrect(arrayLen: n) || !isCorrect(index: pos.col, of: n) {
				return image
			}
			let curColor = newImage[pos.row][pos.col]
			if !isCorrect(color: curColor) {
				return image
			}
			
			// fill color
			newImage[pos.row][pos.col] = newColor
			
			// add connected coordinates (4-directionally) with same color to fill queue
			let connectedPositions = [
				Pos(row: pos.row-1, col: pos.col  ),
				Pos(row: pos.row  , col: pos.col+1),
				Pos(row: pos.row+1, col: pos.col  ),
				Pos(row: pos.row  , col: pos.col-1)
			]
			for connectedPos in connectedPositions {
				if !isCorrect(index: connectedPos.row, of: m) {
					continue
				}
				let connectedRowColumns = image[connectedPos.row].count
				if !isCorrect(index: connectedPos.col, of: connectedRowColumns) {
					continue
				}
				let isSameColors = curColor == image[connectedPos.row][connectedPos.col]
				if !isSameColors {
					continue
				}
				let isChecked = checkedPositions.contains(connectedPos)
				if isChecked {
					continue
				}
				checkQueue.append(connectedPos)
			}
			
			// remember this position as checked
			checkedPositions.append(pos)
		}
		
		return newImage;
	}
	
	private func isCorrect(arrayLen: Int) -> Bool { return 1 <= arrayLen && arrayLen < 50 }
	private func isCorrect(color: Int) -> Bool { return 0 <= color && color < 65536 }
	private func isCorrect(index: Int, of len: Int) -> Bool { return 0 <= index && index < len }
	
	private struct Pos: Equatable {
		let row, col: Int
		static func == (lhs: Pos, rhs: Pos) -> Bool {
			return lhs.row == rhs.row && lhs.col == rhs.col
		}
	}
}
