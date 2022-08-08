-- I learned how fabulous the data analysis is!
-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Check the crime_scene_reports on July 28, 2021, Humphrey Street
SELECT description FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND street = "Humphrey Street"
-- Theft took place at 10:15am at the Humphrey Street bakery.
-- Interviews were conducted today with three witnesses who were present at the time

-- Check the interview
SELECT transcript FROM interviews
WHERE month = 7 AND day = 28 AND year = 2021
-- The thief left the bakery parking lot between 10:15 am and 10:25 am
-- The thief was withdrawing some money on Leggett Street before 10:15 am
-- As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
-- In the call, they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.


-- Check the bakery_security_logs
-- The thief left the bakery parking lot between 10:15 am and 10:25 am
SELECT activity FROM bakery_security_logs
WHERE month = 7 AND day = 28 AND year = 2021 AND hour = 10 AND minute >= 15 and minute <= 25
-- +----------+
-- | activity |
-- +----------+
-- | exit     |
-- | exit     |
-- | exit     |
-- | exit     |
-- | exit     |
-- | exit     |
-- | exit     |
-- | exit     |
-- +----------+


-- Check the license_plate between 10:15 am - 10:25am
SELECT license_plate FROM bakery_security_logs
WHERE month = 7 AND day = 28 AND year = 2021 AND hour = 10 AND activity = "exit" AND minute >= 15 AND minute <= 25
-- +---------------+
-- | license_plate |
-- +---------------+
-- | 5P2BI95       |
-- | 94KL13X       |
-- | 6P58WS2       |
-- | 4328GD8       |
-- | G412CB7       |
-- | L93JTIZ       |
-- | 322W7JE       |
-- | 0NTHK55       |
-- +---------------+



-- Check the phone_calls
-- As the thief was leaving the bakery, duration less than one minute
SELECT id, caller, receiver FROM phone_calls
WHERE month = 7 AND day = 28 AND year = 2021 AND duration < 60
-- +-----+----------------+----------------+
-- | id  |     caller     |    receiver    |
-- +-----+----------------+----------------+
-- | 221 | (130) 555-0289 | (996) 555-8899 |
-- | 224 | (499) 555-9472 | (892) 555-8872 |
-- | 233 | (367) 555-5533 | (375) 555-8161 |
-- | 251 | (499) 555-9472 | (717) 555-1342 |
-- | 254 | (286) 555-6063 | (676) 555-6554 |
-- | 255 | (770) 555-1861 | (725) 555-3243 |
-- | 261 | (031) 555-6622 | (910) 555-3251 |
-- | 279 | (826) 555-1652 | (066) 555-9701 |
-- | 281 | (338) 555-6650 | (704) 555-2131 |
-- +-----+----------------+----------------+


-- Check the atm_transactions on Leggett Street before 10:15 am
SELECT account_number, amount FROM atm_transactions
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw"
-- +----------------+--------+
-- | account_number | amount |
-- +----------------+--------+
-- | 28500762       | 48     |
-- | 28296815       | 20     |
-- | 76054385       | 60     |
-- | 49610011       | 50     |
-- | 16153065       | 80     |
-- | 25506511       | 20     |
-- | 81061156       | 30     |
-- | 26013199       | 35     |
-- +----------------+--------+



-- Check the bank_accounts
SELECT person_id FROM atm_transactions
JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw"
-- +-----------+
-- | person_id |
-- +-----------+
-- | 467400    |
-- | 395717    |
-- | 449774    |
-- | 686048    |
-- | 458378    |
-- | 396669    |
-- | 438727    |
-- | 514354    |
-- +-----------+


-- Check the flights
SELECT origin_airport_id, destination_airport_id FROM flights
WHERE year = 2021 AND month = 7 AND day = 29 AND hour = 8 AND minute = 20
-- +-------------------+------------------------+
-- | origin_airport_id | destination_airport_id |
-- +-------------------+------------------------+
-- | 8                 | 4                      |
-- +-------------------+------------------------+


-- Check the airports
SELECT abbreviation, full_name FROM airports
WHERE city = "Fiftyville"
-- +--------------+-----------------------------+
-- | abbreviation |          full_name          |
-- +--------------+-----------------------------+
-- | CSF          | Fiftyville Regional Airport |
-- +--------------+-----------------------------+


-- Check the passengers
SELECT passport_number, seat FROM passengers
JOIN flights ON flights.id = passengers.flight_id
WHERE year = 2021 AND month = 7 AND day = 29 AND hour = 8 AND minute = 20 AND flight_id = 36
-- +-----------------+------+
-- | passport_number | seat |
-- +-----------------+------+
-- | 7214083635      | 2A   |
-- | 1695452385      | 3B   |
-- | 5773159633      | 4A   |
-- | 1540955065      | 5C   |
-- | 8294398571      | 6C   |
-- | 1988161715      | 6D   |
-- | 9878712108      | 7A   |
-- | 8496433585      | 7B   |
-- +-----------------+------+

-- Check people
SELECT people.name, people.license_plate, person_id, people.phone_number, people.passport_number FROM bakery_security_logs
JOIN people ON bakery_security_logs.license_plate = people.license_plate
JOIN bank_accounts ON bank_accounts.person_id = people.id
JOIN phone_calls ON people.phone_number = phone_calls.caller
JOIN passengers ON people.passport_number = passengers.passport_number
WHERE people.license_plate IN
(
    SELECT license_plate FROM bakery_security_logs
    WHERE month = 7 AND day = 28 AND year = 2021 AND hour = 10 AND activity = "exit" AND minute >= 15 AND minute <= 25
)
AND people.id IN
(
    SELECT person_id FROM atm_transactions
    JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
    WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location = "Leggett Street" AND transaction_type = "withdraw"
)
AND people.phone_number IN
(
    SELECT caller FROM phone_calls
    WHERE month = 7 AND day = 28 AND year = 2021 AND duration < 60
)
AND people.passport_number IN
(
    SELECT passport_number FROM passengers
    JOIN flights ON flights.id = passengers.flight_id
    WHERE year = 2021 AND month = 7 AND day = 29 AND hour = 8 AND minute = 20 AND flight_id = 36
)

-- The information of the thief
-- +-------+---------------+-----------+----------------+-----------------+
-- | name  | license_plate | person_id |  phone_number  | passport_number |
-- +-------+---------------+-----------+----------------+-----------------+
-- | Bruce | 94KL13X       | 686048    | (367) 555-5533 | 5773159633      |
-- +-------+---------------+-----------+----------------+-----------------+

-- Check the receiver
SELECT people.name FROM phone_calls
JOIN people ON people.phone_number = phone_calls.receiver
WHERE month = 7 AND day = 28 AND year = 2021 AND duration < 60 AND caller = "(367) 555-5533"
-- +-------+
-- | name  |
-- +-------+
-- | Robin |
-- +-------+


SELECT airports.city FROM flights
JOIN airports ON flights.destination_airport_id = airports.id
WHERE year = 2021 AND month = 7 AND day = 29 AND hour = 8 AND minute = 20
-- +---------------+
-- |     city      |
-- +---------------+
-- | New York City |
-- +---------------+