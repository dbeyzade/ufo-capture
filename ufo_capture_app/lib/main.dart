import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/subscription_screen.dart';
import 'services/subscription_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize subscription service
  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();
  
  runApp(
    ChangeNotifierProvider.value(
      value: subscriptionService,
      child: const UFOCaptureApp(),
    ),
  );
}

class UFOCaptureApp extends StatelessWidget {
  const UFOCaptureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UFO Capture',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFO Capture'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.visibility,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 24),
            const Text(
              'UFO Capture',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Gökyüzünü izleyin, hareketi tespit edin ve anomalileri otomatik olarak kaydedin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.card_membership),
              label: const Text('Abonelik Özelliklerimi Göster'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<SubscriptionService>(
              builder: (context, subscriptionService, child) {
                final subscription = subscriptionService.currentSubscription;
                if (subscription != null) {
                  return Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Mevcut Plan: ${subscription.tierDisplayName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subscription.isActive
                                ? 'Aktif - ${subscription.daysRemaining} gün kaldı'
                                : 'Aktif Değil',
                            style: TextStyle(
                              color: subscription.isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
