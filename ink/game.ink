VAR P = "friend"
VAR Pthey = "they"
VAR Pthem = "them"
VAR Ptheir = "their"
VAR Ptheirs = "theirs"

->Test.start

=== Test ===
= here
// Scene directives pointing to the same scene you're already in are no-ops.
// If a character needs to be in a scene, they need to enter or appear.
// When a character enters, if they were in the last scene, they will try to find an entrance attached to that scene to walk out of. If they can't, they will just appear at their position.
// The player still needs to be mentioned as entering.
Scene: Test;; Enters: P{ Enters: SomeOther bench;; Moves: SomeOther chair;; Act: SomeOther sits }
Controls: yes

+ Exit: East
    -> Test2
* {Test2} Talk: SomeOther
    -> SomeOther
= start

// SCENE directives change the level.
// Semicolons allow multiple directives to happen on the same line. Directives might block until the next line, so this is meaningful.
Scene: Test;; Appears: P center
// TITLE directives show a title.
TITLE: Test story!
// If an actor's name is used as a directive, they speak.
P: Hello, world!
// If dialogue is tagged as #remark, it will appear in a smaller bubble and won't require player interaction to resolve.
P: I hope I did OK... #remark

-> Test
=SomeOther
Controls: no
SomeOther: Whuh?
P: Nothing.
SomeOther: OK!
Controls: yes
->here

=== Test2 ===
= enter
Scene: Test2;; Enters: P;; Enters: SomeOther bench;; Moves: SomeOther bench
Act: SomeOther sits

{ (not Test2.here): 
    Camera: focus SomeOther
    SomeOther: Hey {P}!
    P: Hi!
    Camera: relax
}
-> here

= here
+ Exit: West
    -> Test
* Talk: SomeOther
    -> SomeOther

= SomeOther
Controls: No
SomeOther: What's up?
P: Nothing much.
Controls: Yes
-> here