import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omegle_clone/ui/screens/call/controls/call_control_state_provider.dart';

class CallControlView extends HookConsumerWidget {
  const CallControlView({super.key});

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(height: 5),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('building call control view');
    // reason why useAnimationController hook is initialized outside useEffect is because
    // type mismatch between hooks error is thrown if useAnimationController is used inside useEffect
    AnimationController _animationController = useAnimationController(
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 150),
    );

    var callControlStateProviderRef =
        ref.read(callControlStateProvider.notifier);

    useEffect(() {
      callControlStateProviderRef
          .initializeAnimationController(_animationController);

      return null;
    }, []);

    return Opacity(
      opacity: ref.watch(callControlStateProvider).tickerValue,
      child: Transform.scale(
        scale: ref.watch(callControlStateProvider).tickerValue,
        child: Container(
          margin: EdgeInsets.only(bottom: 25),
          padding: EdgeInsets.symmetric(vertical: 15),
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black38,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _controlButton(
                icon: ref.watch(callControlStateProvider).isMuted
                    ? CupertinoIcons.mic_off
                    : CupertinoIcons.mic,
                label: ref.watch(callControlStateProvider).isMuted
                    ? 'Unmute'
                    : 'Mute',
                onTap: callControlStateProviderRef.toggleMute,
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  width: 15,
                  thickness: 1.5,
                ),
              ),
              _controlButton(
                icon: CupertinoIcons.shuffle,
                label: 'Skip',
                onTap: ref.read(callControlStateProvider.notifier).searchNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
