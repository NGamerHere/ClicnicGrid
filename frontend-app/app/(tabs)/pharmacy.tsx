import React, { useState } from 'react';
import { View, Text, FlatList, TextInput, Button, StyleSheet } from 'react-native';

const Pharmacy = () => {
    const [medicines, setMedicines] = useState([
        { id: '1', name: 'Paracetamol', quantity: 100 },
        { id: '2', name: 'Amoxicillin', quantity: 50 },
    ]);
    const [name, setName] = useState('');
    const [quantity, setQuantity] = useState('');

    const addMedicine = () => {
        if (!name || !quantity) return;
        setMedicines([...medicines, { id: Date.now().toString(), name, quantity: parseInt(quantity) }]);
        setName('');
        setQuantity('');
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Pharmacy Management</Text>

            <TextInput
                placeholder="Medicine Name"
                value={name}
                onChangeText={setName}
                style={styles.input}
            />
            <TextInput
                placeholder="Quantity"
                keyboardType="numeric"
                value={quantity}
                onChangeText={setQuantity}
                style={styles.input}
            />
            <Button title="Add Medicine" onPress={addMedicine} />

            <FlatList
                data={medicines}
                keyExtractor={(item) => item.id}
                renderItem={({ item }) => (
                    <View style={styles.item}>
                        <Text>{item.name}</Text>
                        <Text>Qty: {item.quantity}</Text>
                    </View>
                )}
            />
        </View>
    );
};

export default Pharmacy;

const styles = StyleSheet.create({
    container: { flex: 1, padding: 20 },
    title: { fontSize: 24, fontWeight: 'bold', marginBottom: 16 },
    input: {
        borderWidth: 1, borderColor: '#ccc', padding: 10, marginVertical: 8, borderRadius: 6,
    },
    item: {
        padding: 15, backgroundColor: '#f9f9f9', marginVertical: 6, borderRadius: 5,
        flexDirection: 'row', justifyContent: 'space-between',
    },
});
