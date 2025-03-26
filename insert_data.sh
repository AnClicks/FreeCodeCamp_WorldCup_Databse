#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games,teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #getting the values from the table
  if [[ $WINNER != 'winner' ]]
    then
      TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      if [[ -z $TEAM1_NAME ]] 
        then
          #Insert the values in the table
          INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

          if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
            then
              echo Inserted team $WINNER
          fi
      fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
    then
      TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      if [[ -z $TEAM2_NAME ]] 
        then
          #Insert the values in the table
          INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

          if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
            then
              echo Inserted team $OPPONENT
          fi
      fi
  fi

#Inserting year    
 if [[ YEAR != "year" ]]
      then
        #GET WINNER_ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        #GET OPPONENT_ID
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        #INSERT NEW GAMES ROW
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
          # echo call to let us know what was added
          if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
          fi
    fi
    
done