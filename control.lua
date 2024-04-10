puns = {"was training to figure it out.", "was saving it for a train-y day.", "was making it train.",
        "was covering their tracks.", "found out that the truth was hidden in train sight.", "went down the train.",
        "'s attempts were all in train.", "had a train reaction.", "was not for the train-t of heart.",
        "was here, train or shine.", "'s idea goes against the train.", "needs to to grab their train-coat.",
        "finds watching trains enter-train-ing.", "'s goal was at-train-able.", "was being train-washed.",
        "listens to music that's train-stream.", "was focusing on sus-train-able solutions.",
        "was made with train-less steel.", "had a bad track record.", "was only as strong as its weakest link.",
        "needs more train-ing.", "got a new job because their previous one was mun-train.",
        "had a spon-train-eous trip.", "could handle rough train.", "took two to train-go.",
        ". Train't nobody got time for that.", ". No train, no gain.", "contains a train of truth.",
        "was being train-sfered.", "was s-train-ge.", "was train-quil.", "'s en-train-ce was blocked.",
        "was going through a train-sition.", "should be open and train-sparent.", "was rail-ly happy to see you.",
        "couldn't keep a freight face.", "choo-chooses you.", "was Amtrak-ted to you.",
        "thinks that traveling by train is harder than it steams.", "was a ghost conductor, they ride in a ca-boo-se.",
        "was part-time train employee; a semi-conductor.", "had a tired train engine; a slow-comotive.",
        "was transporting gum with a chew-chew train.", "was listening with its engine-ears.", "had tunnel vision.",
        "hopes you have a freight day!", "was a-freight not.", "was the rail deal.", "got a Get Out of Rail Free card.",
        "was a twist of freight.", "could find a missing train by following its tracks.",
        "wakes up at the track of dawn.", "could drink more water than anyone. They keep chugging.",
        "was b-rail-liant!", "could always rail-y on you.", "was rail-ieved.", "was going to a freight party.",
        "'s favorite dance was the bogie-woogie.", "stopped to take a brake.", "was letting off steam.",
        "made a freight-ata for breakfast.", "was on the same steam.", "'s favorite donut was an apple freight-ter.",
        "was the most rail-iable option."}

function random_pun()
    return puns[math.random(#puns)]
end

global.put_player_in_locomotive_todo = {}

function find_or_create_nearby_locomotive(surface, force, position)
    nearby_locomotives = surface.find_entities_filtered {
        position = position,
        radius = 10,
        name = "locomotive"
    }
    for _, locomotive in pairs(nearby_locomotives) do
        driver = locomotive.get_driver()
        if driver == nil then
            return locomotive
        end
    end
    position = surface.find_non_colliding_position("locomotive", {0, 0}, 10, 1, true)
    if position == nil then
        return nil
    end
    surface.create_entity {
        name = "straight-rail",
        position = position,
        direction = defines.direction.east,
        force = force
    }
    surface.create_entity {
        name = "straight-rail",
        position = {
            x = position.x + 2,
            y = position.y
        },
        direction = defines.direction.east,
        force = force
    }
    surface.create_entity {
        name = "straight-rail",
        position = {
            x = position.x + 4,
            y = position.y
        },
        direction = defines.direction.east,
        force = force
    }
    locomotive = surface.create_entity {
        name = "locomotive",
        position = {
            x = position.x + 2,
            y = position.y
        },
        move_stuck_players = true,
        force = force
    }
    if locomotive ~= nil then
        locomotive.get_fuel_inventory().insert {
            name = "coal",
            count = 50
        }
    end
    return locomotive
end

function put_player_in_locomotive(player)
    locomotive = find_or_create_nearby_locomotive(player.surface, player.force, player.position)
    if locomotive == nil then
        player.print("Could not find you a suitable spawn location, sorry")
        return
    end
    locomotive.set_driver(player.character)
    player.insert {
        name = "rail",
        count = 200
    }
end

script.on_event({defines.events.on_player_created, defines.events.on_player_respawned,
                 defines.events.on_player_joined_game}, function(e)
    global.put_player_in_locomotive_todo[e.player_index] = true
end)

script.on_event(defines.events.on_tick, function(e)
    for _, player in pairs(game.players) do
        if player.vehicle == nil and player.character ~= nil then
            if global.put_player_in_locomotive_todo[player.index] == true then
                put_player_in_locomotive(player)
                global.put_player_in_locomotive_todo[player.index] = false
            else
                player.character.die()
                player.force.print(player.name .. " " .. random_pun())
            end
        end
    end
end)
