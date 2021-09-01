# In-App Notifications

## Samples:

### PowerShell

This will loop through all apps in a tenant and set the in-app notification enablement.

### Dataverse Solutions

This contains a managed and unmanaged solution to set the in-app notification for a specific app by using its friendly name e.g. 'Sales Hub'.

The setting is called 'AllowNotificationsEarlyAccess' and the value needs to be true to turn on.

The broadcast in-app notifications to all users flow shows how to get all users and send a notification.

The payload or the HTTP call looks like this:

{

 "title": "Welcome from Postman",

 "body": "Welcome to the world of app notifications!",

 "icontype": 100000000, // info

 "toasttype": 200000000 // timed

}

## Notification Details

## Notification table

The following are the columns for the notification table:

| Column           | Description                                                  |
| :--------------- | :----------------------------------------------------------- |
| Title            | Title of the notification.                                   |
| Owner            | User who receives the notification.                          |
| Body             | Details of the notification.                                 |
| Icon Type        | List of predefined icons. The default value is `Info`. More information: [Notification icons](https://docs.microsoft.com/en-us/powerapps/developer/model-driven-apps/clientapi/send-in-app-notifications#changing-the-notification-icon) |
| Toast Type       | List of toast behaviors. The default value is `Timed`. More information: [Toast types](https://docs.microsoft.com/en-us/powerapps/developer/model-driven-apps/clientapi/send-in-app-notifications#changing-the-toast-notification-behavior) |
| Expiry (seconds) | Number of seconds from when the notification should be deleted if not already dismissed. |
| Data             | Json that is used for extensibility and parsing richer data into the notification. Maximum length is 5000. |

###  Changing the toast notification behavior

An in-app notification behavior can be changed by setting **Toast Type** to one of the following values:

| Toast Type | Behavior                                                     | Value     |
| :--------- | :----------------------------------------------------------- | :-------- |
| Timed      | Notification appears for a brief duration and then disappears. (default 4 seconds) | 200000000 |
| Hidden     | Notification appears only in the notification center and not as a toast. | 200000001 |

### Changing the notification icon

An in-app notification icon can be changed by setting **Icon Type** to one of the following values. When using a custom icon, a `iconUrl` parameter should be specified within the `data` parameter.

| Icon Type | Value     |
| :-------- | :-------- |
| Info      | 100000000 |
| Success   | 100000001 |
| Failure   | 100000002 |
| Warning   | 100000003 |
| Mention   | 100000004 |
| Custom    | 100000005 |

### Changing the navigation target in notification link

You can control where a navigation link should open by setting the `navigationTarget` parameter.

| Navigation target | Behavior                            | Example                           |
| :---------------- | :---------------------------------- | :-------------------------------- |
| Dialog            | Opens in center dialog.             | `"navigationTarget": "dialog"`    |
| Inline            | Default. Opens in the current page. | `"navigationTarget": "inline"`    |
| newWindow         | Opens in the new browser tab.       | `"navigationTarget": "newWindow"` |

### Managing security for notifications

The in-app notification feature uses three tables, and a user needs to have the correct security roles to receive notifications and send notifications to themselves, or other users.

| Usage                                                        | Needed table privileges                                      |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| User has no in-app notification bell and receives no in-app notifications toasts | None: Read privilege on app notification table.              |
| User can receive in-app notifications                        | - Basic: Read privilege on app notification table. - Create and read privilege on model-driven app user setting. |
| User can send in-app notifications to self                   | - Basic: Create privilege on app notification table. - Write and append privilege on model-driven app user setting. - Append privilege on setting definition. |
| User can send in-app notifications to others                 | Read privilege with Local, Deep, or Global access level on app notification table based on the receiving user's business unit. |