#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

OPTION(){
echo -e '\nEnter a selection.'

}

MAIN_MENU(){
  echo -e "\n~~~~ MY SALON ~~~~\n"
  echo "Please select a service:"
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo SERVICE NAME: $SERVICE_NAME
  #if service doesn't exist
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-4]+$ ]]
  then
    #show list of services again
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU
  else
    #check phone number
    echo -e "\nWhat's your phone number"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
    #if not customer, get name and add
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_NAME,$CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"  
  fi
}

MAIN_MENU
