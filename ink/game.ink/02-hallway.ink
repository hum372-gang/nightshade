LIST appears_in_hallway = Myo

=== hallway
Scene: Hallway
Enters: P

{ appears_in_hallway ? Myo: Enters: Myo Myo_Spot}

+ { allowed_to_visit ? Dorm } [Exit: Dorm]
    -> dorm
+ [Exit: Dorm]
    Thought: The door won't budge.
    {once:
    - Thought: I've heard this school has a locking system to make students follow a regimented schedule...
        Thought: This feels like it could violate fire codes or something, though...
    }
+ { allowed_to_visit ? Homeroom } [Exit: Homeroom]
    -> homeroom
+ [Exit: Homeroom]
    Thought: Locked.
-

-> hallway

->TODO