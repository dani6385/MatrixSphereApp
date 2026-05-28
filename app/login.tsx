import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { CameraView, useCameraPermissions } from 'expo-camera';
import * as Device from 'expo-device';
import * as Network from 'expo-network';
import { Stack, useRouter } from 'expo-router';
import * as SecureStore from 'expo-secure-store'; // Import SecureStore
import { signInAnonymously } from 'firebase/auth';
import { get, ref, runTransaction, set } from 'firebase/database';
import React, { useState } from 'react';
import { ActivityIndicator, Alert, Modal, StyleSheet, TextInput, TouchableOpacity, View } from 'react-native';
import { auth, database } from '../firebaseConfig';


export default function LoginScreen() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [voucherCode, setVoucherCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [loginMethod, setLoginMethod] = useState<'member' | 'voucher'>('member');
  const [isScanning, setIsScanning] = useState(false);
  const [permission, requestPermission] = useCameraPermissions();

  const USERNAME_KEY = 'loggedInUsername'; // Key for SecureStore
  const router = useRouter();

  const handleLogin = async () => {
    if (!username || !password) return Alert.alert('Error', 'Isi username dan password');
    setLoading(true);
    try {
      await signInAnonymously(auth);

      const membersRef = ref(database, 'members');
      const snapshot = await get(membersRef);

      if (snapshot.exists()) {
        const members = snapshot.val();
        const matchedMember = Object.values(members).find(
          (m: any) => m.username === username && m.password === password
        );

        if (matchedMember) {
          // Mengambil IP secara otomatis
          const ip = await Network.getIpAddressAsync();

          console.log("Sinyal aktivasi dikirim untuk IP:", ip);
          
          // Kirim ke login_requests untuk dibaca MikroTik
          const activationRef = ref(database, `login_requests/${username}`);
          await set(activationRef, {
            username: username,
            deviceName: Device.deviceName || 'Unknown Device',
            modelName: Device.modelName,
            osVersion: Device.osVersion,
            ipAddress: ip,                       // MikroTik akan menggunakan IP ini untuk mencari MAC
            status: 'pending',
            timestamp: new Date().toISOString(),
          });

          await SecureStore.setItemAsync(USERNAME_KEY, username); // Save username
          router.replace('/status' as any);
        } else {
          Alert.alert('Gagal Login', 'Username atau Password salah.');
        }
      } else {
        Alert.alert('Gagal Login', 'Database member masih kosong.');
      }
    } catch (error: any) {
      Alert.alert('Error Database', error.message || 'Pastikan internet aktif dan Anonymous Auth di-enable di Firebase.');
    } finally {
      setLoading(false);
    }
  };

  const handleVoucherLogin = async () => {
    if (!voucherCode) return Alert.alert('Error', 'Masukkan kode voucher');
    setLoading(true);
    try {
      const voucherRef = ref(database, `vouchers/${voucherCode}`);

      const result = await runTransaction(voucherRef, (currentData) => {
        if (currentData && currentData.status === 'available') {
          currentData.status = 'used';
          currentData.usedAt = new Date().toISOString();
          return currentData;
        }
        return;
      });

      if (result.committed) {
        await signInAnonymously(auth);
        
        // Kirim request aktivasi untuk voucher juga agar diproses MikroTik
        const ip = await Network.getIpAddressAsync();
        await set(ref(database, `login_requests/${voucherCode}`), {
          username: voucherCode,
          type: 'voucher',
          ipAddress: ip,
          status: 'pending',
          timestamp: new Date().toISOString(),
        });

        await SecureStore.setItemAsync(USERNAME_KEY, voucherCode); 
        router.replace('/status' as any);
      } else {
        Alert.alert('Gagal', 'Kode voucher tidak valid atau sudah digunakan.');
      }
    } catch (error: any) {
      Alert.alert('Error Voucher', error.message || 'Terjadi kesalahan.');
    } finally {
      setLoading(false);
    }
  };

  const handleOpenScanner = async () => {
    if (!permission?.granted) {
      const res = await requestPermission();
      if (!res.granted) {
        Alert.alert('Izin Kamera', 'Aplikasi membutuhkan izin kamera.');
        return;
      }
    }
    setIsScanning(true);
  };

  const handleBarCodeScanned = ({ data }: { data: string }) => {
    setIsScanning(false);
    setVoucherCode(data);
    Alert.alert('QR Terdeteksi', `Gunakan kode: ${data}?`, [
      { text: 'Batal', style: 'cancel' },
      { text: 'Gunakan', onPress: () => setVoucherCode(data) }
    ]);
  };

  return (
    <ThemedView style={styles.container}>
      <Stack.Screen options={{ title: 'Login MatrixSphere', headerShown: false }} />

      <Modal visible={isScanning} animationType="slide">
        <View style={styles.cameraContainer}>
          <CameraView style={styles.camera} onBarcodeScanned={handleBarCodeScanned} barcodeScannerSettings={{ barcodeTypes: ['qr'] }} />
          <TouchableOpacity style={styles.closeScanner} onPress={() => setIsScanning(false)}>
            <ThemedText style={styles.buttonText}>Tutup Kamera</ThemedText>
          </TouchableOpacity>
        </View>
      </Modal>

      <ThemedText type="title" style={styles.title}>MatrixSphere</ThemedText>
      <ThemedText style={styles.subtitle}>Akses Monitoring MikroTik</ThemedText>

      <View style={styles.tabContainer}>
        <TouchableOpacity style={[styles.tab, loginMethod === 'member' && styles.activeTab]} onPress={() => setLoginMethod('member')}>
          <ThemedText style={[styles.tabText, loginMethod === 'member' && styles.activeTabText]}>Member</ThemedText>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.tab, loginMethod === 'voucher' && styles.activeTab]} onPress={() => setLoginMethod('voucher')}>
          <ThemedText style={[styles.tabText, loginMethod === 'voucher' && styles.activeTabText]}>Voucher</ThemedText>
        </TouchableOpacity>
      </View>

      {loginMethod === 'member' ? (
        <>
          <TextInput style={styles.input} placeholder="Username Member" placeholderTextColor="#999" value={username} onChangeText={setUsername} autoCapitalize="none" />
          <TextInput style={styles.input} placeholder="Password" placeholderTextColor="#999" value={password} onChangeText={setPassword} secureTextEntry />
          <TouchableOpacity style={styles.button} onPress={handleLogin} disabled={loading}>
            <ThemedText style={styles.buttonText}>Login Member</ThemedText>
          </TouchableOpacity>
        </>
      ) : (
        <>
          <TextInput style={styles.input} placeholder="Masukkan Kode Voucher" placeholderTextColor="#999" value={voucherCode} onChangeText={setVoucherCode} autoCapitalize="characters" />
          <TouchableOpacity style={[styles.button, { backgroundColor: '#4CAF50' }]} onPress={handleOpenScanner}>
            <ThemedText style={styles.buttonText}>Scan QR Voucher</ThemedText>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.button, { backgroundColor: '#FF9800' }]} onPress={handleVoucherLogin} disabled={loading}>
            <ThemedText style={styles.buttonText}>Aktivasi Voucher</ThemedText>
          </TouchableOpacity>
        </>
      )}

      {loading && <ActivityIndicator size="large" color="#0a7ea4" style={{ marginTop: 20 }} />}
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 25 },
  title: { textAlign: 'center', fontSize: 32, marginBottom: 5 },
  subtitle: { textAlign: 'center', marginBottom: 40, color: '#666' },
  tabContainer: { flexDirection: 'row', backgroundColor: '#f0f0f0', borderRadius: 12, padding: 5, marginBottom: 25 },
  tab: { flex: 1, paddingVertical: 10, alignItems: 'center', borderRadius: 10 },
  activeTab: { backgroundColor: '#fff', elevation: 2 },
  tabText: { color: '#888', fontWeight: '600' },
  activeTabText: { color: '#0a7ea4' },
  input: { backgroundColor: '#f0f0f0', padding: 15, borderRadius: 10, marginBottom: 15, fontSize: 16 },
  button: { backgroundColor: '#0a7ea4', padding: 15, borderRadius: 10, alignItems: 'center', marginBottom: 10 },
  buttonText: { color: 'white', fontWeight: 'bold', fontSize: 16 },
  cameraContainer: { flex: 1, backgroundColor: 'black' },
  camera: { flex: 1 },
  closeScanner: { position: 'absolute', bottom: 50, alignSelf: 'center', backgroundColor: '#ff4444', padding: 15, borderRadius: 10 },
});