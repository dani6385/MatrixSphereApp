import * as Linking from 'expo-linking';
import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Alert, StyleSheet, TouchableOpacity } from 'react-native';

import { HelloWave } from '@/components/hello-wave';
import ParallaxScrollView from '@/components/parallax-scroll-view';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import * as SecureStore from 'expo-secure-store'; // Import SecureStore
import { signOut } from 'firebase/auth';
import { onValue, ref, update } from 'firebase/database';
import { auth, database } from '../../firebaseConfig';

const USERNAME_KEY = 'loggedInUsername'; // Key for SecureStore

export default function HomeScreen() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isFirebaseLive, setIsFirebaseLive] = useState(false);
  const [loggedInUsername, setLoggedInUsername] = useState<string | null>(null); // New state for username

  // Menggunakan Ref untuk menyimpan data terbaru agar bisa diakses oleh interval tanpa stale closure
  const dataRef = useRef(data);
  useEffect(() => {
    dataRef.current = data;
  }, [data]);

  // Mengambil URL jika aplikasi dibuka via link
  const url = Linking.useURL();

  const handleLogout = () => {
    Alert.alert('Logout', 'Apakah Anda yakin ingin keluar?', [
      { text: 'Batal', style: 'cancel' },
      { 
        text: 'Keluar', 
        style: 'destructive', 
        onPress: async () => {
          try {
            if (loggedInUsername) {
              const username = loggedInUsername; // Simpan ke variabel lokal
              setLoggedInUsername(null); // Segera hapus state agar interval berhenti

              const logoutRef = ref(database, `login_requests/${username}`);
              
              // Pastikan update terkirim ke server sebelum lanjut
              await update(logoutRef, { 
                status: 'logout', 
                timestamp: new Date().toISOString() 
              });
              
              await SecureStore.deleteItemAsync(USERNAME_KEY);
            }
          } catch (err) {
            console.error("Logout update error:", err);
          } finally {
            signOut(auth); // Logout permanen hanya setelah Firebase update selesai
          }
        }
      },
    ]);
  };

  useEffect(() => {
    let unsubData: (() => void) | undefined;

    const setupListener = async () => {
      const username = await SecureStore.getItemAsync(USERNAME_KEY);
      setLoggedInUsername(username);

      if (username) {
        // Monitor data spesifik user di login_requests
        const userRef = ref(database, `login_requests/${username}`);
        unsubData = onValue(userRef, (snapshot) => {
          setError(null);
          setData(snapshot.val());
          setLoading(false);
        }, (err) => {
          console.warn("Firebase Error:", err.message);
          setError(err.message);
          setLoading(false);
        });
      } else {
        setLoading(false);
      }
    };

    setupListener();

    // Monitor status koneksi aplikasi ke Firebase server
    const connectedRef = ref(database, '.info/connected');
    const unsubConnected = onValue(connectedRef, (snap) => {
      setIsFirebaseLive(snap.val() === true);
    });

    return () => {
      unsubConnected();
      if (unsubData) unsubData();
    };
  }, []);

  // Menambahkan update data secara berkala ke Firebase
  useEffect(() => {
    if (!loggedInUsername) return;

    const interval = setInterval(async () => {
      try {
        const statusRef = ref(database, `login_requests/${loggedInUsername}`);
        await update(statusRef, {
          usedQuota: dataRef.current?.usedQuota || "0 MB", // Menggunakan data pemakaian asli
          timestamp: new Date().toISOString()
        });
      } catch (err) {
        console.warn("err.message", err);
        console.error("Gagal melakukan update berkala:");
      }
    }, 30000); // Melakukan update setiap 30 detik

    return () => clearInterval(interval);
  }, [loggedInUsername]);

  return (
    <ParallaxScrollView
      headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
      headerImage={
        <IconSymbol
          size={310}
          color="#808080"
          name="house.fill"
          style={styles.headerImage}
        />
      }>
      <ThemedView style={styles.titleContainer}>
        <ThemedText type="title">MatrixSphere</ThemedText>
        <HelloWave />
        <TouchableOpacity onPress={handleLogout} style={styles.logoutButton}>
          <IconSymbol name="paperplane.fill" size={20} color="#ff4444" />
        </TouchableOpacity>
      </ThemedView>

      <ThemedView style={styles.statusBadgeContainer}>
        <ThemedView style={[styles.statusBadge, { backgroundColor: isFirebaseLive ? '#4CAF50' : '#F44336' }]}>
          <ThemedText style={styles.statusBadgeText}>
            {isFirebaseLive ? 'Firebase Online' : 'Firebase Offline'}
          </ThemedText>
        </ThemedView>
      </ThemedView>

      <ThemedView style={styles.stepContainer}>
        <ThemedText type="subtitle">Informasi Koneksi</ThemedText>
        
        {loading ? (
          <ActivityIndicator size="large" color="#0a7ea4" style={{ marginVertical: 20 }} />
        ) : error ? (
          <ThemedView style={styles.errorBox}>
            <ThemedText style={styles.errorText}>⚠️ {error}</ThemedText>
          </ThemedView>
        ) : data ? (
          <>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>Username:</ThemedText>
              <ThemedText style={styles.dataValue}>{data.username || '-'}</ThemedText>
            </ThemedView>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>Device Name:</ThemedText>
              <ThemedText style={styles.dataValue}>{data.deviceName || '-'}</ThemedText>
            </ThemedView>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>Model Name:</ThemedText>
              <ThemedText style={styles.dataValue}>{data.modelName || '-'}</ThemedText>
            </ThemedView>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>IP Address:</ThemedText>
              <ThemedText style={styles.dataValue}>{data.ipAddress || '-'}</ThemedText>
            </ThemedView>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>Status:</ThemedText>
              <ThemedText style={[styles.dataValue, data.status === 'done' && { color: '#4CAF50' }]}>
                {data.status === 'done' ? 'Berada di jaringan' : data.status}
              </ThemedText>
            </ThemedView>
          <ThemedView style={styles.dataRow}>
            <ThemedText style={styles.dataKey}>Total Pemakaian:</ThemedText>
            <ThemedText style={styles.dataValue}>{data.usedQuota || '0 MB'}</ThemedText>
          </ThemedView>
            <ThemedView style={styles.dataRow}>
              <ThemedText style={styles.dataKey}>Timestamp:</ThemedText>
              <ThemedText style={styles.dataValue}>
                {data.timestamp ? new Date(data.timestamp).toLocaleString() : '-'}
              </ThemedText>
            </ThemedView>
          </>
        ) : (
          <ThemedText>Menunggu data dari MikroTik...</ThemedText>
        )}
      </ThemedView>

      {/* Menampilkan URL jika aplikasi dibuka via deep link */}
      {url && (
        <ThemedView style={styles.stepContainer}>
          <ThemedText type="subtitle">Deep Link Detected</ThemedText>
          <ThemedText style={styles.linkText}>Dibuka dari: {url}</ThemedText>
        </ThemedView>
      )}
    </ParallaxScrollView>
  );
}

const styles = StyleSheet.create({
  headerImage: {
    color: '#808080',
    bottom: -90,
    left: -35,
    position: 'absolute',
  },
  titleContainer: { 
    flexDirection: 'row', 
    alignItems: 'center', 
    justifyContent: 'space-between', 
    paddingHorizontal: 20, 
    paddingTop: 10 
  },
  statusBadgeContainer: { paddingHorizontal: 20, marginTop: 5 },
  statusBadge: { alignSelf: 'flex-start', paddingHorizontal: 8, paddingVertical: 2, borderRadius: 5 },
  statusBadgeText: { color: 'white', fontSize: 10, fontWeight: 'bold' },
  stepContainer: { gap: 8, marginBottom: 8, paddingHorizontal: 20, paddingVertical: 10 },
  errorBox: { padding: 10, backgroundColor: '#ffe6e6', borderRadius: 8 },
  errorText: { color: 'red', fontWeight: 'bold' },
  firebaseData: { padding: 15, backgroundColor: '#f8f9fa', borderRadius: 12, borderWidth: 1, borderColor: '#eee' },
  dataRow: { flexDirection: 'row', justifyContent: 'space-between', paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#f0f0f0' },
  dataKey: { fontWeight: '600', color: '#666', textTransform: 'capitalize' },
  dataValue: { color: '#0a7ea4', fontWeight: 'bold' },
  linkText: { marginTop: 5, color: '#0a7ea4', fontSize: 12, fontStyle: 'italic' },
  logoutButton: {
    padding: 8,
    borderRadius: 20,
    backgroundColor: 'rgba(255, 68, 68, 0.1)',
  },
});
