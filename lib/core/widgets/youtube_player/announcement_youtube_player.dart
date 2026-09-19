import 'dart:async';

import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Player configuration for every announcement video.
///
/// No `origin` is set on purpose: the package loads the embed with
/// `baseUrl = origin ?? host`, so an origin that isn't the host
/// (`youtube-nocookie.com` in privacy-enhanced mode) makes YouTube refuse the
/// embed with error 152/153 and no control bar ever appears.
YoutubePlayerParams announcementPlayerParams(String languageCode) =>
    YoutubePlayerParams(
      // YouTube's own control bar: play/pause, timeline, speed and quality in
      // the settings menu, captions, and the fullscreen button.
      showControls: true,
      showFullscreenButton: true,
      strictRelatedVideos: true,
      interfaceLanguage: languageCode,
      captionLanguage: languageCode,
      // The player posts currentTime/buffered over the JS bridge this often
      // while playing. We read neither (YouTube draws its own timeline), and
      // the default 100ms floods the bridge, which is what makes messages
      // arrive after the WebView is torn down. Once a second is plenty.
      videoStateUpdateInterval: 1000,
    );

/// YouTube's own player, behind a thumbnail.
///
/// The WebView is created only when the user taps play, so nothing streams on
/// mobile data unasked. Seeking, speed, quality, captions and fullscreen come
/// from YouTube's built-in controls, plus the package's rotate-to-fullscreen
/// and swipe gestures.
///
/// Staff can make a video private, delete it or turn off embedding on YouTube
/// without touching the dashboard, so [YoutubeError] is expected: it swaps in
/// a message with a way to open the video in YouTube itself.
class AnnouncementYoutubePlayer extends StatefulWidget {
  const AnnouncementYoutubePlayer({
    super.key,
    required this.videoId,
    required this.watchUrl,
    this.posterUrl,
  });

  /// The 11-character id from `youtube_video_id`.
  final String videoId;

  /// `youtube_url`, opened in the YouTube app as a fallback.
  final String watchUrl;

  /// Shown until the user taps play.
  final String? posterUrl;

  @override
  State<AnnouncementYoutubePlayer> createState() =>
      _AnnouncementYoutubePlayerState();
}

class _AnnouncementYoutubePlayerState extends State<AnnouncementYoutubePlayer> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _subscription;
  YoutubeError? _error;
  bool _screenOn = false;

  @override
  void didUpdateWidget(covariant AnnouncementYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Staff pointed the announcement at a different video.
    if (oldWidget.videoId != widget.videoId) _teardown();
  }

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }

  void _teardown() {
    _subscription?.cancel();
    _subscription = null;
    final controller = _controller;
    _controller = null;
    _error = null;
    if (controller != null) unawaited(_disposeController(controller));
    _keepScreenOn(false);
  }

  /// Pausing first stops the player's JavaScript state ticker, so no messages
  /// are left in flight once the WebView goes away. Both steps talk to a
  /// WebView that may already be disposed, so neither may throw on us.
  Future<void> _disposeController(YoutubePlayerController controller) async {
    try {
      await controller.pauseVideo();
    } catch (e) {
      AppLogger.warning('Pausing the player before disposal failed: $e');
    }
    try {
      await controller.close();
    } catch (e) {
      AppLogger.warning('Closing the player failed: $e');
    }
  }

  void _start() {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: announcementPlayerParams(context.locale.languageCode),
    );
    _subscription = controller.listen(_onValue);
    setState(() {
      _controller = controller;
      _error = null;
    });
  }

  void _restart() {
    _teardown();
    _start();
  }

  void _onValue(YoutubePlayerValue value) {
    if (!mounted) return;
    if (value.hasError && value.error != _error) {
      AppLogger.error(
        'YouTube player error ${value.error.code} on video ${widget.videoId}',
      );
      setState(() => _error = value.error);
    }
    _keepScreenOn(value.playerState == PlayerState.playing);
  }

  /// The screen shouldn't dim mid-video. Best effort: never breaks playback.
  void _keepScreenOn(bool enable) {
    if (enable == _screenOn) return;
    _screenOn = enable;
    WakelockPlus.toggle(enable: enable).catchError((Object e) {
      AppLogger.warning('Wakelock toggle failed: $e');
    });
  }

  Future<void> _openInYoutube() async {
    final uri = Uri.tryParse(widget.watchUrl);
    if (uri == null) return;
    try {
      // Hands off to the YouTube app when it's installed.
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      await launchUrl(uri);
    } catch (e) {
      AppLogger.error('Could not open ${widget.watchUrl}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: AppColors.blackColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (controller == null)
              YoutubePoster(posterUrl: widget.posterUrl, onPlay: _start)
            else
              YoutubePlayer(
                controller: controller,
                aspectRatio: 16 / 9,
                backgroundColor: AppColors.blackColor,
                // The player sits in a scrolling page: a vertical drag should
                // scroll it, not jump to fullscreen. The fullscreen button in
                // YouTube's own controls still works.
                enableFullScreenOnVerticalDrag: false,
              ),
            if (_error != null)
              YoutubeUnavailableView(
                onOpenInYoutube: _openInYoutube,
                onRetry: _restart,
              ),
          ],
        ),
      ),
    );
  }
}

/// Thumbnail with a play button, shown until the player is asked for.
class YoutubePoster extends StatelessWidget {
  const YoutubePoster({super.key, required this.posterUrl, this.onPlay});

  final String? posterUrl;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final hasPoster = posterUrl != null && posterUrl!.isNotEmpty;
    return Semantics(
      button: onPlay != null,
      label: LocaleKeys.watch_video.tr(),
      child: GestureDetector(
        onTap: onPlay,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasPoster)
              CustomCachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                isProjectDetails: true,
              )
            else
              const VideoPlaceholderBackground(),
            ColoredBox(color: AppColors.blackColor.withValues(alpha: 0.3)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _YoutubePlayBadge(),
                  12.ph,
                  AppText(
                    LocaleKeys.watch_video.tr(),
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      shadows: const [Shadow(blurRadius: 8)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// YouTube's rounded red play button.
class _YoutubePlayBadge extends StatelessWidget {
  const _YoutubePlayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 45.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: AppColors.whiteColor,
        size: 32.sp,
      ),
    );
  }
}

/// Dark branded backdrop for an announcement with no image at all.
class VideoPlaceholderBackground extends StatelessWidget {
  const VideoPlaceholderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0B1B2B),
            AppColors.primaryColor.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 44.sp,
          color: AppColors.whiteColor.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}

/// Private, deleted, or embedding turned off: always offer YouTube itself.
class YoutubeUnavailableView extends StatelessWidget {
  const YoutubeUnavailableView({
    super.key,
    required this.onOpenInYoutube,
    required this.onRetry,
  });

  final VoidCallback onOpenInYoutube;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.blackColor.withValues(alpha: 0.88),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.whiteColor,
              size: 30.sp,
            ),
            8.ph,
            AppText(
              LocaleKeys.video_unavailable.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            12.ph,
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onOpenInYoutube,
                  icon: Icon(Icons.smart_display_rounded, size: 18.sp),
                  label: Text(LocaleKeys.open_in_youtube.tr()),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    foregroundColor: AppColors.whiteColor,
                    shape: const StadiumBorder(),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded, size: 18.sp),
                  label: Text(LocaleKeys.try_again.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.whiteColor,
                    side: BorderSide(
                      color: AppColors.whiteColor.withValues(alpha: 0.6),
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
