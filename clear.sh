#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo $($PSQL "SELECT setval('appointments_appointment_id_seq', 1, false)")
echo $($PSQL "SELECT setval('customers_customer_id_seq', 1, false)")
echo $($PSQL "SELECT setval('services_service_id_seq', 1, false)")
echo $($PSQL "TRUNCATE TABLE appointments, customers")
