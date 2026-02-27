# Architecture & Scrolling Documentation

This project implements a high-performance, e-commerce style home screen featuring a collapsing header with search functionality, category icons, and a synchronized tabbed product grid.

---

## 1. Implementation of Horizontal Swipe

The horizontal swiping behavior is implemented at two distinct levels of the UI hierarchy:

### Category & Promotion Strips
- Implemented using `ListView.separated`
- `scrollDirection: Axis.horizontal`
- Wrapped in `RepaintBoundary` widgets to isolate paint layers from the vertical scroll
- Optimized for smooth performance during rapid interactions

### Product Feed (Tab Switching)
- Managed by `TabBarView` linked to a `TabController`
- Allows lateral swiping between product categories
- Automatically syncs the `TabBar` indicator state with swipe gestures

---

## 2. Vertical Scroll Ownership

The `NestedScrollView` is the primary owner of vertical scrolling.

### Why?

To achieve the sticky header effect (where the search bar and icons scroll away but the `TabBar` stays pinned), a coordinated scroll approach is used.

### Outer Controller (Header)
- Managed by `NestedScrollView`
- Controls the `SliverAppBar`
- Calculates the offset needed to collapse the header
- Stops collapsing once only the `PreferredSize` (`TabBar`) remains visible

### Inner Controller (Product Grids)
- Each `_ProductGridCategory` contains a `CustomScrollView`
- These are treated as inner scrollables

### Scroll Coordination
- `SliverOverlapAbsorber` is used in the header
- `SliverOverlapInjector` is used in the body
- Ensures inner scrollables correctly account for the pinned header space
- Prevents product rows from being hidden beneath the `AppBar`

---

## 3. Trade-offs and Limitations

### Trade-offs

#### Performance vs. Complexity
- `NestedScrollView` enables professional pinned behavior
- Adds complexity, especially with `RefreshIndicator`
- Scroll position persistence is handled using `PageStorageKey` per grid
- Maintains position across tab switches

#### Isolate-Based Parsing
- JSON decoding is offloaded to a background `Isolate` using `compute`
- Adds ~5–10ms overhead for small payloads
- Eliminates main-thread jank for large category loads
- Maintains consistent 60fps scroll performance

---

### Limitations

#### Snap Behavior
- `snap: true` disabled in `SliverAppBar`
- Prevents tug-of-war conflicts between outer and inner scroll controllers
- Results in manual expansion/contraction
- More stable for complex nested layouts

#### Inner Physics
- Inner grids use `NeverScrollableScrollPhysics()` in specific configurations
- Strictly managed by `NestedScrollView`
- Prevents dual-scroll contention between header and grid
