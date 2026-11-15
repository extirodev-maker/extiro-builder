// 3D Calendar Application Logic

const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

let date = new Date();
let currYear = date.getFullYear();
let currMonth = date.getMonth();
let selectedDate = new Date();

// Local storage for events: key format 'YYYY-MM-DD'
let events = JSON.parse(localStorage.getItem('extiro_calendar_events')) || {
    [formatDateKey(new Date())]: ["Welcome to 3D Calendar!", "Explore events & UI"]
};

// DOM Elements
const monthYearDisplay = document.getElementById('month-year-display');
const daysGrid = document.getElementById('days-grid');
const prevBtn = document.getElementById('prev-btn');
const nextBtn = document.getElementById('next-btn');
const todayBtn = document.getElementById('today-btn');

const sidebarDay = document.getElementById('sidebar-day');
const sidebarWeekday = document.getElementById('sidebar-weekday');
const sidebarDateFull = document.getElementById('sidebar-date-full');
const eventsList = document.getElementById('events-list');
const eventInput = document.getElementById('event-input');
const addEventBtn = document.getElementById('add-event-btn');

function formatDateKey(d) {
    let y = d.getFullYear();
    let m = String(d.getMonth() + 1).padStart(2, '0');
    let day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
}

function renderCalendar() {
    let firstDayIndex = new Date(currYear, currMonth, 1).getDay();
    let lastDay = new Date(currYear, currMonth + 1, 0).getDate();
    let lastDayIndex = new Date(currYear, currMonth + 1, 0).getDay();
    let prevLastDay = new Date(currYear, currMonth, 0).getDate();

    monthYearDisplay.innerText = `${months[currMonth]} ${currYear}`;
    let daysHTML = "";

    // Previous month's trailing days
    for (let i = firstDayIndex; i > 0; i--) {
        let prevMonthDay = prevLastDay - i + 1;
        daysHTML += `<div class="day-tile inactive"><span class="day-number">${prevMonthDay}</span></div>`;
    }

    // Current month's days
    for (let i = 1; i <= lastDay; i++) {
        let isToday =
            i === new Date().getDate() &&
            currMonth === new Date().getMonth() &&
            currYear === new Date().getFullYear();

        let isSelected =
            i === selectedDate.getDate() &&
            currMonth === selectedDate.getMonth() &&
            currYear === selectedDate.getFullYear();

        let tileDateKey = `${currYear}-${String(currMonth + 1).padStart(2, '0')}-${String(i).padStart(2, '0')}`;
        let hasEvents = events[tileDateKey] && events[tileDateKey].length > 0;

        let classes = "day-tile";
        if (isToday) classes += " today";
        if (isSelected && !isToday) classes += " selected";

        let indicatorsHTML = "";
        if (hasEvents) {
            indicatorsHTML = `<div class="day-indicators">` + 
                events[tileDateKey].map(() => `<span class="indicator-dot"></span>`).join('') + 
                `</div>`;
        }

        daysHTML += `
            <div class="${classes}" data-day="${i}" data-month="${currMonth}" data-year="${currYear}">
                <span class="day-number">${i}</span>
                ${indicatorsHTML}
            </div>
        `;
    }

    // Next month's leading days
    let nextDays = 7 - ((firstDayIndex + lastDay) % 7);
    if (nextDays < 7) {
        for (let i = 1; i <= nextDays; i++) {
            daysHTML += `<div class="day-tile inactive"><span class="day-number">${i}</span></div>`;
        }
    }

    daysGrid.innerHTML = daysHTML;
    attachDayClickEvents();
    updateSidebar();
}

function attachDayClickEvents() {
    const tiles = daysGrid.querySelectorAll('.day-tile:not(.inactive)');
    tiles.forEach(tile => {
        tile.addEventListener('click', () => {
            let d = parseInt(tile.getAttribute('data-day'));
            let m = parseInt(tile.getAttribute('data-month'));
            let y = parseInt(tile.getAttribute('data-year'));
            selectedDate = new Date(y, m, d);
            renderCalendar();
        });
    });
}

function updateSidebar() {
    sidebarDay.innerText = selectedDate.getDate();
    sidebarWeekday.innerText = weekdays[selectedDate.getDay()];
    sidebarDateFull.innerText = `${months[selectedDate.getMonth()]} ${selectedDate.getDate()}, ${selectedDate.getFullYear()}`;

    let key = formatDateKey(selectedDate);
    let dayEvents = events[key] || [];

    if (dayEvents.length === 0) {
        eventsList.innerHTML = `<div class="event-item" style="border-left-color: var(--text-muted); color: var(--text-muted);">No events planned</div>`;
    } else {
        eventsList.innerHTML = dayEvents.map((evt, index) => `
            <div class="event-item">
                <span>${escapeHtml(evt)}</span>
                <i class="fa-solid fa-trash delete-event" onclick="deleteEvent('${key}', ${index})"></i>
            </div>
        `).join('');
    }
}

function addEvent() {
    let text = eventInput.value.trim();
    if (!text) return;

    let key = formatDateKey(selectedDate);
    if (!events[key]) {
        events[key] = [];
    }
    events[key].push(text);
    localStorage.setItem('extiro_calendar_events', JSON.stringify(events));
    eventInput.value = "";
    renderCalendar();
}

window.deleteEvent = function(key, index) {
    if (events[key]) {
        events[key].splice(index, 1);
        if (events[key].length === 0) {
            delete events[key];
        }
        localStorage.setItem('extiro_calendar_events', JSON.stringify(events));
        renderCalendar();
    }
};

function escapeHtml(text) {
    let map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

// Event Listeners for Nav
prevBtn.addEventListener('click', () => {
    currMonth--;
    if (currMonth < 0) {
        currMonth = 11;
        currYear--;
    }
    renderCalendar();
});

nextBtn.addEventListener('click', () => {
    currMonth++;
    if (currMonth > 11) {
        currMonth = 0;
        currYear++;
    }
    renderCalendar();
});

todayBtn.addEventListener('click', () => {
    date = new Date();
    currYear = date.getFullYear();
    currMonth = date.getMonth();
    selectedDate = new Date();
    renderCalendar();
});

addEventBtn.addEventListener('click', addEvent);
eventInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') addEvent();
});

// Initial Render
renderCalendar();
