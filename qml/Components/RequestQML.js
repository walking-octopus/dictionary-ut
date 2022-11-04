function request(url) {
    console.log(url)

    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        var timer = Qt.createQmlObject("import QtQuick 2.9; Timer {interval: 4000; repeat: false; running: true;}", root, "TimeoutTimer");
        
        timer.triggered.connect(function() {
            xhr.abort();
            xhr.response = "Timed out";
            reject("Timed out");
        });

        xhr.open("GET", url, true);
        xhr.onload = () => {
            if (xhr.status >= 200 && xhr.status <= 500) {
                resolve(xhr.response);
            } else {
                reject(xhr.status);
            }
            timer.running = false;
        };

        xhr.onerror = () => reject(xhr.response);
        xhr.send();
    });
}
