=== Intro
= enter
Scene: pdorm
Appears: P door.exit
Appears: R rbed
Act: R sleep_sick
Controls: no
Act: P sulk
Move P: door.enter
Controls: yes

-> walkabout

= fix_washcloth
Act: P normal
Controls: no;; Thought: Their washcloth is pretty warm...
Move P: door.exit
Hide: P;; Sound: hinge
Sound: running_sink
Show: P;; Sound: hinge
Move P: by_rbed
Sound: rustle;; Wait: 0.5
Act: R sleep_sick_cool_towel
Controls: yes
Thought: That's better.
->->

= walkabout

* {not got_notebook} [Exit: door]
    Thought: I don't {~|think I }need to {~leave|go out|go anywhere} {~yet|right now}.
+ (inspect_bed) {inspect_bed < 4} Inspect: bed
    { stopping:
        - Thought: The bed seems tolerable.
        - Thought: It could definitely be a little softer.
        - Thought: More colorful, too.
        - Thought: I suppose it's as much as I could hope for, given the situation.
    }
+ (inspect_roommate) {inspect_roommate < 5} Inspect: roommate
    { stopping:
        - Thought: My roommate is fast asleep in their bed.
        - Thought: They have a washcloth on their forehead.
        - Thought: Maybe I should put on a mask?
        - -> fix_washcloth ->
        - Thought: I should let them sleep...
    }
+ (inspect_closet) {inspect_closet < 2} Inspect: closet
    { stopping:
        - Thought: My clothes are already here.
        - Thought: My wardrobe wasn't very big before, and the dress code here is so restrictive.
    }
+ (inspect_rdesk) {inspect_rdesk < 3 or not got_notebook} Inspect: rdesk
    { stopping:
        - Thought: The desk is immaculate. It isn't mine, of course.
        - Thought: Their utensils are neatly stowed in a basket, and they have... a rolodex, in this day and age?
        - { not letter_roommate_is_sick: Thought: Their notebook is so nice, too... }
            { letter_roommate_is_sick: 
                Thought: I found their notebook!
                -> maybe_take_notebook ->
            }
        - { letter_roommate_is_sick and not got_notebook:
                Thought: They said I could borrow their notebook.
                -> maybe_take_notebook ->
            }
            { not letter_roommate_is_sick: Thought: I shouldn't snoop. }
    }
+ (inspect_desk) {inspect_desk < 2} Inspect: desk
    { stopping:
        - Thought: There's a few papers on my desk.
            Get letter: initial_letter_from_mom
            -> initial_letter_from_mom ->
        - Get letter: note_from_principal
            Thought: There's also a note.
            -> note_from_principal ->
        - Get letter: letter_roommate_is_sick
            -> letter_roommate_is_sick ->
            Thought: That's all of the papers.
    }
+ -> done_in_room
- ->walkabout

= maybe_take_notebook
Controls: no
* [Dialogue: Take it]
    Thought: I'll handle it carefully.
    -> got_notebook ->
+ (procrastinated_on_taking_notebook) [Dialogue: Do not]
    Thought: I'll need it eventually, though.
-
Controls: yes
->->


= got_notebook
Get key: Notebook
Act: P normal

->->

= done_in_room
Wait: 3
Sound: school_bell
Thought: The bell's going off.
Thought: it's time for the assembly. #async

+ Exit: door
-

-> HallwayTransition -> IntroAssembly



