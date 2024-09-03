#! /bin/bash
# Series Analyzer by Idan
# 17.8.2024

create_menu() { # Function to show textual UI
    local flag=0
	while [[ flag -eq 0 ]] 
    do 
        clear
        echo "Welcome to $0 $USER, please select an option from the menu:"
        PS3="Enter a number: "
        select opt in "Input new series" "Display current series" "Show sorted series" "Show maximum value" "Show minimum value" "Calculate the average" "Show the number of members" "Calculate the sum of all members" Exit; do
            case $opt in
            "Input new series")
                clear
                read_input
                flag=1
                break
                ;;
            "Display current series")
                clear
                display_series
                sleep 3
                break
                ;;
            "Show sorted series")
                clear
                display_sorted_series
                sleep 3
                break
                ;;
            "Show maximum value")
                clear
                display_max_value
                sleep 3
                break
                ;;
            "Show minimum value")
                clear
                display_min_value
                sleep 3
                break
                ;;
            "Calculate the average")
                clear
                display_series_average
                sleep 3
                break
                ;;
            "Show the number of members")
                clear
                display_array_count
                sleep 3
                break
                ;;
            "Calculate the sum of all members")
                clear
                display_series_sum
                sleep 3
                break
                ;;
            Exit)
                echo "Exiting..."
                flag=1
                break
                ;;
            *)
                echo "Error - Please select an option from the menu"
                sleep 1
                break
            ;;
            esac
        done
    done
}

# Function to display the series in sorted order
sort_series() {
    echo "$(echo "${series[@]}" | tr ' ' '\n' | sort -n)"
}

# Function to calculate the sum of elements in the 'series' array
calculate_sum() {
    local sum=0  # Initialize the sum variable to 0

    # Loop through each element in the 'series' array
    for num in "${series[@]}"; do
        (( sum += num ))  # Add the current element to the sum
    done

    echo "$sum"  # Output the total sum
}

# Function to display the elements of the 'series' array
display_series() { 
    # Echoes all the elements of the 'series' array, separated by spaces
    echo "${series[@]}"
}

# Function to display the sorted elements of the 'series' array
display_sorted_series() {
    # Call the sort_series function and store the result in the 'sorted_series' array
    sorted_series=($(sort_series))

    # Print the sorted series, with the elements separated by spaces
    echo "The sorted series is: ${sorted_series[@]}"
}

# Function to display the maximum value in the 'series' array
display_max_value() {
    # Call the sort_series function to sort the 'series' array and store the result in 'sorted_series'
    sorted_series=($(sort_series))

    # Print the last element of the sorted array, which is the maximum value
    echo "The maximum value is: ${sorted_series[-1]}"
}

# Function to display the minimum value in the 'series' array
display_min_value() {
    # Call the sort_series function to sort the 'series' array and store the result in 'sorted_series'
    sorted_series=($(sort_series))

    # Print the first element of the sorted array, which is the minimum value
    echo "The minimum value is: ${sorted_series[0]}"
}

# Function to display the sum of all elements in the 'series' array
display_series_sum() {
    # Call the calculate_sum function to compute the sum and store it in the 'sum' variable
    local sum=$(calculate_sum)

    # Print the sum of all elements
    echo "The sum of all members is: $sum"
}

# Function to display the average of all elements in the 'series' array
display_series_average() {
    # Call the calculate_sum function to compute the sum and store it in the 'sum' variable
    local sum=$(calculate_sum)

    # Calculate the number of elements in the 'series' array and store it in the 'count' variable
    local count=${#series[@]}

    # Calculate the average by dividing the sum by the count, using 'bc' for floating-point precision
    local avg=$(echo "scale=2; $sum / $count" | bc)

    # Print the average of all elements
    echo "The average of all members is: $avg" 
}

# Function to display the number of elements in the 'series' array
display_array_count() {
    # Print the number of elements in the 'series' array using ${#series[@]}
    echo "The number of members in the array is: ${#series[@]}"
}

input_validation() {
    local is_valid_input=1  # Start with assuming the input is valid
    local series=("$@")

    # Check if the series has at least 3 elements
    if [[ "${#series[@]}" -lt 3 ]]; then
        is_valid_input=0
    else
        # Validate each number in the series
        for number in "${series[@]}"; do
            if [[ ! "$number" =~ ^[1-9][0-9]*$ ]]; then
                is_valid_input=0
                break  # Stop checking further if an invalid number is found
            fi
        done
    fi

    # Take action based on the validation result
    if [[ $is_valid_input -eq 0 ]]; then
        read_input  # Re-prompt for input if validation fails
    else
        create_menu  # Proceed to menu if validation succeeds
    fi
}

read_input() {
    local newseries
    # Prompt the user for input
    echo "Enter at least 3 elements separated by spaces:"
    # Read the input into an array
    read -ra newseries
    input_validation "${newseries[@]}"
}

input_validation "$@" # Starting function: Validate the input coming from the external arguments
