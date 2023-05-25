#!/bin/bash

# rm domeny.fasta

run_prediction(){
    rm -r domeny
    python /home/nfs/rmadaj/bins/esm/scripts/esmfold_inference.py -i domeny.fasta -o domeny
}


echo "Podaj skład domen w strukturze"
read domeny


letters=$(echo "$domeny" | grep -o '[ABCD:]')

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
echo -n "**"

echo ""
        echo ""
        echo "Obliczenia zakończone"
        rm domeny.fasta
fi
