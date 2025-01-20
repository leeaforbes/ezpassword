//
//  ContentView.swift
//  EZ Password Generator
//
//  Created by Lee Forbes on 3/10/24.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.scenePhase) var scenePhase
	
	let characters = "abcedfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*"
	
	let characterSets = [
		CharacterSet(charactersIn: "abcedfghijklmnopqrstuvwxyz"),
		CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
		CharacterSet(charactersIn: "1234567890"),
		CharacterSet(charactersIn: "!@#$%^&*")
	]
	
	@State private var password = "password"
	@State private var isCovered = false
	
    var body: some View {
		ZStack {
			VStack {
				HStack {
					Text(password).monospaced()
					Button {
						UIPasteboard.general.string = password
					} label: {
						Image(systemName: "doc.on.doc")
					}
				}
				
				Divider().hidden()
				
				Button("Generate") {
					generate()
					
					while verify() == false {
						generate()
					}
				}
			}
			.padding()
			.blur(radius: isCovered == true ? 10.0 : 0)
			.onChange(of: scenePhase) { newPhase in
				if newPhase == .active {
					isCovered = false
				} else if newPhase == .inactive {
					isCovered = true
				} else if newPhase == .background {
					isCovered = true
				}
			}
			//fullscreencover with an image doesnt work here for some reason when the scenePhase changes
		}
    }
	
	func generate() {
		let length = 16
		
		password = String((0..<length).map{ _ in characters.randomElement()! })
	}
	
	func verify() -> Bool {
		
		for set in characterSets {
			if password.rangeOfCharacter(from: set) == nil {
				print("verify failed")
				return false
			}
		}
		
		return true
	}
}

#Preview {
    ContentView()
}
