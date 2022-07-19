#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR -ne year ]]
then
#if winner team not there insert
WINNER_TEAM=$($PSQL "select team_id from teams where name='$WINNER'")
if [[ -z $WINNER_TEAM ]]
then
INSERT_WINNER_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
then
echo "Team Aded : $WINNER"
fi
fi
#if loser team not there insert
LOSER_TEAM=$($PSQL "select team_id from teams where name='$OPPONENT'")
if [[ -z $LOSER_TEAM ]]
then
INSERT_LOSER_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
if [[ $INSERT_LOSER_TEAM == "INSERT 0 1" ]]
then
echo "Team Aded : $LOSER"
fi
fi
#All Teams Should Be Added
fi
done

#fill the games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR -ne year ]]
then
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
LOSER_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
INSERT_ROW=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$LOSER_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
fi

done
