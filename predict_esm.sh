#!/bin/bash

create_input(){
    echo ">wynik
    $1" > input.fasta
}

run_prediction(){
    rm -r wynik
    python /home/nfs/rmadaj/bins/esm/scripts/esmfold_inference.py -i input.fasta -o wynik
}

is_valid_aa_sequence() {
    local sequence=$1
    local valid_chars="ACDEFGHIKLMNPQRSTVWY:"
    for (( i=0; i<${#sequence}; i++ )); do
        local char="${sequence:i:1}"
        if [[ "$valid_chars" != *"$char"* ]]; then
            echo "Nieprawidłowa sekwencja. Sprawdź, czy wszystkie litery odpowiadają aminokwasom"
            return 1
        fi
    done
    echo "
    Podana sekwencja prawidłowa, rozpoczynam obliczenia..."
    return 0
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

echo "Możliwe aminokwasy: ACDEFGHIKLMNPQRSTVWY"
echo "Podaj sekwencję aminokwasów"
read sequence

if (( ${#sequence} < 6 )); then
    echo "Sekwencja zbyt krótka"
else
    if is_valid_aa_sequence "$sequence"; then
        create_input "$sequence"
        sleep 2
        printf "
        Obliczenia w toku... 
        "
        show_loading_bar &
        loading_bar_pid=$!
        run_prediction

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
        rm input.fasta
    fi
fi
kill "$loading_bar_pid"