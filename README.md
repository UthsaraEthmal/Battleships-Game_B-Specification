# Battleships-Game_B-Specification

# Introduction
This repository contains a formal B specification of a simplified version of the Battleships board game.
The project models the rules, constraints, and behaviour of the game using the B Method, ensuring correctness through formal specification and verification.

In addition to the formal model, a Graphical User Interface (GUI) is included to provide a visual and interactive way to explore the game behaviour.


# Game Overview
Battleships is a two-player strategy guessing game played on 10 × 10 grids, one grid per player.
Each player places a fleet of ships on their own grid, hidden from the opponent.

Players take turns shooting at positions on the opponent’s grid with the goal of destroying all enemy ships.


# Game Rules
GRID


Grid size: 10 × 10

Grid positions are represented as (column, row)
Example: (6,8) represents column 6, row 8.

FLEET

Each player has three ships:

Submarine – occupies 1 square

Destroyer – occupies 1 × 2 squares (horizontal or vertical)

Cruiser – occupies 1 × 3 squares (horizontal or vertical)

CONSTRAINTS
Ships belonging to the same player cannot overlap

Different players may use the same grid coordinates

Ships must be placed in the following order:

1.Submarine

2.Destroyer

3.Cruiser

# Gameplay

1.Setup Phase

Players place their ships on the grid

No fixed order between players

2.Play Phase

Players take turns shooting, starting with Player 1

A shot results in a hit, miss, or sunk

The game ends when one player has no ships remaining


# B Specification
CORE COMPONENTS

Sets and constants defining players, grid positions, ships, and game states

State variables representing ship locations, shots taken, and remaining ships

Invariants ensuring valid ship placement and game progression

OPERATIONS

DeploySubMarine(player, position)

DeployDestroyer(player, position, orientation)

DeployCruiser(player, position, orientation)

Shoot(player, target)

All operations:

Validate inputs

Update the system state

Return success or a descriptive error message

ENQUIRY OPERATIONS

LocationOfShips(player)

ShipsLeft(player)

ShotsTaken(player)

GameState


# Graphical User Interface (GUI)
A GUI is included to:

Visualise the game grid

Show ship placements

Display hits, misses, and sunk ships

Allow easier interaction with the game logic

The GUI complements the formal specification and helps demonstrate game behaviour.

# Tools

Atelier B – syntax and type checking

ProB – model simulation and validatio
