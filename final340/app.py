from flask import Flask, render_template, redirect, request
from flask_mysqldb import MySQL

app = Flask(__name__)

# Database configuration
app.config['MYSQL_HOST'] = 'dam_coastal_mysql_host'
app.config['MYSQL_USER'] = 'dam_coastal_mysql_user'
app.config['MYSQL_PASSWORD'] = '0323'
app.config['MYSQL_DB'] = 'cs340_lookm'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# Function to execute SELECT queries
def select_query(entity):
    cur = mysql.connection.cursor()
    query = f"SELECT * FROM {entity};"
    cur.execute(query)
    data = cur.fetchall()
    return data

# Routes
@app.route('/')
@app.route('/index.html')
def index():
    return render_template("index.html")

@app.route('/activities.html', methods=['POST', 'GET'])
def activities():
    # Retrieve activities data from the database
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Activities;")
    activities_data = cur.fetchall()
    cur.close()
    return render_template('activities.html', activities_data=activities_data)

@app.route('/rooms.html', methods=['GET'])
def rooms():
    # Retrieve rooms data from the database
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Rooms;")
    rooms_data = cur.fetchall()
    cur.close()
    return render_template('rooms.html', rooms_data=rooms_data)

@app.route('/reservations.html', methods=['POST', 'GET'])
def reservations():
    # Fetch existing reservations and related data
    reservation_data = select_query("Reservation")
    customer_data = select_query("Customers")
    room_data = select_query("Rooms")
    resort_activities_data = select_query("Resort_Activities")
    reservation_resort_activities_data = select_query("Reservation_Resort_Activities")
    
    if request.method == 'POST' and request.form.get("query") == "insertReservation":
        customer_id = request.form.get('customer_ID')
        room_id = request.form.get('room_ID')
        checkin_date = request.form.get('Checkin_date')
        checkout_date = request.form.get('Checkout_date')
        total_price = request.form.get('Total_price')

        insert_reservation_query = (
            "INSERT INTO Reservation (customer_ID, room_ID, Checkin_date, Checkout_date, Total_price) "
            "VALUES (%s, %s, %s, %s, %s);",
            (customer_id, room_id, checkin_date, checkout_date, total_price)
        )

        con = mysql.connection
        cur = con.cursor()
        cur.execute(*insert_reservation_query)
        con.commit()

        # Assuming you also handle Reservation_Resort_Activities here.
        # You would need additional logic to handle inserting into this table, possibly based on additional form inputs.

        return redirect('/reservations.html')

    return render_template(
        "reservations.html",
        reservation_data=reservation_data,
        customer_data=customer_data,
        room_data=room_data,
        resort_activities_data=resort_activities_data,
        reservation_resort_activities_data=reservation_resort_activities_data
    )

# Add more routes as needed

if __name__ == '__main__':
   app.run(debug=True, port=5006)
