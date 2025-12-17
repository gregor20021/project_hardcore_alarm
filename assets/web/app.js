const API_BASE_URL = window.location.origin + '/api';
const DEFAULT_SOUND_PATH = 'assets/alarm.mp3';

const AppState = {
    alarms: [],
    clients: [],
    currentView: 'list',
    editingAlarm: null,
    loading: false
};

async function fetchAlarms() {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms`);
        const data = await response.json();
        if (data.success) {
            AppState.alarms = data.alarms || [];
            return true;
        }
        return false;
    } catch (error) {
        console.error('Error fetching alarms:', error);
        return false;
    }
}

async function createAlarm(alarmData) {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ alarm: alarmData })
        });
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error creating alarm:', error);
        return { success: false, error: error.message };
    }
}

async function updateAlarm(id, alarmData) {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ alarm: alarmData })
        });
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error updating alarm:', error);
        return { success: false, error: error.message };
    }
}

async function deleteAlarm(id) {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms/${id}`, {
            method: 'DELETE'
        });
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error deleting alarm:', error);
        return { success: false, error: error.message };
    }
}

async function dismissAlarm(id, qrCode) {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms/${id}/dismiss`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ qrCode })
        });
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error dismissing alarm:', error);
        return { success: false, error: error.message };
    }
}

async function snoozeAlarm(id, qrCode) {
    try {
        const response = await fetch(`${API_BASE_URL}/alarms/${id}/snooze`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ qrCode })
        });
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error snoozing alarm:', error);
        return { success: false, error: error.message };
    }
}

async function fetchClients() {
    try {
        const response = await fetch(`${API_BASE_URL}/dismiss-clients`);
        const data = await response.json();
        AppState.clients = data.clients || [];
        return true;
    } catch (error) {
        console.error('Error fetching clients:', error);
        return false;
    }
}

function renderAlarmList() {
    const container = document.getElementById('alarms-container');
    const emptyState = document.getElementById('empty-state');

    if (!AppState.alarms || AppState.alarms.length === 0) {
        container.innerHTML = '';
        emptyState.style.display = 'block';
        return;
    }

    emptyState.style.display = 'none';
    container.innerHTML = AppState.alarms.map(alarm => renderAlarmCard(alarm)).join('');
}

function renderAlarmCard(alarm) {
    const hour = String(alarm.schedule.hour).padStart(2, '0');
    const minute = String(alarm.schedule.minute).padStart(2, '0');
    const time = `${hour}:${minute}`;

    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    const dayBadges = days.map((day, index) => {
        const isActive = alarm.schedule[day];
        return `<div class="day-badge ${isActive ? 'active' : ''}">${dayLabels[index]}</div>`;
    }).join('');

    return `
        <div class="alarm-card ${alarm.active ? '' : 'inactive'}" onclick="showAlarmActionsModal(${alarm.id})">
            <div class="alarm-content">
                <div class="alarm-time">${time}</div>
                <div class="alarm-title">${alarm.title || 'Untitled'}</div>
                <div class="alarm-description">${alarm.description || ''}</div>
                <div class="alarm-days">${dayBadges}</div>
            </div>
            <div class="alarm-actions" onclick="event.stopPropagation()">
                <button class="icon-btn" onclick="onEditClick(${alarm.id})" title="Edit">
                    <span>✏️</span>
                </button>
                <button class="icon-btn danger" onclick="onDeleteAlarm(${alarm.id})" title="Delete">
                    <span>🗑️</span>
                </button>
            </div>
        </div>
    `;
}

function showAlarmActionsModal(alarmId) {
    const alarm = AppState.alarms.find(a => a.id === alarmId);
    if (!alarm) return;

    const modal = document.getElementById('alarm-actions-modal');
    const hour = String(alarm.schedule.hour).padStart(2, '0');
    const minute = String(alarm.schedule.minute).padStart(2, '0');

    document.getElementById('modal-alarm-title').textContent = alarm.title || 'Untitled';
    document.getElementById('modal-alarm-time').textContent = `${hour}:${minute}`;

    document.getElementById('modal-dismiss-btn').onclick = () => {
        closeAlarmActionsModal();
        onDismissClick(alarmId);
    };

    document.getElementById('modal-snooze-btn').onclick = () => {
        closeAlarmActionsModal();
        onSnoozeClick(alarmId);
    };

    modal.style.display = 'flex';
}

function closeAlarmActionsModal() {
    document.getElementById('alarm-actions-modal').style.display = 'none';
}

function showAlarmForm(alarmId = null) {
    AppState.editingAlarm = alarmId;
    document.getElementById('alarm-list-view').style.display = 'none';
    document.getElementById('alarm-form-view').style.display = 'block';

    const formTitle = document.getElementById('form-title');
    formTitle.textContent = alarmId ? 'Edit Alarm' : 'Create Alarm';

    initializeTimePickers();

    if (alarmId) {
        const alarm = AppState.alarms.find(a => a.id === alarmId);
        if (alarm) {
            populateFormFromAlarm(alarm);
        }
    } else {
        resetForm();
    }
}

function initializeTimePickers() {
    const hourSelect = document.getElementById('alarm-hour');
    const minuteSelect = document.getElementById('alarm-minute');

    if (hourSelect.options.length === 0) {
        for (let i = 0; i < 24; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = String(i).padStart(2, '0');
            hourSelect.appendChild(option);
        }
    }

    if (minuteSelect.options.length === 0) {
        for (let i = 0; i < 60; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = String(i).padStart(2, '0');
            minuteSelect.appendChild(option);
        }
    }
}

function populateFormFromAlarm(alarm) {
    document.getElementById('alarm-title').value = alarm.title || '';
    document.getElementById('alarm-description').value = alarm.description || '';
    document.getElementById('alarm-hour').value = alarm.schedule.hour;
    document.getElementById('alarm-minute').value = alarm.schedule.minute;
    document.getElementById('alarm-volume').value = alarm.volume;
    document.getElementById('volume-value').textContent = alarm.volume;
    document.getElementById('alarm-repeat').checked = alarm.schedule.repeat;
    document.getElementById('alarm-vibrate').checked = alarm.snoozeOptions.vibrate;
    document.getElementById('alarm-active').checked = alarm.active;

    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    days.forEach(day => {
        document.getElementById(`day-${day}`).checked = alarm.schedule[day];
    });

    document.getElementById('snooze-minutes').value = alarm.snoozeOptions.minutes;
    updateSnoozeMinutesDisplay(alarm.snoozeOptions.minutes);

    document.getElementById('snooze-repeat').value = alarm.snoozeOptions.repeat;
    updateSnoozeRepeatDisplay(alarm.snoozeOptions.repeat);

    document.getElementById('snooze-decrease').value = alarm.snoozeOptions.decreaseMinutesPerSnooze;
    updateSnoozeDecreaseDisplay(alarm.snoozeOptions.decreaseMinutesPerSnooze);
}

function resetForm() {
    document.getElementById('alarm-form').reset();
    document.getElementById('alarm-hour').value = new Date().getHours();
    document.getElementById('alarm-minute').value = 0;
    document.getElementById('alarm-volume').value = 80;
    document.getElementById('volume-value').textContent = '80';

    document.getElementById('snooze-minutes').value = 5;
    updateSnoozeMinutesDisplay(5);

    document.getElementById('snooze-repeat').value = 0;
    updateSnoozeRepeatDisplay(0);

    document.getElementById('snooze-decrease').value = 0;
    updateSnoozeDecreaseDisplay(0);
}

function getFormData() {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    const schedule = {
        hour: parseInt(document.getElementById('alarm-hour').value),
        minute: parseInt(document.getElementById('alarm-minute').value),
        repeat: document.getElementById('alarm-repeat').checked
    };

    days.forEach(day => {
        schedule[day] = document.getElementById(`day-${day}`).checked;
    });

    return {
        title: document.getElementById('alarm-title').value,
        description: document.getElementById('alarm-description').value,
        active: document.getElementById('alarm-active').checked,
        schedule: schedule,
        soundPath: DEFAULT_SOUND_PATH,
        volume: parseInt(document.getElementById('alarm-volume').value),
        snoozeOptions: {
            minutes: parseInt(document.getElementById('snooze-minutes').value),
            repeat: parseInt(document.getElementById('snooze-repeat').value),
            vibrate: document.getElementById('alarm-vibrate').checked,
            decreaseMinutesPerSnooze: parseInt(document.getElementById('snooze-decrease').value)
        }
    };
}

async function saveAlarm(event) {
    event.preventDefault();

    showLoading();

    const alarmData = getFormData();

    let result;
    if (AppState.editingAlarm) {
        alarmData.id = AppState.editingAlarm;
        result = await updateAlarm(AppState.editingAlarm, alarmData);
    } else {
        result = await createAlarm(alarmData);
    }

    hideLoading();

    if (result.success) {
        showToast(AppState.editingAlarm ? 'Alarm updated' : 'Alarm created', 'success');
        await refreshAlarms();
        cancelForm();
    } else {
        showToast(result.error || 'Failed to save alarm', 'error');
    }
}

async function onDeleteAlarm(id) {
    if (!confirm('Are you sure you want to delete this alarm?')) {
        return;
    }

    showLoading();
    const result = await deleteAlarm(id);
    hideLoading();

    if (result.success) {
        showToast('Alarm deleted', 'success');
        await refreshAlarms();
    } else {
        showToast(result.error || 'Failed to delete alarm', 'error');
    }
}

async function onEditClick(id) {
    showAlarmForm(id);
}

function cancelForm() {
    document.getElementById('alarm-form-view').style.display = 'none';
    document.getElementById('alarm-list-view').style.display = 'block';
    AppState.editingAlarm = null;
}

async function refreshAlarms() {
    showLoading();
    await fetchAlarms();
    renderAlarmList();
    hideLoading();
}

function showLoading() {
    document.getElementById('loading-overlay').style.display = 'flex';
}

function hideLoading() {
    document.getElementById('loading-overlay').style.display = 'none';
}

function showToast(message, type = 'info') {
    const container = document.getElementById('toast-container');
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.textContent = message;
    container.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
}

function updateVolumeDisplay(value) {
    document.getElementById('volume-value').textContent = value;
}

function updateSnoozeMinutesDisplay(value) {
    const minutes = parseInt(value);
    document.getElementById('snooze-minutes-value').textContent = `for ${minutes} minutes`;

    // Clamp decrease if it's greater than snooze minutes
    const decreaseSlider = document.getElementById('snooze-decrease');
    const currentDecrease = parseInt(decreaseSlider.value);

    // Update max and step for decrease slider
    decreaseSlider.max = minutes;

    // If current decrease is greater than new max, clamp it
    if (currentDecrease > minutes) {
        decreaseSlider.value = minutes;
        updateSnoozeDecreaseDisplay(minutes);
    }
}

function updateSnoozeRepeatDisplay(value) {
    const repeat = parseInt(value);
    if (repeat === 0) {
        document.getElementById('snooze-repeat-value').textContent = 'unlimited times';
    } else {
        document.getElementById('snooze-repeat-value').textContent = `maximum ${repeat} times`;
    }
}

function updateSnoozeDecreaseDisplay(value) {
    const decrease = parseInt(value);
    if (decrease === 0) {
        document.getElementById('snooze-decrease-value').textContent = 'No decrease';
    } else {
        document.getElementById('snooze-decrease-value').textContent = `Decrease for ${decrease} minutes per snooze`;
    }
}

document.addEventListener('DOMContentLoaded', async () => {
    showLoading();
    await fetchClients();
    await fetchAlarms();
    renderAlarmList();
    hideLoading();
});
