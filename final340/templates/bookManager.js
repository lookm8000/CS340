let reservations = [];

document.addEventListener('DOMContentLoaded', function() {
    loadReservations();
    populateReservationsTable();

    document.getElementById('bookingForm').addEventListener('submit', function(event) {
        event.preventDefault();
        addReservation();
    });

    document.getElementById('reservationsTable').addEventListener('click', function(event) {
        if (event.target.classList.contains('delete-btn')) {
            const index = event.target.getAttribute('data-index');
            deleteReservation(index);
        }
    });
});

function loadReservations() {
    const storedReservations = localStorage.getItem('reservations');
    reservations = storedReservations ? JSON.parse(storedReservations) : [];
}

function saveReservations() {
    localStorage.setItem('reservations', JSON.stringify(reservations));
}

function populateReservationsTable() {
    const tableBody = document.getElementById('reservationsTable').querySelector('tbody');
    tableBody.innerHTML = '';
    reservations.forEach((reservation, index) => {
        const row = `<tr>
            <td>${reservation.name}</td>
            <td>${reservation.contact}</td>
            <td>${reservation.roomType}</td>
            <td>${reservation.roomNumber}</td>
            <td>${reservation.duration}</td>
            <td><button class="delete-btn" data-index="${index}">Delete</button></td>
        </tr>`;
        tableBody.insertAdjacentHTML('beforeend', row);
    });
}

function addReservation() {
    const guestName = document.getElementById('guestName').value.trim();
    const contactNumber = document.getElementById('contactNumber').value.trim();
    const roomType = document.getElementById('roomType').value;
    const checkInDate = document.getElementById('checkIn').value;
    const checkOutDate = document.getElementById('checkOut').value;
    
    const roomNumber = Math.floor(Math.random() * 100) + 101; // Simple random room number assignment
    const duration = Math.round((new Date(checkOutDate) - new Date(checkInDate)) / (1000 * 60 * 60 * 24)); // Calculate duration in days

    // Log the reservations array before adding a new reservation
    console.log("Before adding reservation:", reservations);
    
    reservations.push({ name: guestName, contact: contactNumber, roomType, roomNumber, duration });

    // Log the reservations array after adding the new reservation
    console.log("After adding reservation:", reservations);

    saveReservations();
    populateReservationsTable();
    document.getElementById('bookingForm').reset();
    displayFeedback('Booking successful!');
}

function deleteReservation(index) {
    reservations.splice(index, 1);
    saveReservations();
    populateReservationsTable();
}

function displayFeedback(message) {
    const feedback = document.getElementById('feedback');
    feedback.textContent = message;
    feedback.style.display = 'block';
    setTimeout(() => feedback.style.display = 'none', 3000);
}
