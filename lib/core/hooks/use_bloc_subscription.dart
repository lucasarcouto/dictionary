import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

void useBlocSubscription<T, S>(
    BuildContext context, void Function(S) onStateChanged) {
  final cubit = Provider.of<T>(context) as Cubit;

  useEffect(() {
    cubit.stream.listen((state) {
      onStateChanged.call(state);
    });
    return;
  }, []);
}
