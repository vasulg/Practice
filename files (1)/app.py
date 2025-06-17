import os
import subprocess
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# Utility function to execute PowerShell script with arguments
def run_powershell(script_name, *args):
    script_path = os.path.join("scripts", script_name)
    args_str = ' '.join([f'"{a}"' for a in args])
    command = f'powershell -ExecutionPolicy Bypass -File "{script_path}" {args_str}'
    try:
        result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, encoding='utf-8')
    except subprocess.CalledProcessError as e:
        result = e.output
    return result

@app.route("/", methods=["GET", "POST"])
def index():
    output = ""
    input_fields = []
    button = request.form.get("button")
    search_input = request.form.get("search_input", "")
    # Handle the button logic
    if button == "onboard_user":
        # Show input fields for onboarding new user
        input_fields = [
            {"id": "firstname", "label": "First Name", "type": "text"},
            {"id": "lastname", "label": "Last Name", "type": "text"},
            {"id": "description", "label": "Description", "type": "text"},
            {"id": "title", "label": "Title", "type": "text"},
            {"id": "department", "label": "Department", "type": "text"},
        ]
        if all(x in request.form for x in ["firstname", "lastname", "description", "title", "department"]):
            output = run_powershell(
                "onboard_user.ps1",
                request.form["firstname"],
                request.form["lastname"],
                request.form["description"],
                request.form["title"],
                request.form["department"],
            )
    elif button == "assign_license":
        input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
        if "username" in request.form:
            output = run_powershell("assign_license.ps1", request.form["username"])
    elif button == "offboard_user":
        input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
        if "username" in request.form and request.form.get("confirm_offboard") == "yes":
            output = run_powershell("offboard_user.ps1", request.form["username"])
        elif "username" in request.form:
            output = f"Confirm offboarding user: {request.form['username']}<form method='post'><input type='hidden' name='button' value='offboard_user'><input type='hidden' name='username' value='{request.form['username']}'><button name='confirm_offboard' value='yes'>Yes, Remove All Memberships</button></form>"
    elif button == "revoke_license":
        input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
        if "username" in request.form and request.form.get("confirm_revoke") == "yes":
            output = run_powershell("revoke_license.ps1", request.form["username"])
        elif "username" in request.form:
            output = f"Confirm revoking license for user: {request.form['username']}<form method='post'><input type='hidden' name='button' value='revoke_license'><input type='hidden' name='username' value='{request.form['username']}'><button name='confirm_revoke' value='yes'>Yes, Revoke License</button></form>"
    elif button == "show_locked_out":
        output = run_powershell("show_locked_out.ps1")
    elif button == "user_lockout_reason":
        input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
        if "username" in request.form:
            output = run_powershell("user_lockout_reason.ps1", request.form["username"])
    elif button == "user_signin_machines":
        input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
        if "username" in request.form:
            output = run_powershell("user_signin_machines.ps1", request.form["username"])
    elif button == "show_user_ip":
        if search_input:
            output = run_powershell("show_user_ip.ps1", search_input)
        else:
            input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
    elif button == "show_logged_in_users":
        output = run_powershell("show_logged_in_users.ps1")
    elif button == "show_user_recent_lockout":
        if search_input:
            output = run_powershell("user_recent_lockout.ps1", search_input)
        else:
            input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
    elif button == "view_expiring_accounts":
        output = run_powershell("view_expiring_accounts.ps1")
    elif button == "get_user_properties":
        if search_input:
            output = run_powershell("get_user_properties.ps1", search_input)
        else:
            input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
    elif button == "add_user_membership":
        input_fields = [
            {"id": "username", "label": "Username (sAMAccountName)", "type": "text"},
            {"id": "groupname", "label": "Group Name", "type": "text"},
        ]
        if "username" in request.form and "groupname" in request.form:
            output = run_powershell("add_user_membership.ps1", request.form["username"], request.form["groupname"])
    elif button == "delete_user_membership":
        input_fields = [
            {"id": "username", "label": "Username (sAMAccountName)", "type": "text"},
            {"id": "groupname", "label": "Group Name", "type": "text"},
        ]
        if "username" in request.form and "groupname" in request.form:
            output = run_powershell("delete_user_membership.ps1", request.form["username"], request.form["groupname"])
    elif button == "show_logged_in_machine":
        if search_input:
            output = run_powershell("show_logged_in_machine.ps1", search_input)
        else:
            input_fields = [{"id": "username", "label": "Username (sAMAccountName)", "type": "text"}]
    elif button == "clear_ccmcache":
        if search_input:
            output = run_powershell("clear_ccmcache.ps1", search_input)
        else:
            input_fields = [{"id": "machinename", "label": "Machine Name", "type": "text"}]
    elif button == "show_c_drive":
        if search_input:
            output = run_powershell("show_c_drive.ps1", search_input)
        else:
            input_fields = [{"id": "machinename", "label": "Machine Name", "type": "text"}]
    elif button == "email_ad_user_audit":
        output = run_powershell("email_ad_user_audit.ps1")
    return render_template(
        "index.html", 
        output=output, 
        input_fields=input_fields, 
        search_input=search_input
    )

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)