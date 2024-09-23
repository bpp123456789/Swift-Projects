//
//  ContentView.swift
//  WordGarden
//
//  Created by William Petrik on 9/21/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    @State private var currentWordIndex = 0
    @State private var gamesStatusMessage = "How many guesses to uncover the hidden word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = 8
    @State private var playAgainButtonLabel = "Another Word?"
    @State private var audioPlayer: AVAudioPlayer!
    
    let maximumGuesses = 8
    
    var body: some View {
        VStack {
            
            HStack{
                VStack (alignment: .leading){
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                
                
                Spacer()
                
                VStack (alignment: .trailing){
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            Text(gamesStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            Spacer()
            Text(revealedWord)
                .font(.title)
                .frame(height: 50 )
            
            if playAgainHidden{
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last
                            else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            lettersGuessed = lettersGuessed + guessedLetter
                            revealedWord = revealLetters(word: wordsToGuess[currentWordIndex], letters: lettersGuessed)
                        }
                    
                    Button("Guess a Letter") {
                        textFieldIsFocused = false
                        lettersGuessed = lettersGuessed + guessedLetter
                        revealedWord = revealLetters(word: wordsToGuess[currentWordIndex], letters: lettersGuessed)
                        updateGameplay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                
                Button(playAgainButtonLabel){
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word"
                    }
                    lettersGuessed = ""
                    revealedWord = revealLetters(word: wordsToGuess[currentWordIndex], letters: lettersGuessed)
                    guessesRemaining = maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gamesStatusMessage = "How many guesses to uncover the hidden word?"
                    playAgainHidden = true
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .bottom)
                .animation(.easeInOut(duration: 0.75), value: imageName)
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .onAppear() {
            revealedWord = revealLetters(word: wordsToGuess[currentWordIndex % wordsToGuess.count], letters: lettersGuessed)
            guessesRemaining = maximumGuesses
        }
        
        
    }
    func updateGameplay() {
        gamesStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        if !wordsToGuess[currentWordIndex].contains(guessedLetter) {
            guessesRemaining -= 1
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(guessesRemaining)"
            }
            
        } else {
            playSound(soundName: "correct")
        }
        
        if !revealedWord.contains("_") {
            gamesStatusMessage = "You've guessed it! It took you \(lettersGuessed.count) guesses to guess the word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-guessed")
        } else if guessesRemaining == 0 {
            gamesStatusMessage = "So sorry. You are all out of guesses."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
            playSound(soundName: "word-not-guessed")
        } else {
            gamesStatusMessage = "You'e made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart game?"
            gamesStatusMessage = gamesStatusMessage + "\n You'e tried all of the words. Try Again?"
        }
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("🦅Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("error \(error.localizedDescription)in audio player")
        }
    }
}

func revealLetters(word: String, letters: String) -> String {
    var placeholder = ""
    for x in word {
        if letters.contains(String(x)){
            placeholder = placeholder + String(x) + " "
        } else {
            placeholder = placeholder + "_" + " "
        }
    }
    placeholder.removeLast()
    return placeholder
}




#Preview {
    ContentView()
}
