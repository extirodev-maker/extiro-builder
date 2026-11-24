import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'extiro_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob Demo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;
  int _rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadRewardedAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: ExtiroConfig.admobBannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: ExtiroConfig.admobRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          setState(() {
            _isRewardedLoaded = true;
          });
          _setRewardedAdCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          setState(() {
            _isRewardedLoaded = false;
          });
        },
      ),
    );
  }

  void _setRewardedAdCallbacks() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _loadRewardedAd();
      },
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          _rewardPoints += 10;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You earned \${reward.amount} reward points! Total: \$_rewardPoints')),
        );
      });
      _rewardedAd = null;
      setState(() {
        _isRewardedLoaded = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewarded ad is not ready yet. Please wait.')),
      );
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Demo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Reward Points',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$_rewardPoints',
                      style: TextStyle(fontSize: 36, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isRewardedLoaded ? _showRewardedAd : null,
              icon: const Icon(Icons.card_giftcard),
              label: Text(_isRewardedLoaded ? 'Watch Rewarded Ad (+10 Pts)' : 'Loading Ad...'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isBannerLoaded
          ? Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox.shrink(),
    );
  }
}
