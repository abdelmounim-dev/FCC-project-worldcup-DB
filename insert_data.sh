#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $WINNER != winner ]]
	then
		# check if winner exists in teams
		WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
		# if not found
		if [[ -z $WINNER_ID ]] 
		then
		# insert winner team
			INSERT_WINNER_RESULT=$($PSQL "insert into teams (name) values ('$WINNER')")
			if [[ $INSERT_WINNER_RESULT = "INSERT 0 1" ]]
			then 
				echo inserted into teams: $WINNER
			fi
		fi
		# check if OPPONENT exists in teams
		OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
		# if not found
		if [[ -z $OPPONENT_ID ]] 
		then
		# insert OPPONENT team
			INSERT_OPPONENT_RESULT=$($PSQL "insert into teams (name) values ('$OPPONENT')")
			if [[ $INSERT_OPPONENT_RESULT = "INSERT 0 1" ]]
			then 
				echo inserted into teams: $OPPONENT
			fi
		fi
		# we are certain at this point the teams in the current game line are in the db 
		# get winner and opponent ids		
		OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
		WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
		# Insert the line into the db
		INSERT_GAME_RESULT=$($PSQL "insert into games (\
			year, round, winner_goals, opponent_goals, winner_id, opponent_id\
			) values (\
			$YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID\
			)")
		# if inserted correctly 
		if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]] 
		then
			echo inserted into games: $YEAR $ROUND
		fi

	fi
done

























