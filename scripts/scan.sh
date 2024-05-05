#!/bin/bash

AMASS_CONFIG_PATH="/app/scripts/config.ini";

check_command() {
    if [ "$1" != "amass" ] && ! type "$1" >/dev/null 2>&1; then
        echo "La commande '$1' n'existe pas."
        exit 1
    fi
}

run_amass() {
    echo "[+] Running amass"
    /app/scripts/amass enum -config $AMASS_CONFIG_PATH -d $1 -o amass_results.txt 1>/dev/null 2>/dev/null
    echo "[+] amass ended"
}

run_assetfinder() {
    echo "[+] Running assetfinder"
    assetfinder --subs-only $1 > assetfinder_results.txt
    echo "[+] assetfinder ended"
}

run_subfinder() {
    echo "[+] Running subfinder"
    subfinder -d "$1" > subfinder_results.txt 1>/dev/null 2>/dev/null
    echo "[+] subfinder ended"
}

run_shodan() {
    # Output is weirdo, didn't parse it
    echo "[+] Running shodan"
    shodan domain "$1" > shodan_domains
    echo "[+] shodan ended"
}

run_httpx() {
    echo "[+] Running httpx"
    cat domains | httpx -p 80,443,22,445,8080,8443,3000,5000,8000,9000,9443 --status-code 2>/dev/null > httpx
    cat httpx | cut -d" " -f1 > httpx_without_status_code
    echo "[+] httpx ended"
}

run_gowitness() {
    echo "[+] Running gowitness"
    gowitness file -f httpx_without_status_code 1>/dev/null 2>/dev/null
    echo "[+] gowitness ended"
}

# run_katana() {
#     echo "[+] Running katana"
#     while read -r line; do echo "$line" | katana 2>/dev/null >> katana_results; done < httpx_without_status_code
#     echo "[+] katana ended"
# }

run_waybackurls() {
    echo "[+] Running waybackurls"
    while read -r line; do echo "$line" | waybackurls 2>/dev/null >> waybackurls_results; done < httpx_without_status_code
    echo "[+] waybackurls ended"
}

run_nuclei() {
    echo "[+] Running nuclei"
    cat httpx_without_status_code | nuclei 2>/dev/null >> nuclei_results.txt
    echo "[+] nuclei ended"
}

concat_all() {
    cat amass_results.txt assetfinder_results.txt subfinder_results.txt > tmp_file
    cat tmp_file | sort -u > domains
    rm tmp_file *.txt
}

wait_for_process() {
    for job in `jobs -p`
    do
        wait $job || let "FAIL+=1"
    done
}

if ! [ $# -gt 0 ]; then
    echo "Usage: $0 mydomain.fr";
    exit;
fi

# Checking if required tools exists
check_command "amass";
check_command "assetfinder";
check_command "httpx";
check_command "gowitness";
# check_command "katana";
check_command "waybackurls";
check_command "subfinder";
check_command "nuclei";
check_command "shodan"

if ! [ -d "$1" ]; then
    # Creating folder and jump into it to store result
    mkdir "$1";
else
    echo "The folder $1 already exists";
    exit;
fi

echo "[+] Starting enumeration, take a coffee.."

# Jump into the folder
pushd "$1" 1>/dev/null;

run_assetfinder "$1" &
run_subfinder "$1" &
run_amass "$1" &
run_shodan "$1" &
wait_for_process
concat_all
run_httpx "$1"
# run_katana "$1" &
run_waybackurls "$1" &
run_gowitness "$1" &
run_nuclei "$1" &
wait_for_process

# Jump out of the folder 
popd

echo "[+] Finish, have fun :)"
