import { NativeModules } from 'react-native';
import type { NotificationActivityParams, UpdateNotificationActivityParams } from './types';

const { LiveActivity } = NativeModules;

interface LiveActivityModuleInterface {
  startNotificationActivity({ title, message, image, amount, items, orderId }: NotificationActivityParams): Promise<void>;
  updateNotificationActivity({ id, message, title, body, items }: UpdateNotificationActivityParams): Promise<void>;
  endNotificationActivity(id?: string): Promise<any>;
  listActivities(): Promise<any>;
}

export default LiveActivity as LiveActivityModuleInterface;
