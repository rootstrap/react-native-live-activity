import React, { useState, useEffect, useCallback } from 'react';

import {
  Alert,
  Linking,
  SafeAreaView,
  Button,
} from 'react-native';
import LiveActivity from 'react-native-live-activity';
import ActivitiesList from './ActivitiesList';

const App = () => {
  const [status, setStatus] = useState<string>('Packing');
  const [driver, setDriver] = useState<string>('John');
  const [deliverTime, setDeliveryTime] = useState<string>('3pm');
  const [activities, setActivities] = useState<any[]>([]);
  const [activity, setActivity] = useState<any>();

  const handlerDeepLink = (url: string) => {
    const action = url.replace('liveactivity://', '');

    if (action.startsWith('cancel')) {
      Alert.alert('Cancel order');
    }

    if (action.startsWith('call')) {
      Alert.alert('Calling delivery');
    }
  };

  useEffect(() => {
    Linking.getInitialURL()
      .then((url) => {
        if (url) {
          handlerDeepLink(url);
        }
      })
      .catch((err) => {
        console.warn('An error occurred', err);
      });

    Linking.addEventListener('url', ({ url }) => {
      if (url) {
        handlerDeepLink(url);
      }
    });
  }, []);

  useEffect(() => {
    if (activity) {
      setDriver(activity.driverName);
      setStatus(activity.status);
      setDeliveryTime(activity.expectingDeliveryTime);
    }
  }, [activity]);

  useEffect(() => {
    LiveActivity.listActivities().then(setActivities);
  }, [setActivities]);

  const onPressCreate = useCallback(() => {
    LiveActivity.startNotificationActivity({
      message: 'Message property',
      title: 'Order received',
      amount: '$10.00',
      items: 1,
      image: '',
      orderId: '12345',
    })
      .then((result) => {
        console.log('result: ', result)
        LiveActivity.listActivities().then(setActivities)
      })
      .catch(console.log)
  }, [status, driver, deliverTime]);

  const onPressEdit = useCallback(() => {
    LiveActivity.updateNotificationActivity({
      id: activity.id,
      title: 'Notification update',
      body: 'Delivery getting closer',
      items: 2,
      message: 'Message property',
    });
    setActivity(undefined);
  }, [status, driver, deliverTime, activity]);

  const onPressEndActivity = useCallback(
    (item) => {
      return () => {
        LiveActivity.endNotificationActivity(item.id);
        setActivities(activities.filter((value) => value.id !== item.id));
      };
    },
    [activities]
  );

  return (
    <SafeAreaView>
      <Button
        title={'Create activity'}
        onPress={onPressCreate}
      />
      <Button title={'Update activity'} onPress={onPressEdit} />

      <ActivitiesList
        activities={activities}
        onPressEndActivity={onPressEndActivity}
      />
    </SafeAreaView>
  );
}

export default App;
