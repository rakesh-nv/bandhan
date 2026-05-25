import 'package:flutter/material.dart';
import '../core/constants.dart';

class LoadingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 2.0, 0),
              colors: [
                AppColors.surfaceCreamDim.withOpacity(0.4),
                AppColors.surfaceCreamHigh.withOpacity(0.8),
                AppColors.surfaceCreamDim.withOpacity(0.4),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const LoadingSkeleton(
            width: 80,
            height: 80,
            borderRadius: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoadingSkeleton(width: 140, height: 16, borderRadius: 4),
                const SizedBox(height: 8),
                const LoadingSkeleton(width: 180, height: 12, borderRadius: 4),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    LoadingSkeleton(width: 60, height: 20, borderRadius: 10),
                    SizedBox(width: 8),
                    LoadingSkeleton(width: 80, height: 20, borderRadius: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
