# Scroll Architecture & Gesture Coordination

This implementation prioritizes correct scroll ownership, gesture coordination, and sliver composition over UI complexity.

---

# 1. Horizontal Swipe Implementation

## A. Product

**Implementation**
- Each `ProductCard` wrapped with `RepaintBoundary`

### Why this approach?

`RepaintBoundary` improves scroll performance by isolating complex painting

### Trade-offs

- `RepaintBoundary` improves scroll performance by isolating complex painting (shadows, rounded corners).
- However, it increases memory usage slightly because widgets are cached as layers.
- Horizontal `ListView` inside a sliver layout requires careful composition to avoid gesture conflicts.
- Overuse of `RepaintBoundary` can hurt performance if not used selectively.

---

## B. Category Switching (TabBar + TabBarView)

**Implementation**
- `TabBarView`
- Shared `TabController`
- `TabBar` inside `SliverAppBar`

### Why this approach?

`TabController` acts as a single source of truth:
- Swiping pages updates the indicator.
- Tapping tabs updates the page.
- No manual sync logic required.

### Trade-offs

- Recreating `TabController` when categories change adds lifecycle complexity.
- If categories reorder dynamically (not just length change), tab state may reset.
- `TabBarView` eagerly builds all children unless carefully managed.
- Horizontal swipe between categories increases memory use when combined with `KeepAlive`.

---

# 2. Vertical Scroll Ownership

## Decision: `NestedScrollView` Owns Vertical Scroll

**Implementation**
- `NestedScrollView` as the root scroll container
- Inner `CustomScrollView` with `NeverScrollableScrollPhysics`

### Why this approach?

This ensures:
- Single vertical scroll owner
- Proper collapsing header behavior
- No competing primary scrollables
- Clean velocity handoff

### Trade-offs

- `NestedScrollView` is more complex than a standard `CustomScrollView`.
- Debugging nested scroll behaviors is harder.
- Pull-to-refresh becomes more fragile.
- Advanced scroll effects are harder to customize.

---

# 3. Inner Grid Scroll Disabled

**Implementation**
```dart
physics: NeverScrollableScrollPhysics()
```
### Why this approach?
Prevents dual vertical scroll ownership.
### Trade-offs
- Inner grid cannot independently scroll.
- Any future requirement like per-tab independent scroll physics becomes harder.
- Requires SliverOverlapInjector to align layout correctly.

---

# 4. Sliver Overlap Management
**Implementation**
- SliverOverlapAbsorber
- SliverOverlapInjector

### Why this approach?
Without this:
- First grid row would render under the SliverAppBar.
- Inner scroll would not account for header height.

### Trade-offs
- Adds structural complexity.
- Requires precise placement.
- Small mistakes cause visual bugs that are hard to debug.

---

# 5. Snap Disabled (snap: false)

### Why this approach?
snap: true can cause velocity tug-of-war between:
- Collapsing header
- Inner scroll content
- Disabling snap ensures smooth velocity transfer.

### Trade-offs
- UI feels slightly less dynamic.
- Header does not auto-expand on minor upward scroll.
- Requires more deliberate user gesture to expand.

---
# 6. State Preservation Per Tab
**Implementation**
- AutomaticKeepAliveClientMixin
- PageStorageKey

### Why this approach?
Prevents:
- Re-fetching data on tab switch
- Scroll position reset
- Visible rebuild jank

### Trade-offs
- Increased memory usage.
- All visited tabs remain alive in memory.
- Not ideal if categories scale to dozens or hundreds.

---

# 7. RefreshIndicator in NestedScrollView
**Implementation**
- Wrapped with Builder
- edgeOffset: 60

### Why this approach?
NestedScrollView outer scroll can consume the pull gesture.
The offset ensures refresh gesture reaches inner grid.

### Trade-offs
- Magic offset value (tied to header height).
- Fragile if header height changes.
- Pull-to-refresh inside NestedScrollView is inherently less predictable than in a standalone scroll view.

---

# 8. Fixed Expanded Header Height
**Implementation**
expandedHeight: 200.0

### Why this approach?
Ensures deterministic layout and predictable collapse behavior.

### Trade-offs
- Not dynamic.
- If header content changes size, manual adjustment required.
- Risk of overflow if header grows.

---
# Overall Architectural Trade-offs
This architecture prioritizes:
- Single vertical scroll ownership
- Gesture conflict avoidance
- Predictable collapse behavior
- State preservation
- Sliver correctness

Over:
- Simplicity
- Minimal memory usage
- Fully dynamic header sizing
- Minimal structural complexity


---
# Overall Limitations of the Approach
1. NestedScrollView is inherently complex and harder to maintain.
3. Pull-to-refresh inside nested scroll structures is fragile.
4. Memory usage increases due to:
5. KeepAlive
6. TabBarView
7. RepaintBoundary
8. Header height is not fully dynamic.
9. Scaling to many categories would increase memory and lifecycle overhead.
10. This structure is optimized for UX smoothness, not minimal resource usage.
