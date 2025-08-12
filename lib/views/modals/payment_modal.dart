import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/views/application_page.dart';
import 'package:provider/provider.dart';
import '../../viewModel/payment_view_model.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/response_models/meetup.dart';

const kPrimaryBrown = Color.fromARGB(255, 146, 61, 5); // #923D05
const kCream = Color.fromARGB(255, 255, 247, 240); // #FFF7F0
const kBrownDark = Color.fromARGB(255, 39, 24, 15); // #27180F
const kBrownMid = Color.fromARGB(255, 157, 113, 37); // #9D7125
const kBrownLight = Color.fromARGB(255, 75, 31, 11); // #4B1F0B

class PaymentModal extends StatefulWidget {
  final Meetup meetup;
  final User user;
  const PaymentModal({super.key, required this.meetup, required this.user});

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  NavigationService get _navigationService => locator<NavigationService>();
  int? _selectedAmount;
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<PaymentViewModel>()
          .initializePaymets(widget.meetup, widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PaymentViewModel>();
    const fixedAmounts = [500, 1000];

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [kBrownDark, Colors.black],
            center: Alignment.topLeft,
            radius: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => _showHelpDialog(context, widget.meetup),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 30,
                      )),
                )
              ],
            ),
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '🐶 Support Adoption',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kCream,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '⚡ 50% of your fee helps animal shelters!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(fixedAmounts.length, (idx) {
                              final amount = fixedAmounts[idx];
                              final isSelected = _selectedAmount == amount;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color:
                                                kPrimaryBrown.withOpacity(0.55),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: ChoiceChip(
                                  selected: isSelected,
                                  label: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('₨ $amount'),
                                      if (amount == 1000)
                                        const Text('Fast‑Track',
                                            style: TextStyle(fontSize: 10)),
                                    ],
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected ? kCream : kPrimaryBrown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  selectedColor: kPrimaryBrown,
                                  backgroundColor: kCream,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedAmount = amount;
                                      _customController.clear();
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _customController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: kCream),
                            decoration: InputDecoration(
                              hintText: 'Custom Amount',
                              hintStyle: const TextStyle(color: Colors.white70),
                              prefixText: '₨ ',
                              prefixStyle:
                                  const TextStyle(color: kPrimaryBrown),
                              filled: true,
                              fillColor: Colors.black12,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (_) =>
                                setState(() => _selectedAmount = null),
                          ),
                          const SizedBox(height: 28),
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                viewModel.isBusy
                                    ? Colors.grey.shade700
                                    : kPrimaryBrown,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              shadowColor:
                                  MaterialStateProperty.all(kPrimaryBrown),
                              elevation: MaterialStateProperty.all(10),
                            ),
                            onPressed: viewModel.isBusy
                                ? null
                                : () async {
                                    final amount = _selectedAmount ??
                                        int.tryParse(_customController.text) ??
                                        0;
                                    if (amount < 500) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Amount should be at least ₨ 500'),
                                        ),
                                      );
                                      return;
                                    }
                                    await viewModel.pay(amount);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (viewModel.isBusy)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Center(
                                              child: FadingCircularDots(
                                            count: 10,
                                            radius: 20,
                                            dotRadius: 4,
                                            duration:
                                                Duration(milliseconds: 1200),
                                          )),
                                        )),
                                  ),
                                const Text(
                                  'Pay Now',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: kCream),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  void _showHelpDialog(BuildContext context, Meetup meetup) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'HelpDialog',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                width: MediaQuery.of(ctx).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kBrownLight, kBrownDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white24),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryBrown.withOpacity(0.7),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '❔ Need Help with Payment?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kCream,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'If you are unable to pay , you can request a favour to remove you application fee',
                        style: TextStyle(fontSize: 15, color: kCream),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '⚠️ Warning: Submitting forged documents or providing false information may result in a permanent ban.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryBrown,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 10,
                            ),
                            onPressed: () {
                              _navigationService.pushNamed(Routes.application,
                                  data: meetup, args: TransitionType.slideTop);
                              // 🔁 Replace this with your actual route
                            },
                            child: const Text(
                              'Application Page',
                              style: TextStyle(color: kCream, fontSize: 16),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: kCream, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        return Transform.scale(
          scale: anim.value,
          child: Opacity(
            opacity: anim.value,
            child: child,
          ),
        );
      },
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
