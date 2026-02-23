# Performance Testing & Validation Guide

## 📋 Pre-Optimization Baseline

Establish baseline metrics BEFORE deploying optimizations:

### Battery Drain Test
```
Duration: 24 hours of normal usage
Initial Battery: 100%
Final Battery: ___% (Record this)
Drain Rate: ___% per hour
```

### Memory Usage Test
```
Initial Memory: ___MB (Launch app)
Peak Memory: ___MB (After 1 hour)
After Background: ___MB (Return from background)
```

### CPU Usage Test  
```
Idle CPU: ___%
During Prayer Times Load: ___%
During Notifications: ___%
```

---

## 🚀 Post-Optimization Testing

### Phase 1: Functionality Verification (Day 1)

#### ✅ Notification Verification
- [ ] Notifications appear at 6 AM
- [ ] Notifications appear at 9 AM
- [ ] Notifications appear at 12 PM
- [ ] Notifications appear at 3 PM
- [ ] Notifications appear at 6 PM
- [ ] Notifications appear at 9 PM
- [ ] Only 6 notifications per day (not 50)
- [ ] Notifications persist after app close
- [ ] Notifications work in background

#### ✅ Prayer Times Verification
- [ ] Prayer times display correctly
- [ ] Countdown timer updates every second
- [ ] Next prayer highlights properly
- [ ] Prayer times remain same for 1 hour (location cached)

#### ✅ Location/GPS Verification
- [ ] GPS location loads on first run
- [ ] Subsequent loads are faster (cached)
- [ ] Accuracy remains same
- [ ] Prayer times match location

#### ✅ Foreground Dialog Verification
- [ ] Dialog appears every 60 minutes (was 30 min)
- [ ] Dialog shows random azkar
- [ ] Dialog can be dismissed
- [ ] No dialog while app backgrounded

#### ✅ Background Behavior
- [ ] Timer pauses when app backgrounded
- [ ] Timer resumes when app returns
- [ ] No notifications shown while inside app (only scheduled ones)
- [ ] App doesn't crash on background

### Phase 2: Performance Metrics (Day 1-7)

#### Battery Drain Measurement
```
Day 1-3: Initial measurement
Day 1: ___% drain per hour (baseline)
Day 2: ___% drain per hour  
Day 3: ___% drain per hour
Average: ___% per hour

Day 4-7: Verify consistency
Day 4: ___% drain per hour
Day 5: ___% drain per hour
Day 6: ___% drain per hour
Day 7: ___% drain per hour
```

#### Memory Profiling
```
Collect via Android Studio Profiler:

Initial Launch:
- Native Memory: ___MB
- Java Heap: ___MB
- Graphics: ___MB
- Total: ___MB

After 1 Hour:
- Native Memory: ___MB
- Java Heap: ___MB
- Graphics: ___MB
- Total: ___MB

After Background/Foreground (10x):
- Native Memory: ___MB
- Java Heap: ___MB
- Graphics: ___MB
- Total: ___MB
```

#### CPU Usage Profiling
```
via Android Studio Profiler:

Idle (no interaction): ___%
Scrolling Through Azkar: ___%
Loading Prayer Times: ___%
Notification Receives: ___%
Background Usage: ___%
```

### Phase 3: User Experience Testing (Day 1-3)

#### ✅ App Responsiveness
- [ ] App launches in < 3 seconds
- [ ] Transitions smooth (no jank)
- [ ] Scrolling smooth at 60 FPS
- [ ] No lag when opening dialogs
- [ ] No lag when loading prayer times

#### ✅ Memory Stability
- [ ] No memory leaks on repeated background/foreground
- [ ] No memory leaks on repeated notification opens
- [ ] Memory returns to baseline after app exit
- [ ] No crashes after 24 hours of usage

#### ✅ Battery Stability
- [ ] Consistent battery drain rate over 24 hours
- [ ] No unexpected spikes in battery usage
- [ ] Standby drain reasonable
- [ ] GPS not constantly on

---

## 📊 Expected Results Checklist

### Battery Improvement
- [ ] 15-25% improvement in battery life (typical)
- [ ] GPS drain reduced by ~80%
- [ ] Notifications drain reduced by ~88%
- [ ] Background CPU usage reduced by ~70%

### Memory Improvement
- [ ] Peak memory usage 15-25% lower
- [ ] No memory leaks introduced
- [ ] Memory returns to baseline  
- [ ] Heap fragmentation improved

### App Performance
- [ ] Startup time same or faster
- [ ] UI remains smooth
- [ ] No new crashes
- [ ] All features work correctly

---

## 🔍 Debugging Commands

### Check Pending Notifications
```bash
# Android
adb shell dumpsys alarm

# Should show ~6 pending alarms (not 50)
```

### Check Location Requests
```bash
# Android Logcat
adb logcat | grep "LocationManager\|Location"

# Should show fewer requests after first 10 minutes
```

### Check Battery Stats
```bash
# Reset battery stats
adb shell dumpsys batterystats --reset

# Use app normally for several hours

# Check stats
adb shell dumpsys batterystats | grep -A 20 "Appid"

# Look for app usage statistics
```

### Check Memory in Real-Time
```bash
# Via Android Studio > Profiler
# Or via terminal:
adb shell dumpsys meminfo | grep -A 30 "app."
```

### Monitor App Lifecycle
```bash
# View lifecycle logs
adb logcat | grep "AppLifecycleObserver\|didChangeAppLifecycle"

# Should see:
# "App resumed"
# "App paused"
```

---

## 📈 Comparison Template

Use this to document before/after results:

### Battery Usage
```
Metric              Before          After           Improvement
────────────────────────────────────────────────────────────
Hourly Drain        ___ %/hour      ___ %/hour      ___ %
Daily Usage         ___ %/day       ___ %/day       ___ %
Standby Drain       ___ %/hour      ___ %/hour      ___ %
GPS Activity        ~80% of time    ~5% of time     ~94% ↓
```

### Memory Usage
```
Metric              Before          After           Improvement
────────────────────────────────────────────────────────────
Peak Memory         ___ MB          ___ MB          ___ MB
Average Memory      ___ MB          ___ MB          ___ MB
Heap Size           ___ MB          ___ MB          ___ MB
Native Memory       ___ MB          ___ MB          ___ MB
```

### CPU Usage
```
Metric              Before          After           Improvement
────────────────────────────────────────────────────────────
Idle CPU            ___ %           ___ %           ___ %
Active CPU          ___ %           ___ %           ___ %
Background CPU      ___ %           ___ %           ___ %
Peak CPU            ___ %           ___ %           ___ %
```

### Notifications
```
Metric              Before          After           Improvement
────────────────────────────────────────────────────────────
Per Day             50              6               88% ↓
Scheduling Time     ___ ms          ___ ms          
DB Operations       ___ ops/day     ___ ops/day     
Battery Impact      ___ %           ___ %           
```

---

## ⚠️ Issues to Watch For

### Potential Issues & Solutions

#### Issue: Fewer Notifications
**Symptom:** Users complain about fewer reminders  
**Expected:** Only 6 per day now (was 50)  
**Solution:** Explain optimization rationale, suggest using OS notifications

#### Issue: Prayer Times Change
**Symptom:** Prayer times seem different than before  
**Expected:** Caused by 1-hour location cache  
**Solution:** Location cache prevents excessive GPS usage (acceptable trade-off)

#### Issue: No Battery Improvement
**Symptom:** Battery drain same as before  
**Possible Causes:**
- Old data cached from before optimization
- Other apps draining battery
- Device settings changed
- **Solution:** Restart phone, clear app cache, test for 24 hours

#### Issue: App Crashes on Background
**Symptom:** App crashes when going to background  
**Check:**
- Are timers being cancelled?
- Is lifecycle observer registered?
- Are observers removed in dispose?
- **Solution:** Verify prayer_times_section.dart has observer cleanup

#### Issue: Notifications Not Appearing
**Symptom:** No notifications at scheduled times  
**Check:**
- Do times match what's configured?
- Is phone in DND mode?
- Is battery saver on?
- Is notification permission granted?
- **Solution:** Check notification settings, verify configuration

---

## 📱 Testing Devices

Test on at least these device configurations:

### Minimum Testing
- [ ] Android 12 (one device)
- [ ] Android 14 (one device)
- [ ] iOS 16 (one device)
- [ ] iOS 17 (one device)

### Recommended Testing
- [ ] Low-end device (2GB RAM, 6-year-old CPU)
- [ ] Mid-range device (4GB RAM, 3-year-old CPU)
- [ ] High-end device (8GB+ RAM, latest CPU)
- [ ] Tablets (different aspect ratios)

---

## 📋 Test Sign-Off Checklist

### Functionality
- [ ] All 6 notifications appear at scheduled times
- [ ] Prayer times display correctly
- [ ] Background notifications work
- [ ] Foreground dialog appears hourly
- [ ] No app crashes
- [ ] All features work as before

### Performance
- [ ] Battery improvement of 15%+ observed
- [ ] Memory usage 15%+ lower
- [ ] CPU usage reduced during idle
- [ ] App startup time same or faster
- [ ] Smooth scrolling maintained (60 FPS)

### Quality  
- [ ] No memory leaks detected
- [ ] No new crashes introduced
- [ ] All edge cases handled
- [ ] Logging shows optimizations working
- [ ] Code follows best practices

### User Feedback (Beta)
- [ ] Positive feedback on battery
- [ ] Positive feedback on performance
- [ ] No complaints about fewer notifications
- [ ] No technical issues reported
- [ ] Overall satisfaction > 4/5

---

## 📊 Results Documentation

After testing, fill in:

```
OPTIMIZATION VALIDATION REPORT
──────────────────────────────

Date: ___________
Tester: ___________
Device: ___________ (OS: ___, RAM: ___, Storage: ___)

BATTERY RESULTS:
Before: ___% drain per hour
After: ___% drain per hour
Improvement: ___% ✓

MEMORY RESULTS:
Before: ___MB peak
After: ___MB peak  
Improvement: ___MB ✓

CPU RESULTS:
Before: ___%  idle
After: ___%  idle
Improvement: ___% ✓

NOTIFICATIONS:
Count: ___/6 appearing ✓
Times: All correct ✓
Background: Working ✓

ISSUES FOUND:
[ ] None
[ ] Minor (list): ___________
[ ] Major (list): ___________

SIGN OFF:
Tester: __________________ Date: _______
Status: [ ] PASS  [ ] FAIL
```

---

## 🚀 Rollout Plan

Once optimizations validated:

1. **Week 1:** Beta release to 10% of users
   - Monitor crash rates
   - Collect user feedback
   - Review battery metrics

2. **Week 2:** Expand to 50% of users
   - Continue monitoring
   - Verify no crashes
   - Check metrics stable

3. **Week 3:** General release to 100%
   - Monitor for issues
   - Publish release notes
   - Track positive feedback

---

**Testing Completed:** _____________  
**Issues Found:** _____________  
**Ready for Release:** ☐ YES ☐ NO
