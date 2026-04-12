import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/core/extensions/image_constants.dart';
import 'package:music_player/core/router/app_router.gr.dart';
import 'package:music_player/data/local/local_storage_service.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  // TODO: Complete onboarding logic
                  await LocalStorage.setVisited();
                  if (context.mounted) {
                    context.router.replace(const HomeRoute());
                  }
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingItems.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  final item = onboardingItems[index];

                  return Column(
                    children: [
                      // Image Area - Takes MAXIMUM space (but not full screen)
                      Expanded(
                        flex: 5, // Gives more space to image
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ), // No left/right padding
                          child: Image.asset(
                            item.image,
                            fit: BoxFit
                                .contain, // Use 'cover' if you want to fill completely
                            alignment: Alignment.center,
                          ),
                        ),
                      ),

                      // Text Content Area (Below the image)
                      const Gap(0),
                      Expanded(
                        flex: 3, // Adjust this ratio if needed (image vs text)
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                item.title,
                                style: context.textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Gap(16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Text(
                                item.description,
                                style: context.textTheme.titleMedium?.copyWith(
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Next / Get Started Button (Below the text)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (currentPage == onboardingItems.length - 1) {
                                // _completeOnboarding();
                                await LocalStorage.setVisited();
                                if (context.mounted) {
                                  context.router.replace(const HomeRoute());
                                }
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              currentPage == onboardingItems.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// onboarding_data.dart
class OnboardingItem {
  final String title;
  final String description;
  final String image; // Can be asset path or Lottie JSON

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

// Example data
final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    title: "Your Music, All in One Place",
    description: "Access all your offline songs, neatly organized.",
    image: AssetImages.introFeature2,
  ),
  OnboardingItem(
    title: "Stream Anytime, Anywhere",
    description: "Discover and stream millions of songs instantly.",
    image: AssetImages.introFeature2,
  ),
  OnboardingItem(
    title: "Smart Picks & Playlists",
    description: "Enjoy recommendations and create your playlists.",
    image: AssetImages.introFeature3,
  ),
];
