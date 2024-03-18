let activities = [
    {activity: 'Water Skiing', times: '08:00 - 10:00', instructor: 'Maile Look', price: '$50'},
    {activity: 'Hiking', times: '10:00 - 12:00', instructor: 'Reese Morgan', price: '$30'},
    {activity: 'Climbing', times: '12:00 - 14:00', instructor: 'Keoe Hoe', price: '$45'},
    {activity: 'Kayaking', times: '14:00 - 16:00', instructor: 'Cade Buchanan', price: '$40'},
    {activity: 'Mountain Biking', times: '16:00 - 18:00', instructor: 'Isabel Li', price: '$55'},
    {activity: 'Paragliding', times: '18:00 - 20:00', instructor: 'Macy Hill', price: '$65'}
];

document.addEventListener('DOMContentLoaded', function() {
    loadActivities();
    populateTable();

    document.getElementById('addActivityForm').addEventListener('submit', function(event) {
        event.preventDefault();
        addNewActivity();
    });
});

function loadActivities() {
    const storedActivities = localStorage.getItem('activities');
    if (storedActivities) {
        activities = JSON.parse(storedActivities);
    }
    // No need to re-initialize the activities array here since it's already populated by default
}

function saveActivities() {
    localStorage.setItem('activities', JSON.stringify(activities));
}

function populateTable() {
    const tableBody = document.getElementById('activitiesTable');
    tableBody.innerHTML = ''; // Clear the table body

    activities.forEach((activity, index) => {
        let row = tableBody.insertRow();
        
        let nameCell = row.insertCell(0);
        nameCell.textContent = activity.activity;

        let timesCell = row.insertCell(1);
        timesCell.textContent = activity.times;

        let instructorCell = row.insertCell(2);
        instructorCell.textContent = activity.instructor;

        let priceCell = row.insertCell(3);
        priceCell.textContent = activity.price;

        let actionCell = row.insertCell(4);
        actionCell.innerHTML = `<span class="action-button" onclick="editActivity(${index})">Edit</span> | <span class="action-button" onclick="deleteActivity(${index})">Delete</span>`;
    });
}

function addNewActivity() {
    const newActivity = {
        activity: document.getElementById('newActivityName').value.trim(),
        times: document.getElementById('newActivityTimes').value.trim(),
        instructor: document.getElementById('newActivityInstructor').value.trim(),
        price: document.getElementById('newActivityPrice').value.trim(),
    };

    activities.push(newActivity);
    saveActivities();
    populateTable();
    document.getElementById('addActivityForm').reset();
}

function editActivity(index) {
    // Populate form with activity data for editing
    const activity = activities[index];
    document.getElementById('newActivityName').value = activity.activity;
    document.getElementById('newActivityTimes').value = activity.times;
    document.getElementById('newActivityInstructor').value = activity.instructor;
    document.getElementById('newActivityPrice').value = activity.price;

    // Temporarily remove activity for re-addition
    deleteActivity(index, false);
}

function deleteActivity(index, save = true) {
    activities.splice(index, 1);
    if (save) {
        saveActivities();
    }
    populateTable();
}
