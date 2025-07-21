# Product Requirements Document: SomeNerts (Refined)

## Executive Summary
SomeNerts is a minimalist iOS scoring application for the Nerts card game, designed to be offline-first, lightweight, and visually appealing while maintaining excellent usability.

## Target Audience
- Primary: iOS users (12+) who regularly play Nerts
- Secondary: Casual card game enthusiasts seeking simple scoring tools
- Device: iPhone and iPad users running iOS 15+

## Product Goals
1. Eliminate paper scorekeeping for Nerts games
2. Provide reliable, persistent player statistics
3. Support flexible game formats (varying player counts and round lengths)
4. Maintain simplicity and ease of use

## Core Features

### 1. Game Management
**New Game Setup**
- Player count selection: 2-12 players
- Player name entry (text input, no validation beyond non-empty)
- Optional winning score threshold (integer input, 0 = no limit)
- Quick start with default settings

**Game State**
- Current round number display
- Running score totals for all players
- Clear indication of leader
- Visual indicator when winning threshold is reached (if set)

### 2. Score Entry
**Round Scoring**
- Simple integer input for each player per round
- Positive values only (validation required)
- Batch entry: score all players before advancing to next round
- Edit capability for current round only
- Confirmation before advancing rounds

**Score Calculation**
- Automatic cumulative scoring (sum of all completed rounds)
- Real-time total updates
- Tie handling display

### 3. Statistics & History
**Player Statistics (Persistent)**
- Games played count
- Total points scored across all games
- Average points per game
- Win count and win percentage
- Best single-game score

**Current Game View**
- Scrollable round-by-round breakdown
- Player ranking display
- Game duration tracking

### 4. User Interface
**Design Requirements**
- "Cute" aesthetic: rounded corners, pleasant colors, friendly typography
- High contrast for readability
- Standard iOS fonts (SF Pro family)
- Consistent with iOS Human Interface Guidelines
- Adaptive layout for iPhone/iPad

**Orientation Support**
- Portrait: Optimized for one-handed use
- Landscape: Table-friendly layout for group viewing
- Automatic rotation handling

## Technical Specifications

### Platform Requirements
- iOS 15.0+ (SwiftUI compatibility)
- iPhone 8 and newer
- iPad (6th generation) and newer
- Xcode 14+ for development

### Data Storage
- Core Data for local persistence
- No cloud sync or backup
- Automatic data cleanup for old games (configurable retention)

### Performance Targets
- App launch: <2 seconds
- Score entry response: <100ms
- Maximum game size: 12 players × 50 rounds
- Storage footprint: <10MB for typical usage

## User Stories

### Primary Flows
1. **Quick Game**: User opens app → adds 4 players → starts scoring immediately
2. **Tournament Setup**: User sets winning score to 100 → adds 8 players → plays to completion
3. **Ongoing Game**: User returns to app → continues existing game → views statistics

### Edge Cases
- Handle app backgrounding during score entry
- Graceful degradation with low memory
- Invalid input handling and user feedback

## Success Metrics
- User completes setup within 30 seconds
- Zero data loss during normal app lifecycle
- Intuitive operation without tutorial or help documentation
- Positive App Store rating (4+ stars target)

## Non-Functional Requirements

### Usability
- No learning curve for card game players
- Accessible to users 50+ years old
- Works reliably in social/party environments

### Reliability
- No crashes during normal operation
- Data persistence across app updates
- Graceful handling of iOS interruptions (calls, notifications)

### Performance
- Smooth scrolling with 50+ rounds
- Instant response to touch interactions
- Minimal battery usage

## Out of Scope (Explicitly Not Included)
- Network connectivity features
- User accounts or profiles
- Game rules explanation or tutorial
- Export/sharing functionality
- In-app purchases or monetization
- Apple Watch companion app
- Accessibility features beyond standard iOS support
- Multiple simultaneous games
- Game session save/restore
- Undo functionality beyond current round