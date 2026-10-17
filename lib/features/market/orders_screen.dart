import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/labels.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/states.dart';
import '../../data/models/enums.dart';
import '../../data/models/product.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  return ref.watch(marketRepositoryProvider).orders();
});

/// The farmer's own orders, with the four-step progress the PRD asks for.
///
/// The list shows `displayStatus`, not `status`: decision A4 lets the server fold
/// `confirmed` into `pending` for farmers, and the client follows the server's
/// grouping rather than re-deriving it.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(ordersProvider);

    return AppScreen(
      title: l.navOrders,
      ambience: AmbienceMood.orders,
      actions: [
        IconButton(
          tooltip: l.actionRetry,
          onPressed: () => ref.invalidate(ordersProvider),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: async.when(
        loading: () => const LoadingState(rows: 3),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(ordersProvider)),
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_rounded,
              title: l.stateEmptyTitle,
              body: l.stateEmptyBody,
            );
          }
          return Column(
            children: [
              for (final order in orders)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.xs),
                  child: _OrderCard(order: order),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The status pill cannot shrink, so the order number has to be able
          // to drop to its own line rather than push the pill off the card.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: Space.xs,
            runSpacing: Space.xxs,
            children: [
              Text(order.orderNo, style: context.texts.titleSmall),
              _StatusPill(status: order.displayStatus),
            ],
          ),
          const SizedBox(height: Space.xxs),
          Text(
            '${order.vendor.shopName} · ${f.shortDate(order.createdAt)}',
            style: context.texts.bodySmall?.copyWith(color: p.onSurfaceMuted),
          ),
          const Divider(),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${f.number(item.quantity)} × ',
                    style: context.texts.bodySmall
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                  Expanded(
                    child: Text(
                      item.name,
                      style: context.texts.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(f.taka(item.subtotal), style: context.texts.bodySmall),
                ],
              ),
            ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.orderTotal,
                  style: context.texts.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Space.xs),
              Text(f.taka(order.totalAmount), style: context.texts.titleSmall),
            ],
          ),
          // Ordered via voice is worth surfacing: it is one of the things the
          // pilot report measures.
          if (order.placedVia == InputMode.voice) ...[
            const SizedBox(height: Space.xxs),
            Row(
              children: [
                Icon(Icons.mic_rounded, size: 16, color: p.onSurfaceMuted),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    l.voiceMicLabel,
                    style: context.texts.bodySmall
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                ),
              ],
            ),
          ],
          if (order.canCancel) ...[
            const SizedBox(height: Space.xs),
            OutlinedButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(l.orderCancelTitle),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(l.actionCancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: Text(l.actionConfirm),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) return;
                try {
                  await ref.read(marketRepositoryProvider).cancelOrder(order.id);
                  ref.invalidate(ordersProvider);
                } catch (_) {
                  // Only `pending` orders can be cancelled; the server rejects
                  // anything else with `invalid_transition`.
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.orderCannotCancel)),
                    );
                  }
                }
              },
              child: Text(l.actionCancel),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l = AppL10n.of(context);

    final (foreground, background) = switch (status) {
      OrderStatus.delivered => (p.severityLow, p.severityLowContainer),
      OrderStatus.rejected ||
      OrderStatus.cancelled =>
        (p.severityUrgent, p.severityUrgentContainer),
      OrderStatus.shipped => (p.severityMedium, p.severityMediumContainer),
      _ => (p.onSurfaceMuted, p.surfaceSunken),
    };

    return Semantics(
      label: status.label(l),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: Radii.chipAll,
          border: Border.all(color: foreground, width: p.borderWidth),
        ),
        child: Text(
          status.label(l),
          style: context.texts.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
