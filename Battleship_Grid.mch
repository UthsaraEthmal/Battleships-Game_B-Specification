/* Battleship_Grid
  * Author: Ethmal Uthsara(w1956195/20221590)
 * Creation date: 12/24/2025
 */
MACHINE
    Battleship_Grid
    
    SETS
 PLAYERS = {Player1, Player2};              
    GAMESTATE = {SettingUp, Playing, Player1_Wins, Player2_Wins}; 
    ORIENTATION = {Across, Down};
     REPORT = { 
        settingUp,
        success,
        placed_already,
        error_not_in_grid,
        error_overlap,
        error_order,
        hit,
        miss,
        submarine_hit,
        submarine_sunk,
        destroyer_hit,
        destroyer_sunk,
        cruiser_hit,
        cruiser_sunk,
        error_already_shot,
        players_placing_ships,
        play_Now,
        Player_1_Wins,
        Player_2_Wins
    }


CONSTANTS
      GRID, row, col                         

PROPERTIES
    row = 1..10 &                           
    col = 1..10 &                             
    GRID = row * col

END
