import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useRouter } from 'expo-router';
import * as SecureStore from 'expo-secure-store';
import { off, onValue, ref } from 'firebase/database';
import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, StyleSheet, TouchableOpacity, View } from 'react-native';
import { database } from '../firebaseConfig';

const USERNAME_KEY = 'loggedInUsername';

export default function StatusScreen() {
  const [message, setMessage] = useState('Menghubungkan ke MikroTik...');
  const [connectionStatus, setConnectionStatus] = useState<'connecting' | 'pending' | 'done'>('connecting');
  const router = useRouter();

  useEffect(() => {
    let statusRef: any;
    let timeout: any;

    const startListening = async () => {
      const username = await SecureStore.getItemAsync(USERNAME_KEY);
      if (!username) {
        router.replace('/login');
        return;
      }

      statusRef = ref(database, `login_requests/${username}`);
      
      // Timeout 30 detik jika MikroTik tidak merespon
      timeout = setTimeout(() => {
        off(statusRef);
        Alert.alert("Timeout", "MikroTik tidak merespon. Silakan periksa koneksi router atau coba login kembali.", [
          { text: "Kembali ke Login", onPress: () => router.replace('/login') }
        ]);
      }, 30000);

      onValue(statusRef, (snap) => {
        const data = snap.val();
        
        // Jika data dihapus oleh MikroTik atau status menjadi 'done'
        if (data?.status === 'done') {
          setConnectionStatus('done');
          setMessage('Tersambung ke jaringan M|S Connectivity');
          clearTimeout(timeout);
          off(statusRef);
          // Berikan waktu user melihat pesan sukses sebelum pindah
          setTimeout(() => router.replace('/(tabs)'), 1500);
        } else if (!data) {
           // Jika entry hilang/dihapus (ditolak)
           clearTimeout(timeout);
           router.replace('/login');
        } else {
          setConnectionStatus('pending');
          setMessage('Pending - Menunggu ACC MikroTik');
        }
      });
    };

    startListening();

    return () => {
      if (statusRef) off(statusRef);
      if (timeout) clearTimeout(timeout);
    };
  }, []);

  return (
    <ThemedView style={styles.container}>
      <View style={styles.content}>
        {connectionStatus !== 'done' && (
          <ActivityIndicator size="large" color={connectionStatus === 'pending' ? '#FF9800' : '#0a7ea4'} />
        )}
        <ThemedText type="subtitle" style={[
          styles.title, 
          connectionStatus === 'done' && { color: '#4CAF50' }
        ]}>
          {connectionStatus === 'done' ? '✓ Berhasil' : 'Mohon Tunggu'}
        </ThemedText>
        <ThemedText style={styles.text}>{message}</ThemedText>
        
        <TouchableOpacity style={styles.cancelButton} onPress={() => router.replace('/login')}>
          <ThemedText style={styles.cancelText}>Batalkan Login</ThemedText>
        </TouchableOpacity>
      </View>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  content: { alignItems: 'center', gap: 15 },
  title: { marginTop: 10 },
  text: { fontSize: 14, textAlign: 'center', color: '#666', lineHeight: 20 },
  cancelButton: { marginTop: 50, padding: 10 },
  cancelText: { color: '#ff4444', fontWeight: 'bold' }
});