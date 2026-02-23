# Background & Terminated Notifications Implementation

## Summary
Your Azkary app has been enhanced to support scheduled notifications in **background** and **terminated** states on both Android and iOS.

## What Was Changed

### 1. **NotificationService** (`lib/core/services/notification_service.dart`)

#### New Methods:
- **`rescheduleMissedNotifications()`** - Checks and reschedules notifications if they were cleared
- **`resumeNotifications()`** - Called when app returns from background to verify notifications are active
- **`pauseNotifications()`** - Called when app goes to background to pause foreground dialogs
- **`_saveNotificationScheduleTime()`** - Saves timestamp of last scheduling for debugging
- **`getLastNotificationScheduleTime()`** - Retrieves last scheduling time
- **`_initializeBackgroundHandler()`** - Initializes background notification handling

#### Enhanced Methods:
- **`_scheduleNotification()`** - Now explicitly uses:
  - `AndroidScheduleMode.exactAllowWhileIdle` (if permission granted)
  - `AndroidScheduleMode.inexactAllowWhileIdle` (fallback)
  - These modes ensure notifications fire even with battery optimization enabled
  
- **`_initTasks()`** - Now calls `rescheduleMissedNotifications()` instead of just `scheduleDailyAzkar()` to ensure persistence after app termination

- **`init()`** - Added background handler initialization

### 2. **Android Manifest** (`android/app/src/main/AndroidManifest.xml`)

#### Fixed Boot Receiver:
Changed `ScheduledNotificationBootReceiver` from `android:exported="false"` to `android:exported="true"` to allow it to receive system BOOT_COMPLETED broadcasts.

```xml
<receiver android:exported="true" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

**Already Present:**
- ✅ `RECEIVE_BOOT_COMPLETED` permission
- ✅ `SCHEDULE_EXACT_ALARM` permission
- ✅ `POST_NOTIFICATIONS` permission
- ✅ `WAKE_LOCK` permission

### 3. **App Lifecycle Management** (`lib/main.dart`)

#### New Classes:
- **`AppLifecycleObserver`** - Implements `WidgetsBindingObserver` to track app state changes
  - Calls `resumeNotifications()` when app returns from background (AppLifecycleState.resumed)
  - Calls `pauseNotifications()` when app goes to background (AppLifecycleState.paused)
  
#### Enhanced MyApp Widget:
- Changed from `StatelessWidget` to `StatefulWidget`
- Added lifecycle observer initialization in `initState()`
- Added proper cleanup in `dispose()`

## How It Works

### Android Background Flow:
1. App schedules 50 notifications daily using `zonedSchedule` with `exactAllowWhileIdle`
2. Even if app is terminated, AlarmManager keeps the scheduled notifications
3. When device reboots:
   - `BootReceiver` receives `BOOT_COMPLETED` broadcast
   - Flutter Local Notifications automatically reschedules all pending notifications
4. Notifications fire at scheduled times regardless of app state

### iOS Background Flow:
1. Scheduled notifications are stored in `UNUserNotificationCenter`
2. iOS system is responsible for firing them at the scheduled time
3. No action needed - works automatically even if app is terminated
4. Notifications persist across device reboots

### Foreground Flow:
1. When app is in foreground, `AppLifecycleObserver` ensures lifecycle is tracked
2. Scheduled notifications work normally
3. Additionally, a dialog appears every 30 minutes with a random azkar
4. When app goes to background, foreground timer is paused
5. When app returns to foreground, timer resumes and pending notifications are verified

## Testing the Implementation

### Test 1: Basic Scheduled Notifications
```dart
// In your app, click the test notification button
sl<NotificationService>().testNotification();
```

### Test 2: Background Notifications
1. Launch the app (notifications are scheduled)
2. Close the app completely (swipe from recent apps)
3. Wait for a scheduled notification time
4. Check if notification appears (without opening app)

### Test 3: Device Restart (Android)
1. Launch the app (notifications are scheduled)
2. Restart the device
3. After restart, notifications should still be pending/scheduled
4. Wait for scheduled notification time to verify

### Test 4: Terminated State After Time Out
1. Launch the app
2. Force close it
3. Wait several hours or modify system time for testing
4. Check if notifications fire at scheduled times

## Permissions Required

### Android:
- ✅ `SCHEDULE_EXACT_ALARM` - For precise notification timing
- ✅ `RECEIVE_BOOT_COMPLETED` - For rescheduling after device restart
- ✅ `POST_NOTIFICATIONS` - For sending notifications (Android 13+)
- ✅ `WAKE_LOCK` - To wake device if needed

### iOS:
- ✅ `NSLocationWhenInUseUsageDescription` - Already configured for prayer times

## Debugging

Check logcat/console for these debug messages:

### Android:
```
D/NotificationService: Pending notifications on init: 50
D/NotificationService: Rescheduling: Found 50 pending notifications
D/AppLifecycleObserver: App resumed - resuming notifications
D/AppLifecycleObserver: App paused - pausing foreground notifications
```

### To check pending notifications:
```dart
final pending = await _notificationsPlugin.pendingNotificationRequests();
print('Pending notifications: ${pending.length}');
```

## Potential Issues & Solutions

### Issue: Notifications stop after app is force-closed
**Solution:** Implemented rescheduling on app launch. If still issues:
- Check if user denied notification permission
- Verify `SCHEDULE_EXACT_ALARM` permission is granted
- Check battery optimization settings for your app

### Issue: Device restart doesn't reschedule notifications
**Solution:** Ensure boot receiver has `android:exported="true"` (✅ already fixed)

### Issue: Too many notifications after force-close or cache clear
**Solution:** The app calls `cancelAll()` before rescheduling to prevent duplicates

### Issue: Notifications don't fire at exact time (Android)
**Solution:** This is expected behavior when SoD optimizations are enabled. The app uses `inexactAllowWhileIdle` as fallback which fires within ~15 minutes of scheduled time.

## Important Notes

1. **Background vs Foreground Notifications:**
   - Foreground: Dialog appears while app is open (every 30 min)
   - Background: System notifications appear even if app is closed
   - Scheduled notifications work in both modes

2. **Battery Optimization:**
   - Android respects battery saving modes but still delivers notifications
   - If timing is critical, advise users to add app to battery optimization whitelist

3. **iOS Specifics:**
   - iOS handles suspended/terminated notifications natively
   - No additional code needed, works automatically
   - Respects DND, Focus modes, and user notification settings

4. **Reschedule Logic:**
   - Rescheduling checks if notifications already exist first
   - Only reschedules if pending notifications list is empty
   - This prevents duplicate notifications from accumulating

## Files Modified
- ✅ `lib/core/services/notification_service.dart` - Enhanced with background/terminated support
- ✅ `lib/main.dart` - Added AppLifecycleObserver for state tracking
- ✅ `android/app/src/main/AndroidManifest.xml` - Fixed boot receiver export flag
- ℹ️ `ios/Runner/Info.plist` - No changes needed (already configured)

## Next Steps

1. **Build and Test:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Notifications:**
   - Verify notifications appear while app is in foreground
   - Close app and verify background notifications work
   - Restart device and verify notifications still work

3. **Monitor Logs:**
   - Keep logcat/console open while testing
   - Look for debug messages from NotificationService

4. **User Testing:**
   - Have users run app for 24 hours
   - Test after force-closing app
   - Test after device restart

## FAQ

**Q: Will notifications work if I kill the app from task manager?**
A: Yes, on Android they continue to be managed by AlarmManager. On iOS by UNUserNotificationCenter.

**Q: What happens if notification permission is denied?**
A: Notifications won't show. The app requests permission on startup; users can grant it in settings.

**Q: Can I modify notification times after scheduling?**
A: You can call `scheduleDailyAzkar()` again which cancels all and reschedules with new times.

**Q: Why does it reschedule on app launch?**
A: To handle edge cases like force-stop, cache clear, or if notifications were somehow removed.

**Q: Is this battery-intensive?**
A: No, Android's AlarmManager and iOS's UNUserNotificationCenter are optimized for this purpose.
