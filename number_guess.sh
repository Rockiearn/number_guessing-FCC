#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME



USERNAME_AVAIL=$($PSQL "select username from users where username = '$USERNAME'")
GAMES_PLAYED=$($PSQL "select count(*) from users inner join games using(user_id) where username = '$USERNAME'")
BEST_GAME=$($PSQL "select min(number_guesses) from users inner join games using(user_id) where username = '$USERNAME'")

if [[ -z $USERNAME_AVAIL ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUM=$(( (RANDOM % 1000) + 1 ))
GUESS=1
echo -n "Guess the secret number between 1 and 1000:"

while read NUM
do
  if  [[ ! $NUM =~ ^[0-9]+$ ]]
  then
    echo -n "That is not an integer, guess again:"
  else
    if [[ $NUM -eq $RANDOM_NUM ]]
    then
      break;
    else
      if [[ $NUM -lt $RANDOM_NUM ]]
      then
      echo -n "It's higher than that, guess again:"
      elif [[ $NUM -gt $RANDOM_NUM ]]
      then
      echo -n "It's lower than that, guess again:"
      fi
    fi
  fi
  GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS  == 1 ]]
then
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
else
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
fi


USER_ID=$($PSQL "SELECT user_id from users where username = '$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(number_guesses, user_id) values ($GUESS, $USER_ID)")
