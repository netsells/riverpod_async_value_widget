import 'package:flutter/material.dart';
import 'package:riverpod_async_value_widget/riverpod_async_value_widget.dart';

/// Used to provide a default configuration for any `AsyncValueWidget` below
/// this in the tree.
class DefaultAsyncValueWidgetConfig extends InheritedWidget {
  const DefaultAsyncValueWidgetConfig({
    super.key,
    this.layoutBuilder = AsyncValueWidget.defaultLayoutBuilder,
    this.transitionDuration = const Duration(milliseconds: 100),
    this.transitionSwitchInCurve = Curves.linear,
    this.transitionSwitchOutCurve = Curves.linear,
    this.errorTextStyle,
    this.retryText = 'Retry',
    this.parseError = AsyncValueWidget.defaultErrorParser,
    this.loadingBuilder = AsyncValueWidget.defaultLoadingBuilder,
    this.errorBuilder = AsyncValueWidget.defaultErrorBuilder,
    required super.child,
  });

  /// See [AnimatedSwitcher.layoutBuilder]
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  /// Duration of the transition between states
  final Duration transitionDuration;

  /// Switch-in curve of the transition between states
  final Curve transitionSwitchInCurve;

  /// Switch-out curve of the transition between states
  final Curve transitionSwitchOutCurve;

  /// Text style to use for the error message
  final TextStyle? errorTextStyle;

  /// Text to display on the retry button
  final String retryText;

  /// Function that transforms an error [Object] into a [String].
  final String Function(Object error) parseError;

  /// Builds the loading widget.
  ///
  /// Defaults to a [CircularProgressIndicator], which can either be wrapped
  /// by passing `child` into another widget, or overridden by ignoring `child`.
  ///
  /// Example:
  /// ```dart
  /// // Wrapping the circular progress indicator in a [Container]
  /// AsyncValueWidget(
  ///   value: myAsyncValue,
  ///   loadingBuilder: (context, child) => Container(child: child),
  /// );
  ///
  /// // Creating a custom loading widget
  /// AsyncValueWidget(
  ///   value: myAsyncValue,
  ///   loadingBuilder: (context, _) => Text('Loading...'),
  /// );
  /// ```
  final Widget Function(
    BuildContext context,
    Widget child,
  ) loadingBuilder;

  /// Builds the error widget.
  ///
  /// Can either be wrapped by passing `child` into another widget, or
  /// overridden by ignoring `child`.
  ///
  /// Example:
  /// ```dart
  /// // Wrapping the error in a [Container]
  /// AsyncValueWidget(
  ///   value: myAsyncValue,
  ///   errorBuilder: (context, _, child) => Container(child: child),
  /// );
  ///
  /// // Creating a custom error widget
  /// AsyncValueWidget(
  ///   value: myAsyncValue,
  ///   errorBuilder: (context, error, _) => Text(error.toString()),
  /// );
  /// ```
  final Widget Function(
    BuildContext context,
    Object error,
    Widget child,
  ) errorBuilder;

  static DefaultAsyncValueWidgetConfig? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DefaultAsyncValueWidgetConfig>();
  }

  @override
  bool updateShouldNotify(DefaultAsyncValueWidgetConfig oldWidget) {
    return true;
  }
}
