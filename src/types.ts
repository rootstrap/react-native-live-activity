export type NotificationActivityParams = {
  title: string;
  message: string;
  image: string;
  orderId: string;
  amount: string;
  items: number;
};

export type UpdateNotificationActivityParams = {
  id: string;
  message: string;
  title: string;
  body: string;
  items: number;
};
