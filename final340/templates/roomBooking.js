const roomData = {
    standard: [],
    premium: [],
    deluxe: []
};

document.addEventListener('DOMContentLoaded', function() {
    loadRoomData();
    populateRoomOptions();
    addInitialBookedRooms();
});

function loadRoomData() {
    // Attempt to load room data from localStorage
    const storedData = localStorage.getItem('roomBookings');
    if (storedData) {
        const bookings = JSON.parse(storedData);
        Object.keys(bookings).forEach(type => {
            roomData[type] = bookings[type];
        });
    }
}

function saveRoomData() {
    localStorage.setItem('roomBookings', JSON.stringify(roomData));
}

function populateRoomOptions() {
    populateOptions("standardRoomSelect", "Standard", 6, roomData.standard);
    populateOptions("premiumRoomSelect", "Premium", 7, roomData.premium);
    populateOptions("deluxeRoomSelect", "Deluxe", 8, roomData.deluxe);
}

function populateOptions(selectId, roomType, floors, bookedRooms) {
    const select = document.getElementById(selectId);
    for (let floor = 1; floor <= floors; floor++) {
        for (let room = 1; room <= 10; room++) {
            const optionText = `${roomType} - Floor ${floor}, Room ${room}`;
            if (!bookedRooms.includes(optionText)) {
                addOption(select, optionText);
            }
        }
    }
}

function addOption(select, text) {
    const option = document.createElement("option");
    option.text = text;
    select.appendChild(option);
}

function bookRoom(roomType) {
    const select = document.getElementById(`${roomType}RoomSelect`);
    const selectedRoom = select.value;
    if (!selectedRoom) {
        alert("Please select a room to book.");
        return;
    }

    roomData[roomType].push(selectedRoom);
    saveRoomData();
    
    addBookedRoom(roomType, selectedRoom, "Booked");
    select.remove(select.selectedIndex);
}

function addBookedRoom(roomType, room, status) {
    const bookedTable = document.getElementById("bookedRooms");
    const row = bookedTable.insertRow();
    const cell1 = row.insertCell(0);
    const cell2 = row.insertCell(1);
    const cell3 = row.insertCell(2);
    cell1.textContent = roomType.charAt(0).toUpperCase() + roomType.slice(1) + " Suite";
    cell2.textContent = room;
    cell3.textContent = status;
}

function addInitialBookedRooms() {
    Object.keys(roomData).forEach(type => {
        roomData[type].forEach(roomText => {
            addBookedRoom(type, roomText, "Booked");
        });
    });
}
