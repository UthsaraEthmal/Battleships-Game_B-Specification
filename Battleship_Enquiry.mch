/* Battleship_Enquiry
 * Author: Ethmal Uthsara(w1956195/20221590)
 * Creation date: 12/24/2025
 */
MACHINE
    Battleship_Enquiry
//EXTENDS 
USES Battleship_Specification_Components
         
    
OPERATIONS 
         
/*------------Enquiry Operations-------------*/


/*--------LocationOfShips Operations---------*/

shipSquares <-- LocationOfShips(player) =
PRE
    player : PLAYERS
THEN
    shipSquares := submarine(player) \/ destroyer(player) \/ cruiser(player)
END;



/*--------shipsCount Operations---------*/

shipsCount <-- ShipsLeft(player) =
PRE
    player : PLAYERS &
    game_state = Playing
THEN
    shipsCount := 3 - (num_sunk(player))
END;



/*--------cellsCount Operations(Additional---------*/

cellsCount <-- ShipCellsLeft(player) =
PRE
    player : PLAYERS
THEN
    cellsCount := card(submarine(player)) +  card(destroyer(player)) + card(cruiser(player))
END;



/*--------shotCount Operations---------*/

shotCount <-- ShotsTaken(player) =
PRE
    player : PLAYERS
THEN
    shotCount := card(num_shots_taken(player))
END;



/*--------GameState Operations---------*/

report <-- GameState =
BEGIN
    IF game_state = SettingUp  THEN
        report := settingUp
    ELSIF (card(submarine(Player1)) + card(destroyer(Player1)) + card(cruiser(Player1))) = 0 
    THEN
        report := Player_2_Wins
    ELSIF (card(submarine(Player2)) + card(destroyer(Player2)) + card(cruiser(Player2))) = 0 
    THEN
        report := Player_1_Wins
    ELSE
        report := play_Now
    END
END 

  
END
