import React, { useCallback } from 'react';

import { StyleSheet, View, Text, Button, FlatList } from 'react-native';

interface ActivitiesListProps {
  activities: any[];
  onPressEndActivity: (activity: any) => () => void;
}

const ActivitiesList = ({
  onPressEndActivity,
  activities,
}: ActivitiesListProps) => {
  const renderItem = useCallback(
    ({ item }) => {
      return (
        <View style={styles.cell}>
          <Text>ID: {item.id}</Text>
          <Text>Delivery Time:{item.deliveryTime}</Text>
          <Text>Items: {item.items}</Text>
          <Text>Amount: $ {item.amount}</Text>
          <Text>Image URL: {item.image}</Text>
          <Text>OrderID: {item.orderId}</Text>
          <View style={styles.row}>
            <Button title="Stop" onPress={onPressEndActivity(item)} />
          </View>
        </View>
      );
    },
    [activities]
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>List of activities</Text>
      <FlatList data={activities} renderItem={renderItem} />
    </View>
  );
};

const styles = StyleSheet.create({
  title: { fontSize: 24, fontWeight: 'bold', paddingBottom: 16 },
  container: {
    padding: 16,
  },
  cell: { flexDirection: 'column', padding: 8, borderBottomWidth: 1 },
  row: { flexDirection: 'row' },
});

export default ActivitiesList;
