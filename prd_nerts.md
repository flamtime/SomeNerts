# Nerts Scorekeeper

## Target Audience
Our target is one single user who scorekeeps for nerts. This user likes a 'Shabby chic' color pallete, but clean lines for an interface.

This person needs to use their iPhone to enter the scores for 2-12 people.

## Context
Nerts is a game played with 2-12 players
Each of the 12 players will use their own deck of 52 standard playing cards
The backs of each deck will be different
Rules of nerts are at this URL: https://bicyclecards.com/how-to-play/nerts even though the only important part is scorekeeping for this app.

## Application Elements

### App Name
The app is named 'Some Nertz?'

### Platform
The app is designed to be run on iOS naitively 
UX Elements should follow Apple's guidelines

## UX logic
-1. Allow the player to resume an existing game or start a new game
0. First, ask how many players and create scorelines for each player
1. The scorekeeper shoud be able to enter a name for each player
2. The scorekeeper should be able to advance to the next round
3. Scores of each round should be saved so that the scorekeeper can correct scores from previous rounds.
4. A single player's score is the sum of all rounds.
5. The ux should have a way for the scorekeeper to see the total for any. one player with a single click.
6. The score keeper should be able to start a new game which then allows for player editing and all scores set to 0.
7. after entering any one player's score, all scores should update in the ux
8. between each round, show the leaderboard with a "next" button to start the next round.
9. Decorate the first, second and third place player's names with gold, silver and bronze medal emoji.

## Game Scoring Logic
0. The game nerts consists of multiple rounds where each player scores an integer of points
1. The scorekeeper should have the ability to score 2-12 players
scorekeeper needs to be able to very quickly record an integer score for each round. 
2. For each round, a player may score between -13 and +52 with scores most often between -7 and +35
3. the default score for any user is 0 prior to scorekeeper input
4. A player's total score is the sum of all completed rounds.