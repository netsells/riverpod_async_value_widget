import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_async_value_widget/src/default_async_value_widget_config.dart';

/// A [Widget] that responds to the state of an [AsyncValue].
///
/// By default:
/// * If [value] is an [AsyncLoading], a circular progress indicator is
/// displayed.
/// * If [value] is an [AsyncError], an error message is displayed.
/// * If [value] is an [AsyncData], the widget provided by [builder] is
/// displayed.
///
/// All this behaviour can be customised by providing a [loadingBuilder] and/or
/// [errorBuilder].
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.builder,
    this.layoutBuilder,
    this.transitionDuration,
    this.transitionSwitchInCurve,
    this.transitionSwitchOutCurve,
    this.loadingBuilder,
    this.errorBuilder,
    this.errorTextStyle,
    this.retryText,
    this.parseError,
    this.onRetry,
  });

  /// The current value
  final AsyncValue<T> value;

  /// Builder that builds the widget when [value] is an [AsyncData<T>]
  final Widget Function(BuildContext, T) builder;

  /// See [AnimatedSwitcher.layoutBuilder]
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  /// Duration of the transition between states
  final Duration? transitionDuration;

  /// Switch-in curve of the transition between states
  final Curve? transitionSwitchInCurve;

  /// Switch-out curve of the transition between states
  final Curve? transitionSwitchOutCurve;

  /// Text style to use for the error message
  final TextStyle? errorTextStyle;

  /// Text to display on the retry button
  final String? retryText;

  /// Called when the retry button is pressed.
  ///
  /// Should be used to refresh the [value].
  ///
  /// If this is `null`, the retry button will not be displayed.
  final VoidCallback? onRetry;

  /// Function that transforms an error [Object] into a [String].
  final String Function(Object error)? parseError;

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
  )? loadingBuilder;

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
  )? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final defaultConfig = DefaultAsyncValueWidgetConfig.of(context);

    final loadingBuilder = this.loadingBuilder ??
        defaultConfig?.loadingBuilder ??
        defaultLoadingBuilder;
    final errorBuilder =
        this.errorBuilder ?? defaultConfig?.errorBuilder ?? defaultErrorBuilder;

    final parseError =
        this.parseError ?? defaultConfig?.parseError ?? defaultErrorParser;

    return AnimatedSwitcher(
      layoutBuilder:
          layoutBuilder ?? defaultConfig?.layoutBuilder ?? defaultLayoutBuilder,
      duration: transitionDuration ??
          defaultConfig?.transitionDuration ??
          const Duration(milliseconds: 100),
      switchInCurve: transitionSwitchInCurve ??
          defaultConfig?.transitionSwitchInCurve ??
          Curves.linear,
      switchOutCurve: transitionSwitchOutCurve ??
          defaultConfig?.transitionSwitchOutCurve ??
          Curves.linear,
      child: value.when(
        loading: () => loadingBuilder(
          context,
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        error: (error, _) => errorBuilder(
          context,
          error,
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  parseError(error),
                  textAlign: TextAlign.center,
                  style: errorTextStyle,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: Text(
                      retryText ?? defaultConfig?.retryText ?? 'Retry',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        data: (data) => builder(context, data),
      ),
    );
  }

  static Widget defaultLoadingBuilder(
    BuildContext _,
    Widget child,
  ) {
    return child;
  }

  static Widget defaultErrorBuilder(
    BuildContext _,
    Object __,
    Widget child,
  ) {
    return child;
  }

  static const AnimatedSwitcherLayoutBuilder defaultLayoutBuilder =
      AnimatedSwitcher.defaultLayoutBuilder;

  static String defaultErrorParser(Object error) => error.toString();
}
