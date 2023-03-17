# Haskell Wordle

## What is this?
The following is a project from the course 'Prog2006 - Advanced programming' at NTNU Gjøvik I completed spring '22.  
It's far from perfect, but works :)

## Build and run
This project requires the Haskell Tool Stack to run. [Install Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/)

Once installed, navigate to your local repo, cd into the folder 'wordle' and write the following command to build
```
$ stack build
```
And the following command to run
```
$ stack run
```
Alternatively, only running the latter should both build and run the code if any changes have been made.

# Pitch
I'd like to attempt to recreate the now-famous browser game Wordle in Haskell.  
The way I would attempt to achieve this is by using the System.Console.ANSI module to display the game with colors in the terminal
The terminal would per attempt (out of six) clear and rewrite itself with a similar UI to the actual game, but only using a CLI.

This would look something like:

    ----Wordle----  
      □ □ □ □ □
      □ □ □ □ □  
      □ □ □ □ □  
      □ □ □ □ □  
      □ □ □ □ □  
      □ □ □ □ □  
     Attempts: 0/6
     New attempt: _
     
During the game it would look something like this

    ----Wordle----  
      A D I E U
      T R O P E
      □ □ □ □ □  
      □ □ □ □ □  
      □ □ □ □ □  
      □ □ □ □ □  
    Attempts: 2/6
    New attempt: _
    
(If for whatever reason I can't figure out how to get colors working, the application would display a secondary game panel with special ascii symbols or integers depicting the colors)

## Tech
The way I would solve this is by reading in two lists of words. One list of possible answers and one list of all possible five letter words. Then, by seeding a random number generator with the current time in seconds, I would pick one of the possible answers and append the rest of the words to the list of all possible words. During runtime the program would then check if the word written is equal to the solution, and if not, check if it exists within the list of all possible words. If the word is not within that list either, Disallow the written word (Maybe cache it for the session as to improve efficiency...) If it does exist, then parse the word against the solution to look for any yellow or green status letters and write this to the currently displayed array.

Some pseudocode for the game loop:


    while(!win && !lose){
    
        guess = getline
        
        if guess == answer {
            win = true
        } else if (guessInWordPool(guess)){
            parseGuess(guess) // Adds word to display array with color codes
        } else {
            print("Not a word!")
        }
        displayState() // Clears the terminal and displays the current state.
    }
    
The actual data structure for the current game would look something like this:   
`    [30](char,int)`
Where the first value, the char, is any letter in one of the words in the array and the second value,  
the int, is the color code for the letter.  

I would define the colors as such
* 0: gray
* 1: yellow
* 2: green
