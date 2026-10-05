import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:soundmeter/l10n/app_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/di/injection.dart';
import '../core/meter/app_meter_settings_controller.dart';
import '../features/sound_meter/sound_level.dart';
import '../features/sound_meter/sound_meter_cubit.dart';
import '../features/sound_meter/sound_meter_state.dart';
import '../widgets/decibel_gauge.dart';
import '../widgets/decibel_history_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SoundMeterCubit>()..start(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  final _settings = getIt<AppMeterSettingsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settings.addListener(_syncWakelock);
    _syncWakelock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settings.removeListener(_syncWakelock);
    _setWakelock(false);
    super.dispose();
  }

  void _syncWakelock() {
    final state = context.read<SoundMeterCubit>().state;
    final active =
        _settings.keepScreenOn &&
        state.status == SoundMeterStatus.listening &&
        !state.paused;
    _setWakelock(active);
  }

  /// Best-effort: platforms without wakelock support just keep default sleep.
  static void _setWakelock(bool enable) {
    WakelockPlus.toggle(enable: enable).catchError((_) {});
  }

  // Release the microphone in the background; on return re-check permission
  // (the user may have granted it from system settings).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<SoundMeterCubit>();
    if (state == AppLifecycleState.paused) {
      cubit.suspend();
    } else if (state == AppLifecycleState.resumed) {
      if (cubit.state.status == SoundMeterStatus.listening) {
        cubit.resumeIfActive();
      } else {
        cubit.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<SoundMeterCubit, SoundMeterState>(
      listenWhen: (a, b) => a.status != b.status || a.paused != b.paused,
      listener: (context, _) => _syncWakelock(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              tooltip: l10n.settings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<SoundMeterCubit, SoundMeterState>(
            buildWhen: (a, b) => a.status != b.status,
            builder: (context, state) {
              final cubit = context.read<SoundMeterCubit>();
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switch (state.status) {
                  SoundMeterStatus.checking => _StatusPanel(
                    key: const ValueKey('checking'),
                    icon: Icons.mic_none_rounded,
                    title: l10n.micStartingTitle,
                    body: l10n.micStartingBody,
                    busy: true,
                  ),
                  SoundMeterStatus.permissionDenied => _StatusPanel(
                    key: const ValueKey('denied'),
                    icon: Icons.mic_rounded,
                    title: l10n.micDeniedTitle,
                    body: l10n.micDeniedBody,
                    actionLabel: l10n.grantPermission,
                    onAction: cubit.start,
                  ),
                  SoundMeterStatus.permissionDeniedForever => _StatusPanel(
                    key: const ValueKey('forever'),
                    icon: Icons.mic_off_rounded,
                    title: l10n.micDeniedForeverTitle,
                    body: l10n.micDeniedForeverBody,
                    actionLabel: l10n.openAppSettings,
                    onAction: cubit.openAppSettings,
                    onRetry: cubit.start,
                  ),
                  SoundMeterStatus.error => _StatusPanel(
                    key: const ValueKey('error'),
                    icon: Icons.error_outline_rounded,
                    title: l10n.micErrorTitle,
                    body: l10n.micErrorBody,
                    actionLabel: l10n.retry,
                    onAction: cubit.start,
                  ),
                  SoundMeterStatus.listening => const _Dashboard(
                    key: ValueKey('listening'),
                  ),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = getIt<AppMeterSettingsController>();

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final offset = settings.calibrationDb;
        double? cal(double? db) => db == null ? null : db + offset;

        return BlocBuilder<SoundMeterCubit, SoundMeterState>(
          builder: (context, state) {
            final current = cal(state.currentDb);
            final level = SoundLevel.of(current ?? 0);

            final gauge = DecibelGauge(
              value: current ?? 0,
              maxValue: cal(state.maxDb),
              unitLabel: l10n.unitDecibel,
              caption: state.paused ? l10n.meterPaused : null,
              dimmed: state.paused,
            );

            final levelCard = _LevelCard(
              level: level,
              hasReading: current != null,
            );

            final stats = Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: l10n.statMin,
                    value: cal(state.minDb),
                    color: SoundLevel.quiet.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: l10n.statAverage,
                    value: cal(state.averageDb),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: l10n.statMax,
                    value: cal(state.maxDb),
                    color: SoundLevel.dangerous.color,
                  ),
                ),
              ],
            );

            final chart = _HistoryCard(
              title: l10n.historyTitle(SoundMeterCubit.historyWindow.inSeconds),
              child: DecibelHistoryChart(
                samples: state.history,
                window: SoundMeterCubit.historyWindow,
                offsetDb: offset,
                minDb: state.minDb,
                maxDb: state.maxDb,
              ),
            );

            final controls = _Controls(paused: state.paused);

            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(child: gauge),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
                          child: Column(
                            children: [
                              levelCard,
                              const SizedBox(height: 12),
                              stats,
                              const SizedBox(height: 12),
                              SizedBox(height: 180, child: chart),
                              const SizedBox(height: 16),
                              controls,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 340),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: gauge,
                              ),
                            ),
                            levelCard,
                            const SizedBox(height: 12),
                            stats,
                            const SizedBox(height: 12),
                            SizedBox(height: 200, child: chart),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: controls,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.hasReading});

  final SoundLevel level;
  final bool hasReading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final risky = hasReading && level.fromDb >= SoundLevel.hearingRiskDb;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          level.color.withValues(alpha: hasReading ? 0.14 : 0.06),
          scheme.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: level.color.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: level.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(level.icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasReading ? level.name(l10n) : '—',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasReading ? level.example(l10n) : l10n.micStartingBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: risky
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: scheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.hearingWarning,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value == null ? '—' : value!.toStringAsFixed(1),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    TextSpan(
                      text: ' ${l10n.unitDecibel}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.paused});

  final bool paused;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SoundMeterCubit>();
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              cubit.reset();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.meterResetDone)));
            },
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(l10n.meterReset),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: cubit.togglePause,
            icon: Icon(paused ? Icons.play_arrow_rounded : Icons.pause_rounded),
            label: Text(paused ? l10n.meterResume : l10n.meterPause),
          ),
        ),
      ],
    );
  }
}

/// Centered illustration + message for the non-listening states.
class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    this.onRetry,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onRetry;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (busy)
                    SizedBox(
                      width: 112,
                      height: 112,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: scheme.primary,
                      ),
                    ),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(
                      icon,
                      size: 44,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(actionLabel!),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: onRetry, child: Text(l10n.retry)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
