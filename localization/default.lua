return {
    descriptions = {
        Joker = {
            j_dup_double_up = {
                name = "Double Up Joker",
                text = {
                    "If played hand is {C:attention}Two Pair{}",
                    "and any two share the same {C:attention}suit{},",
                    "gain {C:mult}+12 Mult{}"
                }
            }
        },

        Tarot = {
            c_dup_the_mirror = {
                name = "The Mirror",
                text = {
                    "Select {C:attention}3{} cards,",
                    "convert the {C:attention}2 left-most{} cards",
                    "into the {C:attention}right-most{} card",
                    "{C:inactive}(Copies rank and suit only){}"
                }
            }
        },

        Back = {
            b_dup_suited_mirror = {
                name = "Suited Mirror",
                text = {
                    "Start the run with",
                    "{C:tarot}The Mirror{} and a {C:uncommon}Double Up Joker{}"
                },
                unlock = {
                    "Use {C:tarot}The Mirror{}",
                    "and trigger {C:uncommon}Double Up Joker{}",
                    "in a single run"
                }
            }
        }
    }
}