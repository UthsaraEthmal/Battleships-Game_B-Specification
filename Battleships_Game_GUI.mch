/* Battleships_Game_GUI
* Author: Ethmal Uthsara(w1956195/20221590)
 * Creation date: 12/24/2025
 */
MACHINE
    Battleships_Game_GUI
EXTENDS Battleship_Specification_Components 
USES Battleship_Enquiry
    
   
DEFINITIONS
    
    ANIMATION_FUNCTION ==
(    // squares
    {r,c,i | r:1..10 & c:1..21 & i = 0}
    
    // margin squares line
    <+ {r,c,i | r:1..10 & c=11 & i = 1}  

    // Player1 ships
    <+ {r,c,i | (r|->c) : submarine(Player1) & i = 2}
    <+ {r,c,i | (r|->c) : destroyer(Player1) & i = 3}
    <+ {r,c,i | (r|->c) : cruiser(Player1) & i = 4}

    // Player2 ships 
    <+ {r,c,i | (r|->(c-11)) : submarine(Player2) & i = 2}
    <+ {r,c,i | (r|->(c-11)) : destroyer(Player2) & i = 3}
    <+ {r,c,i | (r|->(c-11)) : cruiser(Player2) & i = 4}

    // shots 
    <+ {r,c,i | (r|->c) : hits(Player2) & i = 5}
    <+ {r,c,i | (r|->(c-11)) : hits(Player1) & i = 5}
    

);

    ANIMATION_IMG0 == "images/grid_square.png";
    ANIMATION_IMG1 == "images/empty_square.png";
    ANIMATION_IMG2 == "images/submarine.png";
    ANIMATION_IMG3 == "images/destroyer.png";
    ANIMATION_IMG4 == "images/cruiser.png";
    ANIMATION_IMG5 == "images/shoot.png";

END
