import subprocess

def scanner(domain):
    subprocess.run(['/app/scripts/scan.sh', domain], capture_output=True, text=True, cwd="/app/scripts/")
