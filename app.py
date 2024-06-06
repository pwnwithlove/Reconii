from flask import Flask, render_template, request, Response, jsonify, send_from_directory
import threading
from helpers import scanner
from database import init_db, db_session
from models import Scan
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/getscan',methods=['GET'])
def getscan():
    scans = Scan.query.all()
    to_ret = []
    for scan in scans:
        to_ret.append({"domain":scan.domain, "status": scan.finished})
    return jsonify(to_ret)

@app.route('/scan', methods=['POST'])
def scan():
    domain = request.form['domain']  
    try:
        d = Scan(domain)
        db_session.add(d)
        db_session.commit()
        t1 = threading.Thread(target=scanner, args=(domain,))
        t1.start()
        return jsonify({"ok":"Scan launch."})
    except Exception as e:
        print(e,flush=True)
        return jsonify({"err":"An error occured, please try again."})

@app.route('/download', methods=['GET'])
def download():
    if request.args.get("domain"):
        d = Scan.query.filter(Scan.domain == request.args.get("domain")).first()
        if(d):
            if(d.finished == 1):
                return send_from_directory(os.environ.get("SCRIPTS_FOLDER"), request.args.get("domain")+".zip")
            else:
                return "Le scan n'est pas fini."
        
        else:
            return "Le scan pour ce domaine n'a jamais été lancé."

@app.route('/done', methods=['GET'])
def scan_done():
    if request.remote_addr == "127.0.0.1":
        if request.args.get("domain"):
            d = Scan.query.filter(Scan.domain == request.args.get("domain")).first()
            if(d):
                d.finished = 1
                d.path_to_res = f'/app/scripts/{request.args.get("domain")}.zip'
                db_session.commit()
            else:
                return "ERROR"
            return "OK"
    return "Unauthorized access."

if __name__ == '__main__':
    app.run(debug=True)
