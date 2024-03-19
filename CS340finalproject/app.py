from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL

app = Flask(__name__)

# Database configuration for Dam Coastal with your credentials
app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_lookm'
app.config['MYSQL_PASSWORD'] = '0323'  # Your password here
app.config['MYSQL_DB'] = 'cs340_lookm'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# Home route
@app.route('/')
def index():
    return render_template('index.html')

# Route for Customers
@app.route('/reservations')
def reservations():
    try:
        cur = mysql.connection.cursor()
        cur.execute('''
            SELECT r.reservation_ID, c.email, ro.Room_type, r.Checkin_date, r.Checkout_date, r.Total_price
            FROM Reservation r
            JOIN Customers c ON r.customer_ID = c.customerID
            JOIN Rooms ro ON r.room_ID = ro.room_ID
        ''')
        reservations_data = cur.fetchall()
        cur.close()
        return render_template('reservations.html', reservations=reservations_data)
    except Exception as e:
        print("Error occurred:", e)
        return str(e)  # For debugging


@app.route('/add_reservation', methods=['POST'])
def add_reservation():
    try:
        email = request.form['email']
        roomType = request.form['roomType']
        checkIn = request.form['checkIn']
        checkOut = request.form['checkOut']
        
        # Debug print
        print(f"Received data: {email}, {roomType}, {checkIn}, {checkOut}")
        
        # Example: Convert roomType to room_ID (ensure this logic matches your data)
        cur = mysql.connection.cursor()
        cur.execute("SELECT room_ID FROM Rooms WHERE Room_type = %s", [roomType])
        room_ID_result = cur.fetchone()
        
        # Check if room type exists
        if room_ID_result:
            room_ID = room_ID_result['room_ID']
        else:
            return "Room type not found", 400
        
        # Check if customer exists, if not, add them
        cur.execute("SELECT customerID FROM Customers WHERE email = %s", [email])
        customer_result = cur.fetchone()
        if customer_result:
            customer_id = customer_result['customerID']
        else:
            cur.execute("INSERT INTO Customers (email) VALUES (%s)", [email])
            customer_id = cur.lastrowid
        
        cur.execute("INSERT INTO Reservation (customer_ID, room_ID, Checkin_date, Checkout_date) VALUES (%s, %s, %s, %s)", 
                    (customer_id, room_ID, checkIn, checkOut))
        mysql.connection.commit()
        cur.close()
        return redirect('/reservations')
    except Exception as e:
        print(f"Error occurred: {e}")
        mysql.connection.rollback()
        return "Error in adding reservation", 400



@app.route('/rooms')
def rooms():
    try:
        cur = mysql.connection.cursor()
        cur.execute('SELECT * FROM Rooms;')
        rooms_data = cur.fetchall()
        cur.close()
        return render_template('rooms.html', rooms=rooms_data)
    except Exception as e:
        print("Error occurred:", e)
        return str(e)  # For debugging

# Route to add a new room
# Route to add a new room
@app.route('/add-room', methods=['POST'])
def add_room():
    try:
        room_type = request.form['type']
        price_per_night = request.form['price_per_night']
        
        cur = mysql.connection.cursor()
        cur.execute('INSERT INTO Rooms (Room_type, Prices_per_night) VALUES (%s, %s)', (room_type, price_per_night))
        mysql.connection.commit()
        cur.close()
        return redirect('/rooms')  # Redirecting back to the rooms listing page
    except Exception as e:
        print("Error occurred:", e)
        mysql.connection.rollback()
        return "Error adding room", 400

# Route to delete a room
@app.route('/delete-room/<int:room_id>', methods=['POST'])
def delete_room(room_id):
    try:
        cur = mysql.connection.cursor()
        cur.execute('DELETE FROM Rooms WHERE room_ID = %s', [room_id])  # Make sure this matches your schema
        mysql.connection.commit()
        cur.close()
        return redirect('/rooms')  # Redirecting back to the rooms listing page
    except Exception as e:
        print("Error occurred:", e)
        return "Error deleting room", 400




# Route for Activities
@app.route('/activities')
def activities():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM Resort_Activities;')
    activities_data = cur.fetchall()
    cur.close()
    return render_template('activities.html', activities=activities_data)

# Add routes for other entities as needed
@app.route('/add_activity', methods=['POST'])
def add_activity():
    # Retrieve form data
    name = request.form['Name']
    description = request.form['Description']
    location = request.form['Location']
    availability = 'Availability' in request.form
    price = request.form['price']

    # Insert form data into the database
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO Resort_Activities (Name, Description, Location, Availability, price) VALUES (%s, %s, %s, %s, %s)',
                (name, description, location, availability, price))
    mysql.connection.commit()
    cur.close()

    # Redirect back to the activities page
    return redirect('/activities')

@app.route('/delete_activity/<int:activity_id>', methods=['POST'])
def delete_activity(activity_id):
    try:
        cur = mysql.connection.cursor()
        cur.execute('DELETE FROM Resort_Activities WHERE activity_ID = %s', [activity_id])
        mysql.connection.commit()
        cur.close()
        # Optional: Flash a message to the user about successful deletion
        # flash('Activity deleted successfully.')
    except Exception as e:
        # Handle your exception here
        print(e)
        mysql.connection.rollback()
        # Optional: Flash a message to the user about the error
        # flash('Error deleting activity.')
    return redirect('/activities')

# Listener
if __name__ == '__main__':
    app.run(debug=True, port=5001)  # Running on port 5001 for example
