import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/enums.dart';
import '../../data/models/product.dart';
import '../../data/providers.dart';
import '../../data/repositories/market_repository.dart';
import '../../l10n/app_localizations.dart';
import 'order_confirm_sheet.dart';

final _productProvider =
    FutureProvider.family<Product, String>((ref, id) async {
  return ref.watch(marketRepositoryProvider).product(id);
});

/// One listing. The only action that changes anything is Order, and it cannot
/// happen without passing through [OrderConfirmSheet].
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(_productProvider(productId));

    return AppScreen(
      title: l.navMarket,
      child: async.when(
        loading: () => const LoadingState(rows: 3),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(_productProvider(productId)),
        ),
        data: (product) => _Body(product: product),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.product});

  final Product product;

  Future<void> _order(BuildContext context, WidgetRef ref) async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // No confirmation => no order. The sheet returns null when dismissed, and
    // that must not fall through to a default.
    final confirmation = await showModalBottomSheet<OrderConfirmation>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => OrderConfirmSheet(product: product),
    );
    if (confirmation == null) return;

    try {
      await ref.read(marketRepositoryProvider).placeOrder(
            PlaceOrderRequest(
              clientUuid: const Uuid().v4(),
              items: [
                (productId: product.id, quantity: confirmation.quantity),
              ],
              paymentMode: confirmation.paymentMode,
              placedVia: InputMode.touch,
            ),
          );
      messenger.showSnackBar(SnackBar(content: Text(l.orderPlaced)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.stateErrorBody)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              color: p.surfaceSunken,
              borderRadius: Radii.tileAll,
              border: Border.all(color: p.outline, width: p.borderWidth),
            ),
            child: Icon(
              switch (product.category) {
                'seed' => Icons.grass_rounded,
                'fertilizer' => Icons.science_rounded,
                'pesticide' => Icons.pest_control_rounded,
                'fungicide' => Icons.coronavirus_rounded,
                _ => Icons.handyman_rounded,
              },
              size: 72,
              color: p.primary,
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(product.label(locale), style: context.texts.titleLarge),
        const SizedBox(height: Space.xxs),
        Row(
          children: [
            Text(f.taka(product.price), style: context.texts.titleLarge),
            const SizedBox(width: Space.sm),
            if (product.inStock)
              Text(
                l.marketStockCount(f.number(product.stock)),
                style: context.texts.bodySmall
                    ?.copyWith(color: p.onSurfaceMuted),
              )
            else
              Text(
                l.marketOutOfStock,
                style: context.texts.labelSmall?.copyWith(color: p.error),
              ),
          ],
        ),
        const SizedBox(height: Space.md),

        AppCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: p.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.vendor.shopName,
                        style: context.texts.titleSmall),
                    if (product.vendor.rating != null)
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 16, color: p.onHarvestContainer),
                          const SizedBox(width: 2),
                          Text(
                            f.number(product.vendor.rating!, decimals: 1),
                            style: context.texts.bodySmall
                                ?.copyWith(color: p.onSurfaceMuted),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              VerifiedBadge(verified: product.vendor.verified),
            ],
          ),
        ),

        if (product.activeIngredient != null) ...[
          const SizedBox(height: Space.md),
          AppCard(
            tint: p.surfaceSunken,
            child: Row(
              children: [
                Icon(Icons.science_outlined, color: p.onSurfaceMuted),
                const SizedBox(width: Space.xs),
                Expanded(
                  child: Text(
                    product.activeIngredient!,
                    style: context.texts.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],

        if (product.description != null) ...[
          const SizedBox(height: Space.lg),
          SectionHeader(
            title: l.productDescription,
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: Space.xs),
          AppCard(
            child: Text(product.description!, style: context.texts.bodyMedium),
          ),
        ],

        const SizedBox(height: Space.lg),
        AppButton(
          label: l.diagnosisOrderMedicine,
          icon: Icons.shopping_bag_rounded,
          isEnabled: product.inStock,
          onPressed: () => _order(context, ref),
        ),
        const SizedBox(height: Space.md),
        DisclaimerNote(
          text: l.orderServerTotalNote,
          icon: Icons.receipt_long_rounded,
        ),
      ],
    );
  }
}
