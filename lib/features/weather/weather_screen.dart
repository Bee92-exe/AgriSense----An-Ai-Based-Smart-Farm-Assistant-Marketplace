import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_metrics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/ambience.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen.dart';
import '../../core/widgets/states.dart';
import '../../data/models/weather.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_providers.dart';

/// Current conditions, the next few days, and any active warnings.
///
/// The alerts block sits directly under the current temperature rather than at
/// the bottom: a heavy-rain warning that requires scrolling is a warning that
/// arrives too late to save a harvested crop.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final async = ref.watch(homeWeatherProvider);

    return AppScreen(
      title: l.weatherTitle,
      ambience: AmbienceMood.weather,
      actions: [
        IconButton(
          tooltip: l.actionRetry,
          onPressed: () => ref.invalidate(homeWeatherProvider),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: async.when(
        loading: () => const LoadingState(rows: 3),
        error: (_, _) => ErrorState(
          onRetry: () => ref.invalidate(homeWeatherProvider),
        ),
        data: (report) => _Body(report: report),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = context.palette;
    final f = AppFormat.of(context);
    final now = report.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          tint: p.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.place_rounded, size: 18, color: p.onPrimary),
                  const SizedBox(width: 4),
                  Text(
                    report.district,
                    style: context.texts.labelLarge?.copyWith(color: p.onPrimary),
                  ),
                ],
              ),
              const SizedBox(height: Space.xxs),
              Text(
                '${f.number(now.tempC, decimals: 1)}\u00B0',
                style: context.texts.displayLarge
                    ?.copyWith(color: p.onPrimary, fontSize: 46),
              ),
              Text(
                now.condition,
                style: context.texts.bodyLarge?.copyWith(color: p.onPrimary),
              ),
              const SizedBox(height: Space.sm),
              // Each stat gets half the card and ellipsises its label, so the
              // pair cannot run off the card at 320dp / 1.3x.
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      icon: Icons.water_drop_outlined,
                      value: f.percentFromFraction(now.humidity / 100),
                      label: l.weatherHumidity,
                    ),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: _Stat(
                      icon: Icons.air_rounded,
                      value: f.number(now.windKph, decimals: 0),
                      label: l.weatherWind,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24),
              Text(
                l.weatherUpdated(f.relative(report.updatedAt)),
                style: context.texts.bodySmall?.copyWith(
                  color: p.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: Space.lg),
        SectionHeader(
          title: l.weatherAlertsTitle,
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(height: Space.xs),
        if (!report.hasAlerts)
          AppCard(
            tint: p.surfaceSunken,
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: p.success),
                const SizedBox(width: Space.xs),
                Text(l.weatherNoAlerts, style: context.texts.bodyMedium),
              ],
            ),
          )
        else
          for (final alert in report.alerts)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: AppCard(
                tint: p.harvestContainer,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      switch (alert.type) {
                        'heavy_rain' => Icons.umbrella_rounded,
                        'heat' => Icons.thermostat_rounded,
                        _ => Icons.warning_amber_rounded,
                      },
                      color: p.onHarvestContainer,
                    ),
                    const SizedBox(width: Space.xs),
                    Expanded(
                      child: Text(
                        alert.messageBn,
                        style: context.texts.bodyMedium
                            ?.copyWith(color: p.onHarvestContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        const SizedBox(height: Space.lg),
        SectionHeader(
          title: l.weatherForecastTitle,
          icon: Icons.calendar_today_rounded,
        ),
        const SizedBox(height: Space.xs),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < report.forecast.length; i++) ...[
                _ForecastRow(day: report.forecast[i]),
                if (i != report.forecast.length - 1) const Divider(),
              ],
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        DisclaimerNote(
          text: Localizations.localeOf(context).languageCode == 'bn'
              ? 'আবহাওয়ার তথ্য OpenWeatherMap থেকে নেওয়া।'
              : 'Weather data comes from OpenWeatherMap.',
          icon: Icons.cloud_outlined,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Icon(icon, size: 18, color: p.onPrimary),
        const SizedBox(width: 4),
        Text(value, style: context.texts.labelSmall?.copyWith(color: p.onPrimary)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.bodySmall?.copyWith(
              color: p.onPrimary.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.day});

  final WeatherDay day;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final f = AppFormat.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              f.weekday(day.date),
              style: context.texts.bodyMedium,
            ),
          ),
          Icon(
            switch (day.iconCode) {
              'sunny' => Icons.wb_sunny_rounded,
              'rainy' => Icons.umbrella_rounded,
              'partly_cloudy' => Icons.wb_cloudy_rounded,
              _ => Icons.cloud_rounded,
            },
            color: p.onSurfaceMuted,
          ),
          const SizedBox(width: Space.xs),
          Expanded(
            flex: 2,
            child: Text(
              day.condition,
              style: context.texts.bodySmall?.copyWith(color: p.onSurfaceMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${f.number(day.minC, decimals: 0)}\u00B0 / '
            '${f.number(day.maxC, decimals: 0)}\u00B0',
            style: context.texts.labelSmall,
          ),
        ],
      ),
    );
  }
}
