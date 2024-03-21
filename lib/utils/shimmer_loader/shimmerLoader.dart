import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShimmerLoader extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final Duration duration;
  final int loop;
  final bool enabled;
  final List<Color> colors;

  const ShimmerLoader({
    Key? key,
    required this.child,
    this.isLoading = false,
    this.duration = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
    this.colors = const [],
  }) : super(key: key);

  @override
  _ShimmerLoaderState createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _count;

//* InitState
  @override
  void initState() {
    super.initState();
    _count = 0;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0) {
          _controller.repeat();
        } else if (_count < widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

//* didUpdateWidget
  @override
  void didUpdateWidget(covariant ShimmerLoader oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

//* Dispose
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//* Build Method
  @override
  Widget build(BuildContext context) {
    // if (!widget.isLoading) {
    //   return widget.child;
    // }
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => _ShimmerLoader(
        child: child,
        percent: _controller.value,
      ),
    );
  }
}

@immutable
class _ShimmerLoader extends SingleChildRenderObjectWidget {
  final double? percent;

  const _ShimmerLoader({
    Widget? child,
    this.percent,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _ShimmerFilter shimmer) {
    shimmer.percent = percent!;
  }
}

//* Render Object
class _ShimmerFilter extends RenderProxyBox {
  double? _percent;
  final Gradient? customGradient;

  _ShimmerFilter(this._percent, {this.customGradient});
  Gradient _gradient = LinearGradient(
    colors: [
      Colors.grey[300]!,
      Colors.grey[300]!,
      Colors.grey[100]!,
      Colors.grey[300]!,
      Colors.grey[300]!,
    ],
    stops: const [
      0.0,
      0.2,
      0.5,
      0.8,
      1.0,
    ],
    begin: const Alignment(-1.0, -0.3),
    end: const Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;

      dx = _offset(width, -width, _percent!);
      dy = 0.0;
      rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);

      layer ??= ShaderMaskLayer();
      layer
        ?..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
