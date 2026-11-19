import 'package:flutter/material.dart';

/// Human emotional needs that guide real-world self-care and grounding.
enum NeedType {
  calm(
    label: 'Calm',
    icon: Icons.spa_outlined,
    description: 'Quiet the noise and ground yourself',
  ),
  energy(
    label: 'Energy',
    icon: Icons.bolt_rounded,
    description: 'Shake off sluggishness and awaken',
  ),
  focus(
    label: 'Focus',
    icon: Icons.center_focus_strong_rounded,
    description: 'Quiet distractions and do one thing',
  ),
  connection(
    label: 'Connection',
    icon: Icons.chat_bubble_outline_rounded,
    description: 'Reach out and feel tethered to someone',
  ),
  breakTime(
    label: 'A break',
    icon: Icons.coffee_outlined,
    description: 'Give yourself permission to pause',
  ),
  clearHead(
    label: 'Clear my head',
    icon: Icons.cleaning_services_rounded,
    description: 'Unpack racing thoughts and mental clutter',
  ),
  feelBetter(
    label: 'Feel a little better',
    icon: Icons.favorite_outline_rounded,
    description: 'Gentle warmth and low-demand comfort',
  ),
  release(
    label: 'To release / vent',
    icon: Icons.water_drop_outlined,
    description: 'Let out pent-up tears, tension or heavy feelings',
  ),
  comfort(
    label: 'Warmth & comfort',
    icon: Icons.volunteer_activism_outlined,
    description: 'A cozy blanket, hot tea, and gentle softness',
  ),
  rest(
    label: 'Deep rest',
    icon: Icons.bedtime_outlined,
    description: 'Lie down, close your eyes, and demand nothing',
  ),
  freshAir(
    label: 'Fresh air & space',
    icon: Icons.park_outlined,
    description: 'Step outside, feel the breeze, and look at the sky',
  ),
  reassurance(
    label: 'Gentle reassurance',
    icon: Icons.shield_outlined,
    description: 'Remind yourself that this moment will pass',
  ),
  unplug(
    label: 'Digital quiet',
    icon: Icons.do_not_disturb_on_total_silence_rounded,
    description: 'Step away from screens, feeds and notifications',
  ),
  movement(
    label: 'Gentle movement',
    icon: Icons.directions_walk_rounded,
    description: 'Stretch, walk slowly, or shake off physical stiffness',
  );

  final String label;
  final IconData icon;
  final String description;

  const NeedType({
    required this.label,
    required this.icon,
    required this.description,
  });
}

/// Available time context for realistic micro-actions.
enum ContextTime {
  fiveMin(label: '5 min', minutes: 5),
  tenMin(label: '10 min', minutes: 10),
  twentyMin(label: '20 min', minutes: 20),
  thirtyPlus(label: '30+ min', minutes: 30);

  final String label;
  final int minutes;

  const ContextTime({required this.label, required this.minutes});
}

/// Physical location context to adapt action feasibility.
enum ContextLocation {
  home(label: 'Home', icon: Icons.home_outlined),
  work(label: 'Work', icon: Icons.work_outline_rounded),
  college(label: 'College / School', icon: Icons.school_outlined),
  outside(label: 'Outside', icon: Icons.park_outlined);

  final String label;
  final IconData icon;

  const ContextLocation({required this.label, required this.icon});
}

/// A concrete, low-friction action tailored to emotional state and context.
class MicroAction {
  final String id;
  final String title;
  final String subtitle;
  final List<String> steps;
  final int suggestedMinutes;
  final NeedType need;
  final IconData icon;

  const MicroAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.steps,
    required this.suggestedMinutes,
    required this.need,
    required this.icon,
  });
}
