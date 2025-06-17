import React, { useEffect, useState, createContext, useContext } from 'react';
import { View, ActivityIndicator, StyleSheet, Text, StatusBar } from 'react-native';
import { Stack, useRouter, useSegments } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';

// Types
interface User {
    id: string;
    email: string;
    name: string;
    avatar?: string;
}

interface AuthContextType {
    user: User | null;
    isAuthenticated: boolean;
    isLoading: boolean;
    signIn: (userData: User, token: string) => Promise<void>;
    signOut: () => Promise<void>;
    updateUser: (userData: Partial<User>) => Promise<void>;
}

// Auth Context
const AuthContext = createContext<AuthContextType | null>(null);

// Custom hook to use auth context
export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};

// Auth Provider Component
function AuthProvider({ children }: { children: React.ReactNode }) {
    const [user, setUser] = useState<User | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const router = useRouter();
    const segments = useSegments();

    // Check if user is in auth group (login, register, etc.)
    // @ts-ignore
    const inAuthGroup = segments[0] === '(auth)';

    // Initialize auth state
    useEffect(() => {
        checkAuthState();
    }, []);

    // Handle navigation based on auth state
    useEffect(() => {
        if (isLoading) return;

        if (!user && !inAuthGroup) {
            // Redirect to login if not authenticated and not in auth group
            router.replace('/login');
        } else if (user && inAuthGroup) {
            // Redirect to tabs if authenticated and in auth group
            router.replace('/(tabs)');
        }
    }, [user, segments, isLoading, inAuthGroup, router]);

    const checkAuthState = async () => {
        try {
            const token = await AsyncStorage.getItem('userToken');
            const userData = await AsyncStorage.getItem('userData');

            if (token && userData) {
                const parsedUser = JSON.parse(userData);
                setUser(parsedUser);
            }
        } catch (error) {
            console.error('Error checking auth state:', error);
            // Clear potentially corrupted data
            await AsyncStorage.multiRemove(['userToken', 'userData']);
        } finally {
            setIsLoading(false);
        }
    };

    const signIn = async (userData: User, token: string) => {
        try {
            await AsyncStorage.setItem('userToken', token);
            await AsyncStorage.setItem('userData', JSON.stringify(userData));
            setUser(userData);
        } catch (error) {
            console.error('Error signing in:', error);
            throw error;
        }
    };

    const signOut = async () => {
        try {
            await AsyncStorage.multiRemove(['userToken', 'userData']);
            setUser(null);
        } catch (error) {
            console.error('Error signing out:', error);
            throw error;
        }
    };

    const updateUser = async (updatedData: Partial<User>) => {
        try {
            if (!user) return;

            const updatedUser = { ...user, ...updatedData };
            await AsyncStorage.setItem('userData', JSON.stringify(updatedUser));
            setUser(updatedUser);
        } catch (error) {
            console.error('Error updating user:', error);
            throw error;
        }
    };

    const value: AuthContextType = {
        user,
        isAuthenticated: !!user,
        isLoading,
        signIn,
        signOut,
        updateUser,
    };

    return (
        <AuthContext.Provider value={value}>
            {children}
        </AuthContext.Provider>
    );
}

// Loading Screen Component
function LoadingScreen() {
    return (
        <View style={styles.loadingContainer}>
            <StatusBar barStyle="light-content" backgroundColor="#3b82f6" />

            {/* App Logo/Brand */}
            <View style={styles.logoContainer}>
                <View style={styles.logo}>
                    <Text style={styles.logoText}>YourApp</Text>
                </View>
            </View>

            {/* Loading Indicator */}
            <View style={styles.loadingIndicator}>
                <ActivityIndicator size="large" color="#ffffff" />
                <Text style={styles.loadingText}>Loading...</Text>
            </View>

            {/* Version Info */}
            <View style={styles.versionContainer}>
                <Text style={styles.versionText}>Version 1.0.0</Text>
            </View>
        </View>
    );
}

// Main Layout Component
export default function RootLayout() {
    const [fontsLoaded] = useFonts({
        // Add your custom fonts here
        // 'CustomFont-Regular': require('../assets/fonts/CustomFont-Regular.ttf'),
        // 'CustomFont-Bold': require('../assets/fonts/CustomFont-Bold.ttf'),
    });

    // Prevent splash screen from auto-hiding
    useEffect(() => {
        SplashScreen.preventAutoHideAsync();
    }, []);

    // Hide splash screen when fonts are loaded
    useEffect(() => {
        if (fontsLoaded) {
            SplashScreen.hideAsync();
        }
    }, [fontsLoaded]);

    // Show loading if fonts aren't loaded
    if (!fontsLoaded) {
        return null;
    }

    return (
        <AuthProvider>
            <RootNavigator />
        </AuthProvider>
    );
}

// Root Navigator Component
function RootNavigator() {
    const { isLoading } = useAuth();

    // Show loading screen while checking auth state
    if (isLoading) {
        return <LoadingScreen />;
    }

    return (
        <>
            <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />
            <Stack
                screenOptions={{
                    headerShown: false,
                    gestureEnabled: true,
                    animation: 'slide_from_right',
                    contentStyle: { backgroundColor: '#ffffff' },
                }}
            >
                {/* Authentication Screens */}
                <Stack.Screen
                    name="login"
                    options={{
                        gestureEnabled: false, // Disable swipe back on login
                    }}
                />
                <Stack.Screen
                    name="register"
                    options={{
                        presentation: 'modal',
                        animation: 'slide_from_bottom',
                    }}
                />
                <Stack.Screen
                    name="forgot-password"
                    options={{
                        presentation: 'modal',
                        animation: 'slide_from_bottom',
                    }}
                />

                {/* Main App Screens */}
                <Stack.Screen
                    name="(tabs)"
                    options={{
                        gestureEnabled: false, // Disable swipe back from main app
                    }}
                />

                {/* Modal Screens */}
                <Stack.Screen
                    name="profile-edit"
                    options={{
                        presentation: 'modal',
                        animation: 'slide_from_bottom',
                        headerShown: true,
                        title: 'Edit Profile',
                    }}
                />
                <Stack.Screen
                    name="camera"
                    options={{
                        presentation: 'fullScreenModal',
                        animation: 'slide_from_bottom',
                    }}
                />
                <Stack.Screen
                    name="settings"
                    options={{
                        presentation: 'modal',
                        animation: 'slide_from_bottom',
                        headerShown: true,
                        title: 'Settings',
                    }}
                />

                {/* Onboarding (shown only once) */}
                <Stack.Screen
                    name="onboarding"
                    options={{
                        gestureEnabled: false,
                        animation: 'fade',
                    }}
                />

                {/* Error/Fallback Screens */}
                <Stack.Screen
                    name="error"
                    options={{
                        presentation: 'modal',
                        animation: 'fade',
                    }}
                />
                <Stack.Screen
                    name="maintenance"
                    options={{
                        gestureEnabled: false,
                        animation: 'fade',
                    }}
                />

                {/* Catch-all for undefined routes */}
                <Stack.Screen
                    name="+not-found"
                    options={{
                        title: 'Page Not Found',
                        headerShown: true,
                    }}
                />
            </Stack>
        </>
    );
}

const styles = StyleSheet.create({
    loadingContainer: {
        flex: 1,
        backgroundColor: '#3b82f6',
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 20,
    },
    logoContainer: {
        position: 'absolute',
        top: '30%',
        alignItems: 'center',
    },
    logo: {
        width: 120,
        height: 120,
        borderRadius: 60,
        backgroundColor: 'rgba(255, 255, 255, 0.2)',
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 3,
        borderColor: 'rgba(255, 255, 255, 0.3)',
    },
    logoText: {
        fontSize: 24,
        fontWeight: 'bold',
        color: '#ffffff',
        textAlign: 'center',
    },
    loadingIndicator: {
        alignItems: 'center',
    },
    loadingText: {
        color: '#ffffff',
        fontSize: 16,
        marginTop: 16,
        fontWeight: '500',
    },
    versionContainer: {
        position: 'absolute',
        bottom: 50,
        alignItems: 'center',
    },
    versionText: {
        color: 'rgba(255, 255, 255, 0.7)',
        fontSize: 14,
    },
});