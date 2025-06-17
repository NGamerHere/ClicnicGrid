import {Tabs} from 'expo-router';
import React from 'react';
import {Ionicons} from '@expo/vector-icons';
import AntDesign from '@expo/vector-icons/AntDesign';

export default function TabLayout() {
    return (
        <Tabs
            screenOptions={{
                headerShown: false,
                tabBarActiveTintColor: '#007AFF',
            }}
        >
            {/* Home */}
            <Tabs.Screen
                name="index"
                options={{
                    title: 'Home',
                    tabBarIcon: ({color, size}) => (
                        <Ionicons name="home" size={size} color={color}/>
                    ),
                }}
            />

            <Tabs.Screen
                name="patient"
                options={{
                    title: 'Patient',
                    tabBarIcon: ({color, size}) => (
                        <Ionicons name="people" size={size} color={color} />
                    ),
                }}
            />

            {/* Pharmacy */}
            <Tabs.Screen
                name="pharmacy"
                options={{
                    title: 'Pharmacy',
                    tabBarIcon: ({color, size}) => (
                        <Ionicons name="medkit" size={size} color={color}/>
                    ),
                }}
            />

            {/* Explore */}
            <Tabs.Screen
                name="profile"
                options={{
                    title: 'profile',
                    tabBarIcon: ({color, size}) => (
                        <AntDesign name="profile" size={size} color={color}/>
                    ),
                }}
            />
        </Tabs>
    );
}
