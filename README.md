# Architecture & Scrolling Documentation

This project implements a professional e-commerce style product feed with dynamic grids, sticky tabs, and nested scrolling using Flutter.

---

## 1. Overview

- Uses **Sliver-based layout** to achieve a single-scroll architecture.
- Dynamic, responsive **grid** layout for products.
- Sticky category **TabBar** with horizontal swipe support.
- Pull-to-refresh per category with `RefreshIndicator`.
- State preservation when switching tabs using `AutomaticKeepAliveClientMixin` and `PageStorageKey`.

---

## 2. Horizontal Swipe (Tabs)

- Implemented using `TabBarView` and `TabController`.
- The `TabController` acts as the **source of truth**:
  - Swiping horizontally updates the selected tab indicator.
  - Tapping on a tab updates the grid for the correct category.
- Tabs are scrollable and styled dynamically.

**Trade-offs:**
- Tabs must be managed via `_tabController` for sync.
- More dynamic layouts could require additional listeners, increasing complexity slightly.

---

## 3. Vertical Scroll Ownership

- Managed by `NestedScrollView`.
- Outer scrollable:
  - `SliverAppBar` pinned with TabBar
  - `SliverToBoxAdapter` contains `SearchBarPlaceholder` + `PromoStrip`
- Inner scrollable (per tab):
  - `CustomScrollView` inside `_ProductGridCategory` with `NeverScrollableScrollPhysics`
  - Uses `SliverOverlapInjector` to account for pinned header

**Rationale:**
- Ensures a **single coordinated scroll**, avoiding conflicts between the header and inner grids.
- Mimics high-end marketplaces where the header collapses and tabs remain sticky.

**Trade-offs:**
- Inner scrollable cannot scroll independently, must coordinate with outer scroll.
- Requires careful setup of `SliverOverlapAbsorber` and `SliverOverlapInjector`.

---

## 4. Product Grid

- Built with `SliverGrid` inside `_ProductGridCategory`.
- Fully **dynamic and responsive**:
  - `crossAxisCount` adapts to screen width and orientation.
  - `childAspectRatio` calculated from available width and desired height.
  - Grid spacing (`mainAxisSpacing` & `crossAxisSpacing`) scales with screen size.
  - Outer padding applied via `SliverPadding` to prevent items from touching screen edges.

- Pull-to-refresh is implemented per category with `RefreshIndicator`:
  - `edgeOffset` matches the pinned TabBar height to ensure spinner is fully visible.
  
**Trade-offs:**
- Dynamic calculations make the grid flexible but slightly more complex.
- Very large text scaling could slightly affect aspect ratios.
- Memory usage increases due to `AutomaticKeepAliveClientMixin` keeping each tab in memory.

**Limitation:**
- The header height is still dependent on the content in `SliverToBoxAdapter`. If `SearchBarPlaceholder` or `PromoStrip` grows dynamically, you must adjust accordingly.
- Pull-to-refresh is bound to inner scrollable; wrapping `NestedScrollView` could change gesture behavior.

---

## 5. Performance Considerations

- `RepaintBoundary` used on `ProductCard` to prevent unnecessary repaints.
- `SliverChildBuilderDelegate` lazily builds grid items.
- Dynamic spacing and aspect ratio calculations keep layouts responsive across devices.
- `SafeArea` applied at top-level ensures content is not clipped by notches or status bars.

---

## 6. Summary of Trade-offs

| Feature | Decision | Trade-off |
|---------|---------|-----------|
| Horizontal swipe | `TabBarView` + `TabController` | Need to manage controller lifecycle |
| Sticky header | `SliverAppBar` pinned + `SliverOverlapInjector` | Inner scroll must be coordinated; slightly more complex |
| Grid layout | Dynamic spacing, columns, and aspect ratio | Slight complexity; may need adjustments for extreme text scaling |
| Refresh indicator | `edgeOffset` matches TabBar height | Works per tab; inner scroll only |
| State preservation | `AutomaticKeepAliveClientMixin` | Slightly higher memory usage |
