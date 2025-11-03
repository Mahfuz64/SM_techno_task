import 'package:video_player/video_player.dart'; 
import 'package:flutter/material.dart';
import 'package:on_boarding_app/constants/app_constants.dart';


class OnboardingPageContent extends StatefulWidget {
  final String videoPath;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.videoPath,
    required this.title,
    required this.description,
  });

  @override
  State<OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<OnboardingPageContent> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath);
    
    
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true); 
      _videoController.setVolume(5.0);    
      _videoController.play();            
      setState(() {}); 
    }).catchError((error) {
       
       print('Error loading video: $error');
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && _videoController.value.isInitialized) {
                    
                    return AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: FittedBox(
                        fit: BoxFit.fill, 
                        child: SizedBox(
                          width: _videoController.value.size.width,
                          height: _videoController.value.size.height,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error, color: Colors.red));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: AppConstants.primaryColor),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        
        
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppConstants.headingStyle.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.description,
                  style: AppConstants.subheadingStyle,
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}