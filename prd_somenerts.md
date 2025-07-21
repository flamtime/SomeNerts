# Product Requirements Document: SomeNerts

## Overview
SomeNerts is a lightweight iOS application designed to keep score for the card game Nerts across multiple rounds and games.

## Target Users
Adult iOS users who enjoy card games and need a simple, reliable scoring system for Nerts gameplay.

## Core Functionality

### Game Setup
- Support 2-12 players per game
- Players enter names at game start (no persistent profiles)
- Optional: Set a winning point total target
- Support both portrait and landscape orientations

### Scoring System
- Track integer scores based on number of cards played (positive values only)
- Add scores for each completed round per player
- Display cumulative scores throughout the game
- Continue game play even after winning condition is met

### Round Management
- Add new rounds as needed (unlimited rounds)
- Enter scores for each player per round
- Automatically calculate and display running totals
- Clear indication when optional winning condition is reached

### Statistics
- Track individual player statistics across multiple games
- Maintain historical performance data

## Technical Requirements
- iOS native application
- No internet connectivity required
- Lightweight and performant
- No external data sources or services needed
- No save/load functionality for individual games

## User Experience
- "Cute" visual design while maintaining readability
- Standard, easy-to-read fonts
- Intuitive interface for score entry and viewing
- Clear display of current standings

## Non-Requirements
- Player profiles or persistent user accounts
- Game session saving/loading
- Accessibility features beyond standard iOS support
- Network connectivity or cloud features