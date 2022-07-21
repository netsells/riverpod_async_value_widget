# riverpod_async_value_widget

![GitHub](https://img.shields.io/github/license/netsells/riverpod_async_value_widget)
[![Pub Version](https://img.shields.io/pub/v/riverpod_async_value_widget)](https://pub.dev/packages/riverpod_async_value_widget)
[![Style](https://img.shields.io/badge/style-netsells-%231d3d90)](https://pub.dev/packages/netsells_flutter_analysis)

Used to simplify the display of `AsyncValue`s from [Riverpod](https://pub.dev/packages/riverpod).

## Usage

The basic purpose of the package is to save you from having to create error/loading states every time you want to display an `AsyncValue`. The `AsyncValueWidget` automatically shows a progress indicator in the loading state, and an error message in the error state.

A "Retry" button can be added by specifying an `onRetry` callback.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
    final myValue = ref.watch(myProvider);

    return AsyncValueWidget<String>(
        value: myValue,
        builder: (context, data) {
            return Text(data);
        },
        onRetry: () => ref.refresh(myProvider),
    );
}
```

### Customisation

There is a variety of customisation options available in `AsyncValueWidget`. Many of these options can be applied globally (or for any other widget tree scope) using the `DefaultAsyncValueWidgetConfig` widget:

```dart
DefaultAsyncValueWidgetConfig(
    transitionDuration: const Duration(milliseconds: 50),
    // Lots of other options available
    child: MyApp(),
);
```