import React, { useState } from 'react';
import { View, Text, TextInput, FlatList, Button, StyleSheet } from 'react-native';

const Patient = () => {
    const [patients, setPatients] = useState([
        { id: '1', name: 'John Doe', age: 35, disease: 'Diabetes' },
        { id: '2', name: 'Jane Smith', age: 28, disease: 'Hypertension' },
    ]);
    const [name, setName] = useState('');
    const [age, setAge] = useState('');
    const [disease, setDisease] = useState('');

    const addPatient = () => {
        if (!name || !age || !disease) return;
        setPatients([...patients, { id: Date.now().toString(), name, age: parseInt(age), disease }]);
        setName('');
        setAge('');
        setDisease('');
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Patient Management</Text>

            <TextInput placeholder="Name" value={name} onChangeText={setName} style={styles.input} />
            <TextInput placeholder="Age" value={age} keyboardType="numeric" onChangeText={setAge} style={styles.input} />
            <TextInput placeholder="Disease" value={disease} onChangeText={setDisease} style={styles.input} />
            <Button title="Add Patient" onPress={addPatient} />

            <FlatList
                data={patients}
                keyExtractor={(item) => item.id}
                renderItem={({ item }) => (
                    <View style={styles.item}>
                        <Text>{item.name} ({item.age})</Text>
                        <Text>Disease: {item.disease}</Text>
                    </View>
                )}
            />
        </View>
    );
};

export default Patient;

const styles = StyleSheet.create({
    container: { flex: 1, padding: 20 },
    title: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
    input: {
        borderWidth: 1, borderColor: '#ccc', padding: 10, marginVertical: 8, borderRadius: 6,
    },
    item: {
        padding: 15, backgroundColor: '#f2f2f2', marginVertical: 6, borderRadius: 5,
    },
});