import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonAbsensiRow extends StatelessWidget {
  const SkeletonAbsensiRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Skeleton Avatar
                Container(
                  width: 36, // Diameter dari radius 18
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Skeleton Nama & NIS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Skeleton Nama
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 40),
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Skeleton NIS
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Divider Skeleton
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 1,
                color: Colors.white,
              ),
            ),

            // Baris Bawah: 4 Chip Status (H, S, I, A)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSkeletonChip(),
                _buildSkeletonChip(),
                _buildSkeletonChip(),
                _buildSkeletonChip(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonChip() {
    return Container(
      width: 44, // Estimasi lebar chip
      height:
          36, // Estimasi tinggi chip berdasarkan padding (vertical 8 + tinggi font)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
