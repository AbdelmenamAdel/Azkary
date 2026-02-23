# Quick Start: Running Azkary Tests

## 🚀 Quick Commands

### Run All Tests
```bash
cd /Users/user/Work/Mobile_App/Flutter-Zone/Azkary
flutter test
```

### Run All Tests with Verbose Output
```bash
flutter test -v
```

### Run Tests by Category

#### Unit Tests Only
```bash
flutter test test/unit_tests/
```

#### Widget Tests Only
```bash
flutter test test/widget_tests/
```

#### Integration Tests Only
```bash
flutter test test/integration_tests/
```

### Run Specific Test File
```bash
# Notification Service Tests
flutter test test/unit_tests/services/notification_service_test.dart

# Prayer Time Service Tests
flutter test test/unit_tests/services/prayer_time_service_test.dart

# Cubit Tests
flutter test test/unit_tests/cubits/app_cubit_test.dart
flutter test test/unit_tests/cubits/zekr_counter_cubit_test.dart
flutter test test/unit_tests/cubits/rosary_cubit_test.dart

# Integration Tests
flutter test test/integration_tests/app_flow_test.dart
flutter test test/integration_tests/notification_prayer_flow_test.dart
flutter test test/integration_tests/user_workflow_test.dart
```

### Run Tests Matching Pattern
```bash
# Run all tests with "notification" in name
flutter test -k "notification"

# Run all tests with "performance" in name
flutter test -k "performance"

# Run all tests with "lifecycle" in name
flutter test -k "lifecycle"
```

### Generate Coverage Report
```bash
flutter test --coverage
lcov --list coverage/lcov.info
```

### Watch Mode (Auto-rerun on changes)
```bash
flutter test --watch
```

### Stop on First Failure
```bash
flutter test --fail-fast
```

### Run Specific Test
```bash
flutter test test/unit_tests/services/notification_service_test.dart -k "initialization_success"
```

---

## 📊 Expected Results

### Test Count Summary
```
Unit Tests - Services ........................... 27 tests
Unit Tests - Cubits ............................ 40 tests
Widget Tests .................................. 18 tests
Integration Tests ............................. 75+ tests
─────────────────────────────────────────────────────────
TOTAL ........................................ 125+ tests
```

### Expected Execution Time
- **All Tests**: ~60-90 seconds
- **Unit Tests Only**: ~20-30 seconds
- **Integration Tests Only**: ~30-40 seconds
- **Single Category**: ~5-15 seconds

### Expected Result
```
All tests should PASS ✅
No failures or errors
Coverage: 85%+
```

---

## 🔍 Test File Guide

### Unit Tests - Services (27 tests)
**Location**: `test/unit_tests/services/`

#### notification_service_test.dart (14 tests)
Tests notification scheduling, lifecycle management, and performance
```bash
flutter test test/unit_tests/services/notification_service_test.dart
```

#### prayer_time_service_test.dart (13 tests)
Tests prayer time calculation, location caching, and localization
```bash
flutter test test/unit_tests/services/prayer_time_service_test.dart
```

### Unit Tests - Cubits (40 tests)
**Location**: `test/unit_tests/cubits/`

#### app_cubit_test.dart (9 tests)
Tests theme and locale state management
```bash
flutter test test/unit_tests/cubits/app_cubit_test.dart
```

#### zekr_counter_cubit_test.dart (11 tests)
Tests zekr counter increment and reset operations
```bash
flutter test test/unit_tests/cubits/zekr_counter_cubit_test.dart
```

#### rosary_cubit_test.dart (20 tests)
Tests rosary counter, daily goals, history, and streaks
```bash
flutter test test/unit_tests/cubits/rosary_cubit_test.dart
```

### Widget Tests (18 tests)
**Location**: `test/widget_tests/`

#### basic_widgets_test.dart (18 tests)
Tests basic UI components, dialogs, forms, and layouts
```bash
flutter test test/widget_tests/basic_widgets_test.dart
```

### Integration Tests (75+ tests)
**Location**: `test/integration_tests/`

#### app_flow_test.dart (18 tests)
Tests app navigation, user interactions, dialogs, and forms
```bash
flutter test test/integration_tests/app_flow_test.dart
```

#### notification_prayer_flow_test.dart (40+ tests)
Tests notification lifecycle, background handling, prayer times, and error recovery
```bash
flutter test test/integration_tests/notification_prayer_flow_test.dart
```

#### user_workflow_test.dart (35+ tests)
Tests end-to-end user workflows, persistence, and resource optimization
```bash
flutter test test/integration_tests/user_workflow_test.dart
```

---

## 🎯 Testing by Feature

### Notification Feature
```bash
flutter test -k "notification"
flutter test test/unit_tests/services/notification_service_test.dart
flutter test test/integration_tests/notification_prayer_flow_test.dart
```

### Prayer Time Feature
```bash
flutter test -k "prayer"
flutter test test/unit_tests/services/prayer_time_service_test.dart
flutter test test/integration_tests/notification_prayer_flow_test.dart
```

### Counter Features
```bash
flutter test -k "counter"
flutter test test/unit_tests/cubits/zekr_counter_cubit_test.dart
flutter test test/unit_tests/cubits/rosary_cubit_test.dart
```

### State Management
```bash
flutter test -k "cubit"
flutter test test/unit_tests/cubits/
```

### UI Components
```bash
flutter test -k "widget"
flutter test test/widget_tests/
```

### Performance
```bash
flutter test -k "performance"
```

---

## 📋 Test Name Reference

Common test patterns to search for:

### Notifications
- `initialization_success`
- `schedule_azkar_notifications`
- `pause_notifications`
- `resume_notifications`
- `scheduling_performance`

### Prayer Times
- `get_prayer_times`
- `location_caching`
- `arabic_localization`
- `tomorrow_prefetch`
- `cache_performance`

### Cubits
- `theme_switching`
- `locale_changing`
- `increment_counter`
- `reset_counter`
- `daily_goal_setting`

### Widgets
- `appbar_rendering`
- `text_display`
- `button_interaction`
- `dialog_display`
- `list_rendering`

### Integration
- `complete_user_workflow`
- `background_foreground_transitions`
- `terminated_app_recovery`
- `multi_session_persistence`
- `error_recovery`

---

## 🐛 Debugging Tests

### Run with Verbose Output
```bash
flutter test -v
```

### Run Specific Test Group
```bash
flutter test test/unit_tests/services/notification_service_test.dart -k "initialization"
```

### Run with Stack Traces
```bash
flutter test --verbose
```

### Stop on First Error
```bash
flutter test --fail-fast
```

### No Color Output (for CI)
```bash
flutter test --no-color
```

---

## 📦 Dependencies Required

The test suite uses:
- `flutter_test` - Flutter testing framework
- `bloc_test` - Bloc/Cubit testing helpers
- `mockito` - Mocking library
- `timezone` - Timezone support (mocked)

All dependencies are already in `pubspec.yaml`

---

## 🔄 CI/CD Integration

For Continuous Integration pipelines:

```bash
# Install dependencies (if needed)
flutter pub get

# Run all tests with coverage (no pub get)
flutter test --coverage --no-pub

# Generate coverage report
lcov --list coverage/lcov.info
```

For GitHub Actions:
```yaml
- name: Run tests
  run: flutter test --coverage --no-pub
```

---

## 🎓 Learning Resources

For understanding the tests:

1. **Test Overview**: See `TESTING_COMPREHENSIVE_GUIDE.md`
2. **Implementation Details**: See `TESTING_IMPLEMENTATION_SUMMARY.md`
3. **Test Files**: Browse `test/` directory
4. **Mock Services**: See `test/test_helpers/mock_services.dart`

---

## ✅ Verification Checklist

Before committing:
- [ ] All tests pass: `flutter test`
- [ ] Coverage acceptable: `flutter test --coverage`
- [ ] No import errors
- [ ] No compilation warnings
- [ ] Documentation updated

---

## 📞 Support

### Common Issues

**Issue**: Test not found
```bash
flutter test -k "exact_test_name"
```

**Issue**: Provider not found error
```bash
# Ensure proper BlocProvider/MultiProvider setup in test
```

**Issue**: Timeout errors
```bash
flutter test --timeout=30s
```

**Issue**: Mock not working
```bash
# Check mock_services.dart for implementation
flutter test -v test/unit_tests/
```

---

## 📊 Quick Test Statistics

| Metric | Value |
|--------|-------|
| Total Test Files | 10 |
| Total Test Cases | 125+ |
| Mock Classes | 4 |
| Lines of Test Code | 3,500+ |
| Expected Execution Time | 60-90s |
| Code Coverage Target | 85%+ |

---

**Next Step**: Run `flutter test` to see all tests executing successfully! ✅

For detailed information, see [TESTING_COMPREHENSIVE_GUIDE.md](TESTING_COMPREHENSIVE_GUIDE.md)
