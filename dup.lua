SMODS.Atlas {
    key = "jokers",
    path = "double_up.png",
    px = 71,
    py = 95
}

-- helper
local function dup_mark_unlock_progress(which)
    G.GAME.current_round.dup_unlock = G.GAME.current_round.dup_unlock or {
        used_mirror = false,
        triggered_double_up = false
    }

    G.GAME.current_round.dup_unlock[which] = true

    check_for_unlock({ type = 'dup_suited_mirror_progress' })
end

SMODS.Joker {
    key = "double_up",
    atlas = "dup_jokers",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "Two Pair" then
            local ranks = {}

            for _, c in ipairs(context.scoring_hand) do
                local rank = c.base.id
                if not ranks[rank] then
                    ranks[rank] = {}
                end
                table.insert(ranks[rank], c)
            end

            local found_pairs = {}

            for _, group in pairs(ranks) do
                if #group == 2 then
                    table.insert(found_pairs, group)
                end
            end

            if #found_pairs ~= 2 then
                return
            end

            local pair1 = found_pairs[1]
            local pair2 = found_pairs[2]

            local triggered = false

            -- pair 1 internally suited
            if pair1[1].base.suit == pair1[2].base.suit then
                triggered = true
            end

            -- pair 2 internally suited
            if pair2[1].base.suit == pair2[2].base.suit then
                triggered = true
            end

            -- any cross-pair suit match
            if not triggered then
                for i = 1, 2 do
                    for j = 1, 2 do
                        if pair1[i].base.suit == pair2[j].base.suit then
                            triggered = true
                            break
                        end
                    end
                    if triggered then break end
                end
            end

            if triggered then
                dup_mark_unlock_progress('triggered_double_up')
                return { mult = 12 }
            end
        end
    end
}

SMODS.Consumable {
    key = "the_mirror",
    set = "Tarot",
    cost = 8,

    can_use = function(_, _)
        local inhand = G.hand
        return inhand and inhand.highlighted and #inhand.highlighted == 3
    end,

    use = function(_, _, _, _)
        local inhand = G.hand
        if not (inhand and inhand.highlighted and #inhand.highlighted == 3) then
            return
        end

        local cards = {}

        for i = 1, #inhand.cards do
            for j = 1, #inhand.highlighted do
                if inhand.cards[i] == inhand.highlighted[j] then
                    table.insert(cards, inhand.cards[i])
                    break
                end
            end
        end

        if #cards ~= 3 then
            return
        end

        local left = cards[1]
        local middle = cards[2]
        local right = cards[3]

        local target_base = right.config.card
        if not target_base then
            return
        end

        left:set_base(target_base)
        middle:set_base(target_base)

        dup_mark_unlock_progress('used_mirror')
    end
}

SMODS.Back {
    key = "suited_mirror",
    unlocked = false,

    check_for_unlock = function(self, args)
        local prog = G.GAME and G.GAME.current_round and G.GAME.current_round.dup_unlock
        if prog and prog.used_mirror and prog.triggered_double_up then
            return true
        end
        return false
    end,

    apply = function(_, _)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({
                    key = "c_dup_the_mirror",
                    area = G.consumeables
                })

                SMODS.add_card({
                    key = "j_dup_double_up",
                    area = G.jokers
                })

                return true
            end
        }))
    end
}