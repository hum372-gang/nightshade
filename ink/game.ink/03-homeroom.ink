LIST appears_in_homeroom = (Bri), (Cam), (Mya), (Tania), (Verica), (Willow), (Pet)

=== homeroom
Scene: Homeroom

Enters: P
{ appears_in_homeroom ? Bri: Enters: Bri Bri_Spot;; Act Bri: normal_north}
{ appears_in_homeroom ? Cam: Enters: Cam Cam_Spot;; Act Cam: normal_north}
{ appears_in_homeroom ? Mya: Enters: Mya Mya_Spot;; Act Mya: normal_north}
{ appears_in_homeroom ? Tania: Enters: Tania Tania_Spot;; Act Tania: normal_north}
{ appears_in_homeroom ? Verica: Enters: Verica Verica_Spot;; Act Verica: normal_north}
{ appears_in_homeroom ? Willow: Enters: Willow Willow_Spot;; Act Willow: normal_north}
{ appears_in_homeroom ? Pet: Enters: Pet Pet_Spot;; Act Pet: normal_north}

Appears: Teacher Podium;; Act Teacher: normal_south
Appears: Loudspeaker WallMount

->walkabout
= walkabout

* -> pre_quiz

= pre_quiz

* [Talk: Bri]
    Bri: What were we talking about?
* [Talk: Cam]
    Cam: That salad is so gross and makes me sick to my stomach.
* [Talk: Tania]
    Tania: I like trains.
* [Talk: Willow]
    Willow: Hi! I Like Shorts! They’re Comfy And Easy To Wear!
* [Talk: Mya]
    Mya: Why are we here? I hate school.
* [Talk: Viki]
    Verica: I don't knowww
* [Talk: Pet]
    Pet: Be quiet! Some of us are trying to learn, you know!
* [Talk: Teacher]
    Teacher: Good morning students, please sit down and listen to the announcements!
    Bri: I hate the announcements, they're always the same!
    Pet: Be quiet, so others can hear! Hey, raffle peasant, get in your seat before I...
+ [Interact: P_Seat]
    Controls: no
    Loudspeaker: Good morning and welcome, students of Nightshade Academy! I have a few announcements to make before you start your day.
    Thought Pet: The principal..!
    Loudspeaker: The volleyball team is looking for more players so make sure to tell the PE teacher if you’re interested. The art club is creating a new mural on the south side entrance. For lunch, we will be having crispy, chicken sandwiches, fresh fruit, and our famous Nightshade super green salad with our house made dressing.
    Teacher: Ok, I know everybody is new, so we’ll be doing icebreakers in the form of an intro quiz. Talk to those around you and gather your knowledge to answer some questions about the academy. Only come up to me when you’re Veeeeery sure that you know your stuff.
    Controls: yes
    -> ask_for_help
- -> pre_quiz

= ask_for_help

* [Talk: Bri]
    Bri: Ummm… All I know is that there are rumors that the headmistress was involved with the mob? Don’t say that too loud though, I think they're trying to keep it on the down-low.
    -> notes.headmistress_mob ->
* [Talk: Cam]
    Cam: Do you know about the graduation rate here? It’s 20 percent. Nobody knows where the people that don’t graduate go. Probably part of all the NDAs and stuff on the legal documents.
    -> notes.graduation_rate ->
* [Talk: Tania]
    Tania: I can’t believe they took my phone. They didn’t even let anyone know where the academy is located. Thanks to all the secrecy I can’t even send letters home.
    -> notes.secrecy ->
* [Talk: Willow]
    Willow: The founder of Nightshade Academy... Was it Anne Justice? No, I must be misremembering - it was Madame Guillard!
    -> notes.headmistress_name ->
+ [Interact: P_Seat]
    Controls: no
    Thought: Should I return to my seat?
    + + [Dialogue: Be seated]
        -> quiz
    + + [Dialogue: Do not]
    + + {notes.myos_notebook} [Dialogue: Check Myo's notebook]
        -> notes.myos_notebook ->
    Controls: yes
- -> ask_for_help

= quiz
Controls: no
Teacher: If everyone would take their seats..!
Teacher: It's time to begin the quiz.

VAR quiz_points = 0

->first_question
=first_question

Teacher: What is the graduation rate of this fine institution?
* [Dialogue: Twenty percent]
    -> correct_answer ->
* [Dialogue: Forty percent]
    -> incorrect_answer ->
* [Dialogue: Eighty percent]
    -> incorrect_answer ->
* [Dialogue: One hundred percent]
    -> incorrect_answer ->
+ {notes.myos_notebook} [Dialogue: Check Myo's notebook]
    -> notes.myos_notebook ->
    ->first_question
- 

->second_question
=second_question

Teacher: What is our policy on personal electronic devices?
* [Dialogue: Forbidden]
    -> correct_answer ->
* [Dialogue: Encouraged]
    -> incorrect_answer ->
* [Dialogue: Required]
    -> incorrect_answer ->
* [Dialogue: Firing squad]
    -> correct_answer ->
+ {notes.myos_notebook} [Dialogue: Check Myo's notebook]
    -> notes.myos_notebook ->
    ->second_question
- 

->third_question
=third_question

Teacher: What did our Glorious Headmistress do before founding the Academy?
* [Dialogue: Getaway driver]
    -> incorrect_answer ->
* [Dialogue: Pizza delivery]
    -> incorrect_answer ->
* [Dialogue: Nobody knows]
    -> correct_answer ->
* [Dialogue: Firing squad]
    -> incorrect_answer ->
+ {notes.myos_notebook} [Dialogue: Check Myo's notebook]
    -> notes.myos_notebook ->
    ->third_question
- 

->fourth_question
=fourth_question

Teacher: What is the Headmistress's name?
* [Dialogue: Moira Rouge]
    -> incorrect_answer ->
* [Dialogue: Anne Justice]
    -> incorrect_answer ->
* [Dialogue: Firing squad]
    -> incorrect_answer ->
* [Dialogue: Madame Guillard]
    -> correct_answer ->
+ {notes.myos_notebook} [Dialogue: Check Myo's notebook]
    -> notes.myos_notebook ->
    ->fourth_question
- 

->TODO

= correct_answer
~ quiz_points += 1
Teacher: That's correct{stopping:!|.} {once: 
    - <> Please refrain from blurting your answer out next time, though.
    - <> Again, though, on the paper next time. The other students need to solve it themselves.
}
->->

= incorrect_answer
Teacher: That's incorrect{stopping:!|.} {once: 
    - <> Did you read the study material at all?
    - <> Have you considered dropping my class? It might be worth considering.
}
->->
