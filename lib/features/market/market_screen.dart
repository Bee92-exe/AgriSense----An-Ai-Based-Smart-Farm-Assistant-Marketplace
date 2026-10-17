import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/states.dart';
import '../../data/models/product.dart';
import '../../data/providers.dart';
import '../../data/repositories/market_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../shell/farmer_shell.dart';

/// Search, category and stock state for Haat_Bazar, held in a provider so the
/// list does not reset every time a farmer opens a product and comes back.
class MarketFilter extends Notifier<ProductQuery> {
  @override
  ProductQuery build() => const ProductQuery();

  void setText(String text) => state = state.copyWith(text: text);

  void setCategory(String? category) => state = category == null
      ? state.copyWith(clearCategory: true)
      : state.copyWith(category: category);

  void toggleInStock() => state = state.copyWith(inStockOnly: !state.inStockOnly);
}

final marketFilterProvider =
    NotifierProvider<MarketFilter, ProductQuery>(MarketFilter.new);

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(marketFilterProvider);
  return ref.watch(marketRepositoryProvider).products(query: query);
});

final productCategoriesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(marketRepositoryProvider).categories();
});

/// Haat_Bazar.
///
/// Only verified vendors appear: that filter is enforced in the repository, and
/// this screen simply shows what it is given. The empty state distinguishes
/// "nothing matched your search" from "nothing here", because the two need
/// different next actions.
class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final filter = ref.watch(marketFilterProvider);
    final async = ref.watch(productListProvider);
    final categories = ref.watch(productCategoriesProvider);

    return AppScreen(
      title: l.navMarket,
      bottomNav: const FarmerNav(current: FarmerTab.market),
      fab: const FarmerMicFab(),
      ambience: AmbienceMood.market,
      actions: [
        IconButton(
          tooltip: l.navOrders,
          onPressed: () => context.push(Routes.orders),
          icon: const Icon(Icons.receipt_long_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (v) =>
                ref.read(marketFilterProvider.notifier).setText(v),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l.actionSearch,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: Space.sm),
          categories.maybeWhen(
            data: (list) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text(l.marketAllCategories),
                    selected: filter.category == null,
                    onSelected: (_) => ref
                        .read(marketFilterProvider.notifier)
                        .setCategory(null),
                  ),
                  const SizedBox(width: Space.xs),
                  for (final c in list) ...[
                    FilterChip(
                      label: Text(_categoryLabel(c, l)),
                      selected: filter.category == c,
                      onSelected: (v) => ref
                          .read(marketFilterProvider.notifier)
                          .setCategory(v ? c : null),
                    ),
                    const SizedBox(width: Space.xs),
                  ],
                ],
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: Space.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              label: Text(l.marketInStockOnly),
              selected: filter.inStockOnly,
              onSelected: (_) =>
                  ref.read(marketFilterProvider.notifier).toggleInStock(),
            ),
          ),
          const SizedBox(height: Space.md),
          async.when(
            loading: () => const LoadingState(rows: 4),
            error: (_, _) => ErrorState(
              onRetry: () => ref.invalidate(productListProvider),
            ),
            data: (products) {
              if (products.isEmpty) {
                return EmptyState(
                  icon: Icons.search_off_rounded,
                  title: l.stateEmptyTitle,
                  body: l.stateEmptyBody,
                  actionLabel: l.actionRetry,
                  onAction: () {
                    ref.read(marketFilterProvider.notifier).setText('');
                    ref.read(marketFilterProvider.notifier).setCategory(null);
                  },
                );
              }
              return Column(
                children: [
                  for (final product in products)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.xs),
                      child: _ProductTile(product: product),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Wire category to Bangla label. An unknown category falls back to its raw
  /// name rather than being hidden — a new server-side category should show up
  /// in the filter, not silently disappear.
  static String _categoryLabel(String wire, AppL10n l) => switch (wire) {
        'seed' => l.categorySeed,
        'fertilizer' => l.categoryFertilizer,
        'pesticide' => l.categoryPesticide,
        'fungicide' => l.categoryFungicide,
        'equipment' => l.categoryEquipment,
        _ => wire,
      };
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return AppCard(
      padding: const EdgeInsets.all(Space.sm),
      onTap: () => context.push('/market/${product.id}'),
      semanticLabel: product.label(locale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Sizes.listThumbnail,
            height: Sizes.listThumbnail,
            decoration: BoxDecoration(
              color: p.surfaceSunken,
              borderRadius: BorderRadius.circular(12),
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
              color: p.primary,
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.label(locale),
                  style: context.texts.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.vendor.shopName,
                  style: context.texts.bodySmall
                      ?.copyWith(color: p.onSurfaceMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.xxs),
                // Wrap, not Row: the price plus "যাচাইকৃত" is wider than a
                // 164dp tile once Bangla is at its largest scale.
                Wrap(
                  spacing: Space.xs,
                  runSpacing: Space.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(f.taka(product.price), style: context.texts.titleSmall),
                    if (!product.inStock)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: p.errorContainer,
                          borderRadius: Radii.chipAll,
                          border: Border.all(
                            color: p.error,
                            width: p.borderWidth,
                          ),
                        ),
                        child: Text(
                          l.marketOutOfStock,
                          style: context.texts.labelSmall
                              ?.copyWith(color: p.error),
                        ),
                      )
                    else
                      VerifiedBadge(
                        verified: true,
                        label: Localizations.localeOf(context).languageCode ==
                                'bn'
                            ? 'যাচাইকৃত'
                            : 'Verified',
                      ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.onSurfaceMuted),
        ],
      ),
    );
  }
}
