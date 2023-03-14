#! /bin/env bash

source stats.sh


functions=( "bake" "upgrade" )
cookie_cost=5


function main ()
{
	while (( 1 )); do
		clear
		print_banner


		local i=1

		for option in "${functions[@]}"; do
			echo "${i}. ${option}"
			let "i += 1"
		done

		local op_num
		read -p "> " op_num

		let "op_num -= 1 "

		local function="${functions[$op_num]}"

		eval "$function"
		
		read -p "Press enter to continue"


	done
}

function bake ()
{
	echo "Baking ${batch_num} cookies..."

	local time_pet
	let "time_per = sleeptime / batch_num"

	local done_amount=0

	while [[ "${done_amount}" < "${batch_num}" ]]; do
		let "points += 1"
		local done_string="["

		local j
		let "j = done_amount + 1"

		while [[ "${j}" > 0 ]]; do
			done_string="${done_string}#"
			let "j -= 1"
		done

		local j
		let "j = (batch_num - done_amount) - 1"

		while [[ "${j}" > 0 ]]; do
			done_string="${done_string}."
			let "j -= 1"
		done
		
		done_string="${done_string}]"
		
		clear
		print_banner
		echo "Baking ${batch_num} cookies..."

		echo "${done_string}"
		sleep ${time_per}

		let "done_amount += 1"
	done
}

function upgrade ()
{
	clear
	print_banner

	echo "1. Amount"
	echo "2. Speed"
	echo
	echo "0. Go back"

	local option
	read -p "> " option

	clear
	print_banner


	if [[ "${option}" == 1 ]]; then
		local amount
		read -p "How many? > " amount

		local price
		let "price = amount * cookie_cost"
		echo $price


		if [[ "${price}" > "${points}" ]]; then
			clear
			print_banner
			echo "Not enough cookies."
			return
		elif (( "${price}" <= 0 )); then
			clear
			print_banner
			return
		fi


		let "points -= price"
		let "batch_num += amount"
		let "sleeptime += 5"

	elif [[ "${option}" == 2 ]]; then
		local amount
		read -p "Remove how many seconds? > " amount

		local price
		let "price = amount * 2"
		echo $price


		if [[ "${price}" > "${points}" ]]; then
			clear
			print_banner
			echo "Not enough cookies."
			return
		elif (( "${price}" <= 0 )); then
			clear
			print_banner
			return
		fi


		let "points -= price"
		let "sleeptime -= amount"
	
	fi
}

function print_banner ()
{
	echo "[Cookie game] | Cookies: ${points} | Sleeptime: ${sleeptime} | Batch Size: ${batch_num}"
}

main
exit 0
