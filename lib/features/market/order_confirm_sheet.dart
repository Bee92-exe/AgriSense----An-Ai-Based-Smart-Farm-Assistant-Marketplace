import 'package:flutter/material.dart';

import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/badges.dart';
import '../../data/models/product.dart';
import '../../l10n/app_localizations.dart';

/// What the farmer is about to buy, and the answer they gave.
class OrderConfirmation {
  const OrderConfirmation({required this.quantity, required this.paymentMode});

  final int quantity;

  /// `cod` (cash on delivery) or `direct` (paid between buyer and seller).
  /// Online payment is explicitly out of scope, so these are the only two.
  final String paymentMode;
}

/// The mandatory confirm-before-money step.
///
/// Used identically by the touch flow and (later) the voice flow, which is the
/// point: the PRD's hard safety rule is that no order is created without an
/// explicit confirmation, and one shared sheet means the rule has one home.
///
/// Dismissing the sheet returns `null`, and `null` must mean **no order is
/// created** — never a default. Every caller must therefore return early on a
/// null result, exactly as `ProductDetailScreen` does.
class OrderConfirmSheet extends StatefulWidget {
  const OrderConfirmSheet({
    super.key,
    required this.product,
    this.voiceInitiated = false,
  });

  final Product product;

  /// True when a spoken command raised this sheet, so the copy matches what the
  /// farmer just said.
  final bool voiceInitiated;

  @override
  State<OrderConfirmSheet> createState() => _OrderConfirmSheetState();
}

class _OrderConfirmSheetState extends State<OrderConfirmSheet> {
  int _quantity = 1;
  String _payment = 'cod';

  int get _total => widget.product.price * _quantity;

  /// The server is the authority on stock; this only stops the farmer asking for
  /// more than is known to exist.
  int get _maxQuantity => widget.product.stock.clamp(1, 20);

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.voiceInitiated
                        ? l.voiceConfirmationTitle
                        : l.orderConfirmTitle,
                    style: context.texts.titleLarge,
                  ),
                ),
                const AiBadge(),
              ],
            ),
            if (widget.voiceInitiated) ...[
              const SizedBox(height: Space.xxs),
              Text(
                l.voiceConfirmationBody,
                style: context.texts.bodySmall
                    ?.copyWith(color: p.onSurfaceMuted),
              ),
            ],
            const SizedBox(height: Space.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.label(locale),
                          style: context.texts.titleSmall,
                        ),
                      ),
                      VerifiedBadge(verified: widget.product.vendor.verified),
                    ],
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    widget.product.vendor.shopName,
                    style: context.texts.bodySmall
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text(l.selectQuantity, style: context.texts.bodyMedium),
                      const Spacer(),
                      IconButton(
                        tooltip: l.selectQuantity,
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                      ),
                      Text(f.number(_quantity),
                          style: context.texts.titleSmall),
                      IconButton(
                        tooltip: l.selectQuantity,
                        onPressed: _quantity < _maxQuantity
                            ? () => setState(() => _quantity++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(l.orderTotal, style: context.texts.bodyMedium),
                      const Spacer(),
                      Text(f.taka(_total), style: context.texts.titleLarge),
                    ],
                  ),
                  const SizedBox(height: Space.xxs),
                  Text(
                    l.orderServerTotalNote,
                    style: context.texts.bodySmall
                        ?.copyWith(color: p.onSurfaceMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Space.md),
            Text(l.orderPaymentMode, style: context.texts.titleSmall),
            const SizedBox(height: Space.xs),
            Row(
              children: [
                Expanded(
                  child: _PaymentOption(
                    label: l.orderPaymentCod,
                    icon: Icons.payments_outlined,
                    selected: _payment == 'cod',
                    onTap: () => setState(() => _payment = 'cod'),
                  ),
                ),
                const SizedBox(width: Space.xs),
                Expanded(
                  child: _PaymentOption(
                    label: l.orderPaymentDirect,
                    icon: Icons.handshake_outlined,
                    selected: _payment == 'direct',
                    onTap: () => setState(() => _payment = 'direct'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Space.lg),
            AppButton(
              label: l.actionConfirm,
              icon: Icons.check_rounded,
              onPressed: () => Navigator.of(context).pop(
                OrderConfirmation(quantity: _quantity, paymentMode: _payment),
              ),
            ),
            const SizedBox(height: Space.xs),
            AppButton(
              label: l.actionCancel,
              tone: AppButtonTone.secondary,
              // Closing without a result is the "no" path.
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Material(
        color: selected ? p.primaryContainer : p.surface,
        borderRadius: Radii.cardAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: Radii.cardAll,
          child: Container(
            constraints: const BoxConstraints(minHeight: Sizes.minTapTarget),
            padding: const EdgeInsets.all(Space.sm),
            decoration: BoxDecoration(
              borderRadius: Radii.cardAll,
              border: Border.all(
                color: selected ? p.primary : p.outline,
                width: selected ? p.borderWidth + 1 : p.borderWidth,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected ? p.onPrimaryContainer : p.onSurfaceMuted,
                ),
                const SizedBox(height: Space.xxs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: context.texts.labelSmall?.copyWith(
                    color: selected ? p.onPrimaryContainer : p.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
