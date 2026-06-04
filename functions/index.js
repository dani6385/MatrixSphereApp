const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-functions/firebase-admin"); // Jika Anda butuh akses Firestore/Database

// Inisialisasi admin SDK jika belum ada
admin.initializeApp();

exports.resetDailyTraffic = onSchedule({
    schedule: "0 0 * * *", 
    timeZone: "Asia/Jakarta"
}, async (event) => {
    console.log("Menjalankan tugas reset trafik harian...");
    
    // Tulis logika Anda di sini. 
    // Contoh untuk reset di Firestore:
    // await admin.firestore().collection('stats').doc('daily').set({ traffic: 0 });
    
    return null;
});