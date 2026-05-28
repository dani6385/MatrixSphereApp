import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getDatabase } from 'firebase/database';

const firebaseConfig = {
  apiKey: "AIzaSyD16fxrq8bRBiXYsRc9r6WTKaobYGakWTA",
  authDomain: "matrixsphere-build.firebaseapp.com",
  databaseURL: "https://matrixsphere-build-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "matrixsphere-build",
  storageBucket: "matrixsphere-build.firebasestorage.app",
  messagingSenderId: "887909343137",
  appId: "1:887909343137:web:8a86435b882cccaa7275e0",
  measurementId: "G-RKYMW3GFNT"
};

const app = initializeApp(firebaseConfig);
export const database = getDatabase(app);
export const auth = getAuth(app);