let qrScanner = null;
let scanCallback = null;

function showQrScanner(callback) {
    scanCallback = callback;
    const modal = document.getElementById('qr-modal');
    modal.style.display = 'flex';

    startQrScanner();
}

function closeQrScanner() {
    stopQrScanner();
    const modal = document.getElementById('qr-modal');
    modal.style.display = 'none';
    scanCallback = null;
}

async function startQrScanner() {
    if (qrScanner) {
        await stopQrScanner();
    }

    const config = {
        fps: 10,
        qrbox: { width: 250, height: 250 },
        aspectRatio: 1.0
    };

    try {
        qrScanner = new Html5Qrcode("qr-reader");

        await qrScanner.start(
            { facingMode: "environment" },
            config,
            onScanSuccess,
            onScanError
        );
    } catch (err) {
        console.error('Error starting QR scanner:', err);
        showToast('Camera access denied or not available', 'error');
        closeQrScanner();
    }
}

async function stopQrScanner() {
    if (qrScanner) {
        const scanner = qrScanner;
        qrScanner = null;

        try {
            await scanner.stop();
        } catch (err) {
            console.error('Error stopping QR scanner:', err);
        }

        try {
            scanner.clear();
        } catch (err) {
            console.error('Error clearing QR scanner:', err);
        }
    }
}

function onScanSuccess(decodedText, decodedResult) {
    if (scanCallback) {
        const callback = scanCallback;
        stopQrScanner();
        closeQrScanner();
        callback(decodedText);
    }
}

function onScanError(error) {

}

async function onDismissClick(alarmId) {
    showQrScanner(async (qrCode) => {
        showLoading();
        const result = await dismissAlarm(alarmId, qrCode);
        hideLoading();

        if (result.success) {
            showToast('Alarm dismissed', 'success');
            await refreshAlarms();
        } else {
            showToast(result.error || 'Failed to dismiss alarm', 'error');
        }
    });
}

async function onSnoozeClick(alarmId) {
    const client = AppState.clients[0];

    if (client && client.snoozeQrCode) {
        showQrScanner(async (qrCode) => {
            showLoading();
            const result = await snoozeAlarm(alarmId, qrCode);
            hideLoading();

            if (result.success) {
                showToast('Alarm snoozed', 'success');
                await refreshAlarms();
            } else {
                showToast(result.error || 'Failed to snooze alarm', 'error');
            }
        });
    } else {
        showLoading();
        const result = await snoozeAlarm(alarmId, null);
        hideLoading();

        if (result.success) {
            showToast('Alarm snoozed', 'success');
            await refreshAlarms();
        } else {
            showToast(result.error || 'Failed to snooze alarm', 'error');
        }
    }
}
