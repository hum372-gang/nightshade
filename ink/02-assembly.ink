=== IntroAssembly
Scene: auditorium_busy
Appears: S1 s1seat;; Appears: S2 s2seat;; <>
Appears: S3 s3seat;; Appears: S4 s4seat;; <>
Appears: S1 sit_n;; Appears: S2 sit_n;; <>
Appears: S3 sit_n;; Appears: S4 sit_n
Enters: P front
Controls: no
Move P: pseat
Act P: sit_n
Wait: 0.2
Thought S1: Argh... Why do we have to sit through this every day? #async
Wait: 0.4
Thought S2: Who's that?
Wait: 0.1
Thought S3: Quiet! The principal is here! #async
Wait: 0.3
Thought: ..? #async
Wait: 1
Camera focus: podium
Wait: 0.5
Enters: Principal stage_left
Camera focus: Principal
Move Principal: podium
Act Principal: present_s
Sound: principal_ahem_mic

Principal: Good morning, students of Nightshade Academy! Welcome back from your long weekend. In the intervening days, a new face has joined our wonderful school!
Camera focus: P
Principal: You there, in the back! Please introduce yourself to the class.
Act P: stand_n
-> give_name
= give_name
Prompt P: My name is...
P: (Is {P} right? I don't want to say my own name wrong on the first day...
+ [Dialogue: That's right]
+ [Dialogue: Oops!]
    -> give_name
- 
P: Hello, my name is {P}. It's very nice to meet you.
Wait: 0.2
Act P: sit_n
Camera focus: Principal
Principal: It's nice to meet you too, {P}. You can call me Headmistress Rouge. Everyone remember to be kind to them; we're all friends here.
Principal: Additionally: The volleyball team is looking for more players, so please let Coach Aconite know if you're interested in participating.
Principal: The art club is in the process of creating a new mural by the south side entrance.
Principal: For lunch today, the cafeteria is offering crispy chicken sandwiches, fresh fruit, and green salad with house-made dressing.
Camera focus: S2
Camera care: S3
Thought Principal: (indistinct...) #async
Wait: 0.5
Act S2: gossip_l
S2: Oof... That dressing made me sick the last time I got it!
Act S3: gossip_r
S3: Really? It was fine for me, maybe your stomach is just sensitive?
Camera care: P
Thought: ..?
Act S2: sit_n;; <>
Act S3: sit_n;; <>
Camera focus: Principal
Wait: 0.5
Principal: Thank you for listening; please leave the auditorium in an orderly fashion and continue with your schedule.

->END