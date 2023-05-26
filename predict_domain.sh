#!/bin/bash

run_prediction(){
    rm -r domeny
    python /home/nfs/rmadaj/bins/esm/scripts/esmfold_inference.py -i domeny.fasta -o domeny
}

show_loading_bar() {
    local chars="/-\|"
    local delay=0.1
    
    while :; do
        for ((i=0; i<${#chars}; i++)); do
            echo -ne "${chars:i:1}" "\r"
            sleep "$delay"
        done
    done
}
printf "
O - obcinanie
P - przycinanie
T - transportowanie
W - wiązanie
L - linker
"

echo "Podaj skład domen w strukturze"

read domeny

printf "
        Obliczenia w toku... 
        "
letters=$(echo "$domeny" | grep -o '[WOPTL:]')

# # Check if any valid letters are found
if [[ -n $letters ]]; then
    echo ">domeny" > domeny.fasta
    # Iterate over the unique letters
    for letter in $(echo "$letters"); do
        # Build the filename
        filename="${letter}.fas"
        
        # Copy the content of the file from the 'domains' directory to 'domain.fas'
        cat "fasta_domains/${filename}" >> domeny.fasta

    done
fi 

# Start the loading bar in the background
show_loading_bar &

# Save the background process ID
loading_bar_pid=$!

run_prediction

sleep 2
printf "
Obliczenia w toku... 
"
while ! run_prediction; do
        sleep 0.2
        printf "."
    done
stars="********"
for (( i=0; i<${#stars}; i++ )); do
    if [[ "${stars:i:1}" == " " ]]; then
        echo -n " "
    else
        echo -n "*"
    fi
    sleep 0.5
done
sleep 2
echo -n "/********/"


echo ""
        echo ""
        echo "Obliczenia zakończone"
        rm domeny.fasta
kill "$loading_bar_pid"
