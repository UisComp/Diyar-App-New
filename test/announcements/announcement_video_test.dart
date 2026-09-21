import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/youtube_player/announcement_youtube_player.dart';
import 'package:diyar_app/feature/home/model/announcements_response_model.dart';
import 'package:diyar_app/feature/home/view/widgets/announcement_media_thumbnail.dart';
import 'package:diyar_app/feature/home/view/widgets/image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../helpers/test_app.dart';

const _videoId = 'dQw4w9WgXcQ';
const _watchUrl = 'https://www.youtube.com/watch?v=$_videoId';
const _imageUrl = 'https://diyar.example.com/storage/41/pool.jpg';
const _thumbnailUrl = 'https://img.youtube.com/vi/$_videoId/hqdefault.jpg';

Announcement _withVideo({String image = ''}) => Announcement(
  id: 7,
  title: 'Pool reopening',
  url: image,
  rawYoutubeUrl: _watchUrl,
  rawYoutubeVideoId: _videoId,
);

void main() {
  group('Announcement.fromJson', () {
    test('reads the YouTube fields', () {
      final a = Announcement.fromJson({
        'id': 7,
        'title': 'Pool reopening',
        'description': 'The pool reopens on Monday at 8 am.',
        'url': _imageUrl,
        'youtube_url': _watchUrl,
        'youtube_video_id': _videoId,
      });
      expect(a.youtubeVideoId, _videoId);
      expect(a.youtubeUrl, _watchUrl);
      expect(a.imageUrl, _imageUrl);
      expect(a.hasVideo, isTrue);
      expect(a.youtubeThumbnailUrl, _thumbnailUrl);
      // The announcement's own image wins as the poster.
      expect(a.posterUrl, _imageUrl);
    });

    test('treats "" as no media', () {
      final a = Announcement.fromJson({
        'id': 6,
        'title': 'Office closed on Friday',
        'description': null,
        'url': '',
        'youtube_url': '',
        'youtube_video_id': '',
      });
      expect(a.youtubeVideoId, isNull);
      expect(a.youtubeUrl, isNull);
      expect(a.imageUrl, isNull);
      expect(a.hasVideo, isFalse);
      expect(a.youtubeThumbnailUrl, isNull);
      expect(a.posterUrl, isNull);
    });

    test('copes with a backend that does not send the fields yet', () {
      final a = Announcement.fromJson({'id': 1, 'title': 'Old', 'url': ''});
      expect(a.hasVideo, isFalse);
    });

    test('falls back to the YouTube thumbnail when there is no image', () {
      final a = Announcement.fromJson({
        'id': 8,
        'title': 'Video only',
        'url': '',
        'youtube_url': _watchUrl,
        'youtube_video_id': _videoId,
      });
      expect(a.posterUrl, _thumbnailUrl);
    });
  });

  group('AnnouncementMediaThumbnail', () {
    Future<void> pumpThumb(WidgetTester tester, Announcement a) =>
        pumpLocalized(
          tester,
          SizedBox(
            height: 160,
            width: 300,
            child: AnnouncementMediaThumbnail(announcement: a),
          ),
          // The network-image placeholder shimmers forever, so never settle.
          settle: false,
        );

    testWidgets('badges announcements that have a video', (tester) async {
      await pumpThumb(tester, _withVideo(image: _imageUrl));
      expect(find.text('Video'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('uses the YouTube thumbnail when there is no image', (
      tester,
    ) async {
      await pumpThumb(tester, _withVideo());
      final image = tester.widget<CustomCachedNetworkImage>(
        find.byType(CustomCachedNetworkImage),
      );
      expect(image.imageUrl, _thumbnailUrl);
    });

    testWidgets('no badge without a video', (tester) async {
      await pumpThumb(
        tester,
        Announcement(id: 1, title: 't', url: _imageUrl, rawYoutubeUrl: ''),
      );
      expect(find.text('Video'), findsNothing);
    });
  });

  group('AnnouncementImagePreviewScreen', () {
    Future<void> pumpScreen(WidgetTester tester, Announcement a) =>
        pumpLocalized(
          tester,
          AnnouncementImagePreviewScreen(announcement: a),
          wrapInScaffold: false,
          settle: false,
        );

    testWidgets('shows image, text and video as three separate blocks', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        Announcement(
          id: 7,
          title: 'Pool reopening',
          description: 'The pool reopens on Monday at 8 am.',
          url: _imageUrl,
          rawYoutubeUrl: _watchUrl,
          rawYoutubeVideoId: _videoId,
        ),
      );

      expect(find.text('Pool reopening'), findsOneWidget);
      expect(find.text('The pool reopens on Monday at 8 am.'), findsOneWidget);
      expect(find.byType(YoutubePoster), findsOneWidget);

      // The announcement image keeps its own block; the player falls back to
      // YouTube's thumbnail so the same picture isn't shown twice.
      final urls = tester
          .widgetList<CustomCachedNetworkImage>(
            find.byType(CustomCachedNetworkImage),
          )
          .map((image) => image.imageUrl)
          .toList();
      expect(urls, containsAll(<String>[_imageUrl, _thumbnailUrl]));
    });

    testWidgets('no video section when there is no video', (tester) async {
      await pumpScreen(
        tester,
        Announcement(id: 6, title: 'Office closed', url: _imageUrl),
      );

      expect(find.byType(YoutubePoster), findsNothing);
      expect(find.text('Video'), findsNothing);
    });

    testWidgets('a video-only announcement still reads top to bottom', (
      tester,
    ) async {
      await pumpScreen(tester, _withVideo());

      expect(find.text('Pool reopening'), findsOneWidget);
      expect(find.byType(YoutubePoster), findsOneWidget);
      final urls = tester
          .widgetList<CustomCachedNetworkImage>(
            find.byType(CustomCachedNetworkImage),
          )
          .map((image) => image.imageUrl)
          .toList();
      expect(urls, <String>[_thumbnailUrl]);
    });
  });

  group('announcementPlayerParams', () {
    test('sends no origin, so YouTube does not refuse the embed', () {
      final map = announcementPlayerParams('en').toMap();
      // An origin that isn't the embed host is what caused error 152/153.
      expect(map.containsKey('origin'), isFalse);
      expect(map.containsKey('widget_referrer'), isFalse);
    });

    test('asks YouTube for its controls and fullscreen button', () {
      final map = announcementPlayerParams('ar').toMap();
      expect(map['controls'], 1);
      expect(map['fs'], 1);
      expect(map['hl'], 'ar');
    });
  });

  group('AnnouncementYoutubePlayer', () {
    testWidgets('shows the poster and builds no player until asked', (
      tester,
    ) async {
      await pumpLocalized(
        tester,
        const Center(
          child: AnnouncementYoutubePlayer(
            videoId: _videoId,
            watchUrl: _watchUrl,
            posterUrl: _imageUrl,
          ),
        ),
        settle: false,
      );

      expect(find.text('Watch video'), findsOneWidget);
      expect(find.byType(YoutubePoster), findsOneWidget);
      // No WebView is created before the tap.
      expect(find.byType(YoutubePlayer), findsNothing);
    });
  });

  group('YoutubeUnavailableView', () {
    testWidgets('offers YouTube and a retry', (tester) async {
      var opened = 0;
      var retried = 0;
      await pumpLocalized(
        tester,
        SizedBox(
          height: 220,
          width: 390,
          child: YoutubeUnavailableView(
            onOpenInYoutube: () => opened++,
            onRetry: () => retried++,
          ),
        ),
        settle: false,
      );

      expect(find.text("This video can't be played here"), findsOneWidget);

      await tester.tap(find.text('Open in YouTube'));
      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(opened, 1);
      expect(retried, 1);
    });
  });
}
