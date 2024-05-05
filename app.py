from flask import Flask, render_template, request, Response
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/scan', methods=['POST'])
def scan():
    domain = request.form['domain']  
    script_path = '/app/scripts/domains' 
    try:
        result = subprocess.run(['/app/scripts/scan.sh', domain], capture_output=True, text=True, cwd=script_path)
        return Response(result.stdout, status=200)
    except subprocess.CalledProcessError as e:
        return Response(e.stderr, status=500)

if __name__ == '__main__':
    app.run(debug=True)
