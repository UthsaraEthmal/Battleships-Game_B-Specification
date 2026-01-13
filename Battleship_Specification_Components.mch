/* Battleship_Specification_Components
 * Author: Ethmal Uthsara(w1956195/20221590)
 * Creation date: 12/24/2025
 */
MACHINE
    Battleship_Specification_Components
EXTENDS Battleship_Grid
     
VARIABLES
    submarine,
    destroyer,
    cruiser,
    game_state , 
    hits,                                  
    num_shots_taken,                            
    shots,                                 
    player_turn,
    num_sunk 
                               
    
INVARIANT
    submarine : PLAYERS --> POW(GRID) &              
    destroyer : PLAYERS --> POW(GRID) &            
    cruiser : PLAYERS --> POW(GRID) &              
    game_state : GAMESTATE&
   
    card(submarine(Player1)) <= 1 &//submarine occupying 1 square
    card(submarine(Player2)) <= 1 &
    card(destroyer(Player1)) <= 2 &//destroyer occupying 2 squares
    card(destroyer(Player2)) <= 2 &
    card(cruiser(Player1)) <= 3 &//cruiser occupying 3 squares
    card(cruiser(Player2)) <= 3 &

    //same player cannot occupy the same square
    submarine(Player1) /\ destroyer(Player1) = {} &
    submarine(Player1) /\ cruiser(Player1) = {} &
    destroyer(Player1) /\ cruiser(Player1) = {} &
    submarine(Player2) /\ destroyer(Player2) = {} &
    submarine(Player2) /\ cruiser(Player2) = {} &
    destroyer(Player2) /\ cruiser(Player2) = {}&
    
    
    
    hits : PLAYERS --> POW(GRID) &                   
    num_shots_taken : PLAYERS --> POW(GRID) &             
    shots : PLAYERS --> NAT &                          
    player_turn : PLAYERS &
    num_sunk : PLAYERS --> NAT
    
INITIALISATION
    
    //at the start of the game the number of ships should be empty-0
    submarine := {Player1 |-> {}, Player2 |-> {}} ||
    destroyer := {Player1 |-> {}, Player2 |-> {}} ||
    cruiser := {Player1 |-> {}, Player2 |-> {}} ||


    //at the start of the game the number of hits should be 0-empty
    hits := {Player1 |-> {}, Player2 |-> {}} ||
    num_shots_taken := {Player1 |-> {}, Player2 |-> {}} ||
    shots := {Player1 |-> 0, Player2 |-> 0} ||
    
    // "Player 1" should attcks FIRST
    player_turn := Player1 ||
    game_state := SettingUp||
    
    //at the start of the game the number of sunks should be 0-empty
    num_sunk := { Player1 |-> 0, Player2 |-> 0 }
   
OPERATIONS
    
    
/*------PlayNow Operation(Additional)-------*/
/*------------------------------------------*/ 

//after the ship placement/setting Up is complete  users can start the game
report <-- PlayNow =
PRE
    game_state = SettingUp &
    cruiser(Player1) /= {} &
    cruiser(Player2) /= {}
THEN
    game_state := Playing ||
    report := play_Now
END;      
        
/*--------DeploySubMarine Operation---------*/ 
/*------------------------------------------*/ 

report <-- DeploySubMarine(player, position) =
PRE
    player : PLAYERS &
    position : GRID &
    game_state = SettingUp
THEN
    //checks whether the submarine has  placed already
    IF submarine(player) /= {} 
    THEN
        report := placed_already
    ELSE
        
        IF (position : GRID)
        THEN
            submarine(player) := {position} ||
            report := success
        ELSE
            //checks outer limits of the grid
            report := error_not_in_grid
        END
    END
END;



/*--------DeployDestroyer Operation---------*/
/*------------------------------------------*/ 

report <-- DeployDestroyer(player, position, orientation) =
PRE
    player : PLAYERS &
    position : GRID &
    orientation : ORIENTATION &
    game_state = SettingUp
THEN
    IF submarine(player) = {} 
    THEN//submarine should placed first
        report := error_order
    //checks whether the destroyer has  placed already
ELSIF destroyer(player) /= {} 
THEN
        report := placed_already
    //across orientation
    ELSE
        IF orientation = Across 
        THEN
            //outer limits of the grid checking
            IF prj2(row, col)(position) + 1 > 10 
            THEN
                report := error_not_in_grid

    //same player ships can not overlap
            ELSIF
                { position,( prj1(row, col)(position),prj2(row, col)(position) + 1 )} /\
                ( submarine(player) \/ destroyer(player) \/ cruiser(player) ) /= {}
            THEN
                report := error_overlap

            ELSE
                destroyer(player) :={ position,( prj1(row, col)(position), prj2(row, col)(position) + 1 )} ||
                report := success
            END
        //down orientation
        ELSE
             
            IF prj1(row, col)(position) + 1 > 10 
            THEN
                report := error_not_in_grid

            ELSIF
                { position,( prj1(row, col)(position) + 1,prj2(row, col)(position) ) } /\
                ( submarine(player) \/ destroyer(player) \/ cruiser(player) ) /= {}
            THEN
                report := error_overlap

            ELSE
                destroyer(player) := { position,( prj1(row, col)(position) + 1,prj2(row, col)(position) ) } ||
                report := success
            END
        END
    END
END;



/*--------DeployCruiser Operation---------*/
/*------------------------------------------*/ 

report <-- DeployCruiser(player, position, orientation) =
PRE
    player : PLAYERS &
    position : GRID &
    orientation : ORIENTATION &
    game_state = SettingUp
THEN
    //destroyer should placed first
    IF destroyer(player) = {} 
    THEN
        report := error_order 
    //checks whether the destroyer has  placed already
ELSIF cruiser(player) /= {} 
THEN
        report := placed_already

    ELSE
        //across orientation
        IF orientation = Across 
        THEN
            //outer limits of the grid checking 
            IF prj2(row, col)(position) + 2 > 10 
            THEN
                report := error_not_in_grid
             //same player ships can not overlap
            ELSIF
                { position,( prj1(row, col)(position), prj2(row, col)(position) + 1 ),( prj1(row, col)(position), prj2(row, col)(position) + 2 )} /\
                ( submarine(player) \/ destroyer(player) \/ cruiser(player) ) /= {}
            THEN
                report := error_overlap

            ELSE
                cruiser(player) :=
                    { position,( prj1(row, col)(position),prj2(row, col)(position) + 1 ),( prj1(row, col)(position), prj2(row, col)(position) + 2 )} ||
                report := success
            END

        ELSE
           //down orientation
            IF prj1(row, col)(position) + 2 > 10 
            THEN
                report := error_not_in_grid

            ELSIF
                { position,( prj1(row, col)(position) + 1, prj2(row, col)(position) ),( prj1(row, col)(position) + 2, prj2(row, col)(position) )} /\
                ( submarine(player) \/ destroyer(player) \/ cruiser(player) ) /= {}
            THEN
                report := error_overlap

            ELSE
                cruiser(player) :=
                    { position,( prj1(row, col)(position) + 1,prj2(row, col)(position) ),( prj1(row, col)(position) + 2,prj2(row, col)(position) ) } ||
                report := success
            END
        END
    END
END;







/*--------Shoot Operation---------*/
/*------------------------------------------*/ 
  report <-- Shoot(player, target) =
PRE
    player : PLAYERS &
    player = player_turn &
    target : GRID &
     game_state = Playing &
    cruiser(Player1) /= {} &
    cruiser(Player2) /= {}
THEN
    //checks already shot or not the square
    IF target : num_shots_taken(player)
    THEN
        report := error_already_shot

    ELSE//recods the shots
        num_shots_taken(player) := num_shots_taken(player) \/ {target} ||
        //incrementing the total shots
        shots(player) := shots(player) + 1 ||


        /*---player 1 shots---*/
        
        
        IF player = Player1 
        THEN
            hits(Player1) := hits(Player1) \/ {target} ||
            
           
 //player 1-->submarine shoot
            IF target : submarine(Player2) 
            THEN
                //remove shoted square
                submarine(Player2) := submarine(Player2) - {target} ||

                IF submarine(Player2) <: hits(Player1) \/ {target} 
                THEN
                    //incrementing the number of sunks
                    num_sunk := num_sunk <+ { Player2 |-> num_sunk(Player2) + 1 } ||
                    report := submarine_sunk
                END
                
                
                
                //player 1-->destroyer shoot

            ELSIF target : destroyer(Player2) 
            THEN//remove shooted square
                destroyer(Player2) := destroyer(Player2) - {target} ||
                //cheking destroyer sunk
                IF destroyer(Player2) <: hits(Player1) \/ {target} 
                THEN
                    //incrementing the number of sunks
                    num_sunk := num_sunk <+ { Player2 |-> num_sunk(Player2) + 1 } ||
                    report := destroyer_sunk
                ELSE
                    report := destroyer_hit
                END
                
                
                //player 1-->cruiser shoot

            ELSIF target : cruiser(Player2) 
            THEN//remove shoted square
                cruiser(Player2) := cruiser(Player2) - {target} ||
                //cheking cruiser sunk
                IF cruiser(Player2) <: hits(Player1) \/ {target} 
                THEN
                    //incrementing the number of sunks
                    num_sunk := num_sunk <+ { Player2 |-> num_sunk(Player2) + 1 } ||
                    report := cruiser_sunk
                ELSE
                    report := cruiser_hit
                END

            ELSE
                report := miss
            END
            
            
        /*---player 2 shots---*/
        


        ELSE
            hits(Player2) := hits(Player2) \/ {target} ||
            
            
             //player 2-->submarine shoot
            IF target : submarine(Player1)
            THEN//remove shoted square
                submarine(Player1) := submarine(Player1) - {target} ||

                IF submarine(Player1) <: hits(Player2) \/ {target}
                THEN
                    num_sunk := num_sunk <+ { Player1 |-> num_sunk(Player1) + 1 } ||
                    report := submarine_sunk
                END
                
                 //player 2-->destroyer shoot

            ELSIF target : destroyer(Player1) 
            THEN//remove shoted square
                destroyer(Player1) := destroyer(Player1) - {target} ||

                IF destroyer(Player1) <: hits(Player2) \/ {target} 
                THEN
                    num_sunk := num_sunk <+ { Player1 |-> num_sunk(Player1) + 1 } ||
                    report := destroyer_sunk
                ELSE
                    report := destroyer_hit
                END
                
                //player 2-->cruiser shoot

            ELSIF target : cruiser(Player1) 
            THEN//remove shoted square
                cruiser(Player1) := cruiser(Player1) - {target} ||

                IF cruiser(Player1) <: hits(Player2) \/ {target}
                THEN
                    num_sunk := num_sunk <+ { Player1 |-> num_sunk(Player1) + 1 } ||
                    report := cruiser_sunk
                ELSE
                    report := cruiser_hit
                END

            ELSE
                report := miss
            END
        END ||

        /*---player turn rotation and winner selection---*/
        IF player = Player1 
        THEN
            IF (card(submarine(Player2)) + card(destroyer(Player2)) + card(cruiser(Player2))) = 0 
            THEN
                game_state := Player1_Wins
                
            ELSE
                player_turn := Player2
            END
        ELSE
            IF (card(submarine(Player2)) + card(destroyer(Player2)) + card(cruiser(Player2))) = 0 
            THEN
               game_state := Player2_Wins
             
            ELSE
                player_turn := Player1
            END
        END
    END
END
       





END
