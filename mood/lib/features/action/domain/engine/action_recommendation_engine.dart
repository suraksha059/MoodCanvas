import 'package:flutter/material.dart';
import '../models/micro_action.dart';

/// Pure Dart rule-based micro-action recommendation engine.
/// Provides realistic, low-friction, mature actions tailored to emotional needs.
class ActionRecommendationEngine {
  ActionRecommendationEngine._();

  static final List<MicroAction> _catalog = [
    // 1. Clear Head
    const MicroAction(
      id: 'brain_dump',
      title: '10-Minute Brain Dump',
      subtitle: 'Unload racing thoughts onto paper without organizing them.',
      steps: [
        'Grab a blank scrap of paper or open a raw notes document.',
        'Write continuously for 5–10 minutes: worries, to-dos, fragments.',
        'Do NOT edit or organize it. The goal is simply to get it out of your head.',
        'When finished, take a deep breath and set the paper aside.',
      ],
      suggestedMinutes: 10,
      need: NeedType.clearHead,
      icon: Icons.edit_note_rounded,
    ),
    const MicroAction(
      id: 'clear_one_surface',
      title: 'Clear Just One Surface',
      subtitle: 'Restore a pocket of visual order to ease mental clutter.',
      steps: [
        'Pick one small immediate surface: your desk, bedside table, or counter.',
        'Remove trash, return mugs, and put stray items back in place.',
        'Wipe the surface clean with a cloth or damp paper towel.',
        'Step back and appreciate having one clear space to rest your eyes on.',
      ],
      suggestedMinutes: 5,
      need: NeedType.clearHead,
      icon: Icons.cleaning_services_outlined,
    ),

    // 2. Connection
    const MicroAction(
      id: 'low_pressure_message',
      title: 'Send a Low-Pressure Note',
      subtitle: 'Reach out to someone you care about without demanding a long conversation.',
      steps: [
        'Think of one person you’d like to hear from or haven’t spoken to in a while.',
        'Send a simple, warm message: "Hey, thinking of you today! Hope your week is gentle."',
        'Put your phone down. There is zero pressure for an immediate reply.',
      ],
      suggestedMinutes: 5,
      need: NeedType.connection,
      icon: Icons.mark_email_read_outlined,
    ),
    const MicroAction(
      id: 'share_small_moment',
      title: 'Share a Small Glimpse',
      subtitle: 'Connect over a tiny, real piece of your day.',
      steps: [
        'Take a photo of something unassuming around you: a tree, your coffee, the sky.',
        'Send it to a friend or family member with a short caption: "Looked peaceful today."',
        'Allow yourself to feel anchored to someone in this moment.',
      ],
      suggestedMinutes: 5,
      need: NeedType.connection,
      icon: Icons.photo_camera_outlined,
    ),

    // 3. Calm
    const MicroAction(
      id: 'physiological_sigh',
      title: 'Physiological Sighs',
      subtitle: 'The fastest biological method to downshift your nervous system.',
      steps: [
        'Sit back comfortably and let your shoulders drop.',
        'Take two quick breaths in through your nose (deep inhale, then a quick top-up).',
        'Exhale slowly and fully through your mouth with a soft sigh.',
        'Repeat this cycle 4 to 5 times at your own pace.',
      ],
      suggestedMinutes: 5,
      need: NeedType.calm,
      icon: Icons.air_rounded,
    ),
    const MicroAction(
      id: 'hand_on_heart',
      title: 'Hand on Chest Grounding',
      subtitle: 'Physical reassurance to soothe heightened vigilance.',
      steps: [
        'Place your right palm firmly over the center of your chest.',
        'Notice the warmth of your hand and the steady rise and fall of your breathing.',
        'Say softly to yourself: "I am safe in this quiet moment. I can take it one breath at a time."',
        'Stay here with your eyes softened for 3 minutes.',
      ],
      suggestedMinutes: 5,
      need: NeedType.calm,
      icon: Icons.favorite_border_rounded,
    ),

    // 4. Energy
    const MicroAction(
      id: 'water_and_fresh_air',
      title: 'Cold Water & Fresh Air',
      subtitle: 'Reset physiological fatigue with natural sensory inputs.',
      steps: [
        'Pour a full, cold glass of water and drink it steadily.',
        'Open the nearest window wide, or step outside onto a balcony or doorstep.',
        'Let the cold air hit your face and take 3 deep, expansive breaths.',
      ],
      suggestedMinutes: 5,
      need: NeedType.energy,
      icon: Icons.water_drop_outlined,
    ),
    const MicroAction(
      id: 'shoulder_and_spine_release',
      title: 'Shoulder & Spine Release',
      subtitle: 'Awaken sluggish circulation through gentle mobility.',
      steps: [
        'Stand up and shake out your hands and wrists.',
        'Roll your shoulders backward 10 times in wide, slow circles.',
        'Interlace your fingers, reach your arms straight toward the ceiling, and inhale deeply.',
        'Gently fold forward at the hips and let your head hang loose for 15 seconds.',
      ],
      suggestedMinutes: 5,
      need: NeedType.energy,
      icon: Icons.accessibility_new_rounded,
    ),

    // 5. Focus
    const MicroAction(
      id: 'ten_minute_single_task',
      title: 'The 10-Minute Single Task',
      subtitle: 'Shrink work down to a single, non-negotiable container.',
      steps: [
        'Choose just ONE tiny task you’ve been avoiding or needing to finish.',
        'Put your phone in another room or face down on silent.',
        'Work on that single task for exactly 10 minutes. When the timer rings, you have full permission to stop.',
      ],
      suggestedMinutes: 10,
      need: NeedType.focus,
      icon: Icons.timer_outlined,
    ),
    const MicroAction(
      id: 'tab_diet',
      title: 'Close All Distraction Tabs',
      subtitle: 'Reduce digital cognitive drag.',
      steps: [
        'Bookmark your open tabs if needed, then close everything you aren’t actively using.',
        'Keep open only the single document or page required right now.',
        'Take a quiet moment to notice how much lighter your screen feels.',
      ],
      suggestedMinutes: 5,
      need: NeedType.focus,
      icon: Icons.tab_unselected_rounded,
    ),

    // 6. A Break
    const MicroAction(
      id: 'complete_screen_break',
      title: 'Step Away from Every Screen',
      subtitle: 'Genuine rest that doesn’t involve digital stimulation.',
      steps: [
        'Turn off your monitor and place your phone away from you.',
        'Sit in a comfortable chair or lie flat on the floor.',
        'Close your eyes or look out a window at something distant for 7 minutes.',
        'You do not have to meditate. Just exist without inputs.',
      ],
      suggestedMinutes: 10,
      need: NeedType.breakTime,
      icon: Icons.phonelink_erase_rounded,
    ),
    const MicroAction(
      id: 'warm_drink_ritual',
      title: 'Warm Drink Ritual',
      subtitle: 'A grounding physical sequence that invites mindful presence.',
      steps: [
        'Prepare a warm cup of tea, coffee, or hot lemon water.',
        'Pay attention to the sound of water heating, the aroma, and the steam rising.',
        'Hold the warm mug in both hands for a full minute before taking your first sip.',
      ],
      suggestedMinutes: 10,
      need: NeedType.breakTime,
      icon: Icons.local_cafe_outlined,
    ),

    // 7. Feel Better
    const MicroAction(
      id: 'soft_comfort_nest',
      title: 'Comfort Nest & Low Demand',
      subtitle: 'Provide gentle warmth when things feel heavy.',
      steps: [
        'Put on your softest jumper, thick socks, or wrap up in a blanket.',
        'Lower the bright ceiling lights or turn on a warm side lamp.',
        'Remind yourself: "I do not have to be remarkable or productive right now. Getting through today is enough."',
      ],
      suggestedMinutes: 10,
      need: NeedType.feelBetter,
      icon: Icons.weekend_outlined,
    ),
    const MicroAction(
      id: 'kind_word_to_self',
      title: 'One Kind Thought',
      subtitle: 'Counter self-criticism with simple, honest acknowledgment.',
      steps: [
        'Notice if you are being hard on yourself for feeling down or unproductive.',
        'Take one deep breath and silently say: "This is a hard moment, but it’s just a moment. I am doing the best I can."',
        'Give yourself the same grace you would extend to a friend.',
      ],
      suggestedMinutes: 5,
      need: NeedType.feelBetter,
      icon: Icons.sentiment_satisfied_alt_rounded,
    ),

    // 8. Release / Vent
    const MicroAction(
      id: 'unfiltered_vent_page',
      title: 'The Unfiltered Vent Page',
      subtitle: 'Pour out the frustration or grief without holding back.',
      steps: [
        'Grab a piece of paper or open a blank notes page.',
        'Write down everything you wish you could say or scream, without filter.',
        'Nobody else is going to see this. Let the raw emotion out.',
        'When done, tear it up or delete it to symbolize releasing the weight.',
      ],
      suggestedMinutes: 5,
      need: NeedType.release,
      icon: Icons.water_drop_outlined,
    ),
    const MicroAction(
      id: 'permission_to_cry',
      title: 'Safe Space to Let Go',
      subtitle: 'Allow tears or heavy sighs without judging yourself.',
      steps: [
        'Go somewhere private—your room, a quiet corner, or bathroom.',
        'Wrap your arms around yourself or hold a pillow to your chest.',
        'Give yourself complete permission: tears are just your body releasing tension.',
        'Wash your face with cold water whenever you feel ready.',
      ],
      suggestedMinutes: 10,
      need: NeedType.release,
      icon: Icons.favorite_border_rounded,
    ),

    // 9. Warmth & Comfort
    const MicroAction(
      id: 'warm_compress_and_rest',
      title: 'Warm Compress & Softness',
      subtitle: 'Physiologically soothe your nervous system through gentle warmth.',
      steps: [
        'Warm a damp washcloth or hold a hot water bottle / warm mug.',
        'Place it gently over your eyes, forehead, or chest.',
        'Wrap up in your softest blanket and close your eyes for 5 minutes.',
      ],
      suggestedMinutes: 10,
      need: NeedType.comfort,
      icon: Icons.volunteer_activism_outlined,
    ),

    // 10. Deep Rest
    const MicroAction(
      id: 'horizontal_recharge',
      title: 'The 10-Minute Horizontal Rest',
      subtitle: 'Lie down completely flat with zero expectations.',
      steps: [
        'Lie flat on your bed or floor with your arms by your sides.',
        'Turn your phone face-down and set a gentle 10-minute timer.',
        'Unclench your teeth, soften your belly, and let gravity hold you up.',
      ],
      suggestedMinutes: 10,
      need: NeedType.rest,
      icon: Icons.bedtime_outlined,
    ),

    // 11. Fresh Air & Space
    const MicroAction(
      id: 'step_outside_breathe',
      title: 'Step Outside & Look at the Sky',
      subtitle: 'Reset sensory overwhelm with natural horizons.',
      steps: [
        'Step outside your front door or open a large window wide.',
        'Look up at the clouds or trees—allow your gaze to soften into the distance.',
        'Take 5 deep breaths of fresh outdoor air before stepping back inside.',
      ],
      suggestedMinutes: 5,
      need: NeedType.freshAir,
      icon: Icons.park_outlined,
    ),

    // 12. Gentle Reassurance
    const MicroAction(
      id: 'letter_from_tomorrow',
      title: 'A Reassuring Truth',
      subtitle: 'Remind yourself that today does not define your life.',
      steps: [
        'Take a slow, deep breath in and let your shoulders drop.',
        'Repeat silently: "I am having a hard moment, but I am safe. I do not need to solve everything today."',
        'Remember that you have navigated 100% of your hardest days before this one.',
      ],
      suggestedMinutes: 5,
      need: NeedType.reassurance,
      icon: Icons.shield_outlined,
    ),

    // 13. Digital Quiet
    const MicroAction(
      id: 'twenty_minute_unplug',
      title: '20-Minute Digital Quiet',
      subtitle: 'Put the screen away and give your nervous system silence.',
      steps: [
        'Put your phone in another room or turn on Do Not Disturb.',
        'Do something tangible with your hands: fold clothes, sketch, drink water.',
        'Notice the quiet stillness when notifications are paused.',
      ],
      suggestedMinutes: 20,
      need: NeedType.unplug,
      icon: Icons.do_not_disturb_on_total_silence_rounded,
    ),

    // 14. Gentle Movement
    const MicroAction(
      id: 'gentle_slow_stretch',
      title: 'Gentle Whole-Body Stretch',
      subtitle: 'Release tension stored in tight joints and muscles.',
      steps: [
        'Stand up slowly and reach your arms overhead toward the ceiling.',
        'Gently lean side to side, opening up your ribcage.',
        'Roll your neck and ankles in slow, deliberate circles.',
        'Shake out your hands and exhale fully.',
      ],
      suggestedMinutes: 5,
      need: NeedType.movement,
      icon: Icons.directions_walk_rounded,
    ),
  ];

  /// Returns recommended actions for the given need and context.
  static List<MicroAction> getRecommendations({
    required NeedType need,
    ContextTime? time,
    ContextLocation? location,
  }) {
    final matchingNeed = _catalog.where((a) => a.need == need).toList();

    if (matchingNeed.isEmpty) {
      return [_catalog.first];
    }

    return matchingNeed;
  }
}
