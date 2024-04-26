=== intro_dorm

Scene: P_Dorm
Appears: P P_Bed
Appears: Myo R_Bed
Appears: AlarmClock P_AC
Act: AlarmClock alarm
Act: P pajamas
Sound: alarm_beeping
-> alarm ->
Thought: !!!
Controls: yes
Thought: I need to turn off my alarm!
Thought: I can use WASD or the arrow keys to move, and press the spacebar to interact.

-> needs_to_turn_off_alarm
= needs_to_turn_off_alarm

* [Interact: AlarmClock]
    Sound stop: alarm_beeping
    Act: AlarmClock normal
    Thought: Phew...
    -> dorm.walkabout
* [Talk: Myo]
    Thought: They look peaceful...
    Thought: I need to turn off my alarm clock so I don't wake them up.
* [Exit: South]
    Thought: I can't leave yet!
    Thought: My alarm clock would just keep going all day!
* [Interact: P_Desk]
    Thought: I can't focus on reading with all this noise!
- -> needs_to_turn_off_alarm

===dorm
Scene: P_Dorm
Enters: P
->walkabout
= walkabout

* [Interact: AlarmClock]
    Thought: Alarm clocks have a tough job.
    Thought: We're always mad at them in the morning because we want to sleep a little longer, even though we're the ones who set the alarm.
* { TURNS_SINCE(->alarm) < 10 }[Talk: Myo]
    P: Hey, sorry about the noise.
    Myo: No problem...
    ->myo_says_notes
* (myo_says_notes) [Talk: Myo]
    Myo: I'm not doing so well... Do you mind taking notes for me today?
    P: No problem!
    Myo: Thanks so much, my notebook is on my desk.
    Thought Myo: Sick on the first day..!
* (get_letter_from_desk) [Interact: P_Desk]
    Controls: no
    Thought: There's a note:
    -> notes.intro_note_from_mom ->
    Controls: yes
+ [Interact: P_Desk]
    Controls: no
    Thought: I'll look at my notes...
    -> notes.my_notes ->
    - -
    Controls: yes
* {!myo_says_notes} [Interact: R_Desk]
    Thought: This is Myo's desk, I shouldn't snoop.
* {myo_says_notes} [Interact: R_Desk]
    Thought: I found Myo's notebook!
    Thought: Let's take a look inside...
    Controls: no
    -> notes.myos_notebook ->
    Controls: yes
+ [Interact: R_Desk]
    Controls: no
    -> notes.myos_notebook ->
    Controls: yes
+ [Exit: South]
    Controls: no
    Thought: Should I leave for now?
    + + [Dialogue: Leave]
        ~ allowed_to_visit -= Dorm
        -> hallway
    + + [Dialogue: Do not]
    - -
    Controls: yes
- ->walkabout
    
-> TODO
