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
Scene: West
Enters: P{ Test2.SomeOther: ;; Enters: SomeOther bench;; Moves: SomeOther chair;; Act: SomeOther sits }
Controls: yes

+ Exit: East
    -> Test2
* {Test2} Talk: SomeOther
    -> SomeOther
= start

// SCENE directives change the level.
// Semicolons allow multiple directives to happen on the same line. Directives might block until the next line, so this is meaningful.
Scene: West
Appears: P center
// TITLE directives show a title.
TITLE: Test story!
// If an actor's name is used as a directive, they speak.
P: Hello, world!
// Thoughts appear in a smaller bubble and won't require player interaction to resolve.
// When tagged with async, they don't block.
Thought: I hope I did OK... #async

-> Test
=SomeOther
Controls: no
SomeOther: Whuh?
P: Nothing.
Thought SomeOther: That was strange. #async
SomeOther: OK!
Controls: yes
->here

=== Test2 ===
= enter
Scene: East
Enters: P;; Enters: SomeOther bench;; Moves: SomeOther bench;; Act: SomeOther sits

{ (not Test2.here): 
    Thought SomeOther: ..? Oh!
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
Controls: no
SomeOther: What's up?
P: Nothing much.
Controls: yes
-> here