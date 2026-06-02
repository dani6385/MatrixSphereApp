const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Fungsi ini akan berjalan otomatis setiap jam 00:00 (tengah malam)
exports.resetDailyTraffic = functions.pubsub
    .schedule("0 0 * * *")
    .timeZone("Asia/Jakarta")
    .onRun(async (context) => {
      const db = admin.database();
      const ref = db.ref("router_stats"); // Pastikan path ini sesuai dengan database Anda

      // 1. Ambil nilai total yang sekarang
      const snapshot = await ref.once("value");
      const totalRx = snapshot.val().total_rx_all_time;

      // 2. Simpan nilai ini sebagai titik awal baru (snapshot)
      return ref.update({
        "last_reset_snapshot/rx": totalRx,
        "last_reset_snapshot/date": new Date().toISOString().split("T")[0],
      });
    });
