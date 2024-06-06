#!/bin/bash

AMASS_CONFIG_PATH="/app/scripts/config.ini";

mkdir "$1"

run_amass() {
    /app/scripts/amass enum -config $AMASS_CONFIG_PATH -d "$1" -o amass_results.txt 1>/dev/null 2>/dev/null
}

run_assetfinder() {
    assetfinder --subs-only $1 > assetfinder_results.txt
}

run_subfinder() {
    subfinder -d "$1" > subfinder_results.txt 1>/dev/null 2>/dev/null
}

run_shodan() {
    # Output is weirdo, didn't parse it
    shodan domain "$1" > shodan_domains
}

run_httpx() {
    cat domains | httpx -p 80,443,22,445,8080,8443,3000,5000,8000,9000,9443 --status-code 2>/dev/null > httpx
    cat httpx | cut -d" " -f1 > httpx_without_status_code
}

run_gowitness() {
    gowitness file -f httpx_without_status_code 1>/dev/null 2>/dev/null
}

run_waybackurls() {
    while read -r line; do echo "$line" | waybackurls 2>/dev/null >> waybackurls_results; done < httpx_without_status_code
}

run_nuclei() {
    cat httpx_without_status_code | nuclei 2>/dev/null >> nuclei_results.txt
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

# Jump into the folder
pushd "$1" 1>/dev/null;

run_assetfinder "$1" &
run_subfinder "$1" &
run_amass "$1" &
wait_for_process
concat_all
run_httpx "$1"
# --------------------------------
# commented as it takes a long time to test 
#run_waybackurls "$1" &
#run_gowitness "$1" &
#run_nuclei "$1" &
#wait_for_process
# --------------------------------

# Jump out of the folder 
popd

zip -r "$1.zip" "$1"
curl "$API_URL/done?domain=$1"