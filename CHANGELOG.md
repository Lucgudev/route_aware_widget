# Changelog

All notable changes to this project will be documented in this file.

## 0.0.1 - 2025-11-01

### Added
- Initial release of RouteAwareWidget
- Core `RouteAwareWidget` with `onPageAppear` and `onPageDisappear` callbacks
- `RouteObserverProvider` for easy RouteObserver integration
- Support for standard Navigator (MaterialPageRoute, CupertinoPageRoute)
- Compatible with AutoRoute
- Compatible with GoRouter
- Compatible with Navigator 2.0
- `RouteAwareWidgetObserver` abstract class for custom navigation systems
- Comprehensive documentation and examples
- Multiple real-world usage examples:
  - Standard Navigator example
  - Video player auto-pause example
  - Analytics tracking example
  - AutoRoute integration guide
  - GoRouter integration guide

### Features
- Lightweight implementation using Flutter's built-in RouteAware mixin
- Automatic cleanup on widget disposal
- No external dependencies (pure Flutter)
- Works with any ModalRoute-based navigation
