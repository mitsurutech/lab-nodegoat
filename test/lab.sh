#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" lab-check-probe bash -c "$1"; }
echo "- the database was made for us and user1 signs in"
probe '
set -eu
j=/tmp/j; B=http://nodegoat:4000
code=$(curl -s -o /dev/null -w "%{http_code} %{redirect_url}" -c $j -b $j -d "userName=user1&password=User1_123" $B/login)
[ "$code" = "302 http://nodegoat:4000/dashboard" ] || { echo "sign in answered $code" >&2; exit 1; }
echo "- the sign-in page says whether the name or the password was wrong, so names can be guessed"
curl -s -d "userName=nobody&password=x" $B/login | grep -q "Invalid username" || { echo "no Invalid username" >&2; exit 1; }
curl -s -d "userName=user1&password=x" $B/login | grep -q "Invalid password" || { echo "no Invalid password" >&2; exit 1; }
echo "- user1 can read user2 allocations, which is the insecure direct object reference"
curl -fs -b $j $B/allocations/3 | grep -q "Domestic Stocks" || { echo "allocations/3 not readable" >&2; exit 1; }
echo "- a contribution is evaluated by the server as code: 3*5 comes back as 15"
curl -s -b $j -d "preTax=3*5&afterTax=4&roth=6" $B/contributions -o /dev/null
curl -s -b $j $B/contributions | tr -s " \n" " " | grep -q "Employee Pre-Tax</td> <td>15 %" || { echo "3*5 was not evaluated" >&2; exit 1; }
'
echo "  ok"
