local playerData = {}
local snakesAndLadders = {}

math.randomseed(os.time()) -- just to get the dice working set the seed to be the current time which is different every time

local function drawBoard()
    print([[
------------------------------------------------------------------
| 64    | 63    | 62     | 61    | 60    | 59    | 58    | 57    |
|       |       |      ⬆︎ |       |       |       |       |       |
-----------------------⬆︎------------------------------------------
| 49    | 50    | 51   ⬆︎ | 52    | 53    | 54    | 55    | 56    |
|    ➘  |       |      ⬆︎ |     ⬇︎ |       |       |     ⬇︎ |       |
-------➘---------------⬆︎-------⬇︎-----------------------⬇︎----------
| 48    |➘47    | 46   ⬆︎ | 45  ⬇︎ | 44    | 43    | 42  ⬇︎ | 41    |
|       |  ➘    |      ⬆︎ |     ⬇︎ |       |       |    ➚  |       |
-------------➘---------⬆︎-------⬇︎--------------------➚------------
| 33    | 34   ➘| 35   ⬆︎ | 36  ⬇︎ | 37    | 38    |➚39    | 40    |
|       |       |➘     ⬆︎ |     ⬇︎ |       |      ➚|       |       |
-----------------------⬆︎-------⬇︎---------------➚------------------
| 32    | 31    | 30   ⬆︎ | 29  ⬇︎ | 28    | 27➚   | 26    | 25    |
|       |       |      ⬆︎ |       |       | ➚     |       |       |
-----------------------⬆︎-----------------➚------------------------
| 17    | 18    | 19   ⬆︎ | 20    | 21  ➚ | 22    | 23    | 24    |
|       |    ➘  |        |       |       |       |     ⬇︎ |       |
---------------➘---------------------------------------⬇︎----------
| 16    | 15    |➘14     | 13    | 12    | 11    | 10  ⬇︎ | 9     |
|       |       |  ➘     |       |       |       |     ⬇︎ |       |
-------------------------------------------------------⬇︎----------
| 1     | 2     | 3      | 4     | 5     | 6     | 7   ⬇︎ | 8     |
|       |       |        |       |       |       |       |       |
------------------------------------------------------------------
    ]])
end

local function printWelcomeMessage()
    print("Welcome to our Lua version of Snakes and Ladders!")
    print("We hope you enjoy it")
end

local function collectPlayerData()
    print("Let's start by finding out who is playing")

    local playerIcons = { 
        dog = "\u{1F436}", 
        cat = "\u{1F431}", 
        mouse = "\u{1F42D}", 
        rabbit = "\u{1F430}", 
        koala = "\u{1F428}" 
    } -- 🐶, 🐱, 🐭, 🐰, 🐨
    
    local noMorePlayers = false
    repeat
        print("What is your name?")
        local playerName = io.read()
        print("Welcome " .. playerName .. ", what character do you want to play?")
        for k,v in pairs(playerIcons) do
            io.write("Type \"" .. k .. "\" to be " .. v .. " ")
        end
        print()
        
        local playerIcon = nil
        repeat
            local character = io.read()
            if character == "dog" then
                playerIcon = playerIcons.dog
            elseif character == "cat" then
                playerIcon = playerIcons.cat
            elseif character == "mouse" then
                playerIcon = playerIcons.mouse
            elseif character == "rabbit" then
                playerIcon = playerIcons.rabbit
            elseif character == "koala" then
                playerIcon = playerIcons.koala
            else
                print("Sorry, you typed " .. character .. " and this wasn't one of our characters, try again, what character would you like to be?")
                print("Type dog, cat, mouse, rabbit or koala")
            end
        until playerIcon ~= nil

        table.insert(playerData, { name = playerName, icon = playerIcon, boardPosition = 1 }) -- everyone starts at square 1

        print("Great, that's " .. playerName .. " setup ready to play. Is there anyone else? Type yes or no")

        local morePlayers
        repeat
            morePlayers = string.upper(io.read())
            if morePlayers ~= "YES" and morePlayers ~= "NO" then
                print("You entered " .. morePlayers .. ", please type yes or no")
            elseif morePlayers == "NO" then
                noMorePlayers = true
            end
        until morePlayers == "YES" or morePlayers == "NO"
    until noMorePlayers
end

local function setupSnakesAndLadders()
    snakesAndLadders[18] = { direction = "down", to = 14, message = "Oh dear, you landed on 18, that's a small snake down to 14" }
    snakesAndLadders[19] = { direction = "up", to = 62, message = "Skyrocket! You landed on 19 which is our biggest ladder to 62" }
    snakesAndLadders[21] = { direction = "up", to = 42, message = "Great! 21 is a ladder to 42" }
    snakesAndLadders[23] = { direction = "down", to = 7, message = "Slippery slope, 23 is a snake to 7" }
    snakesAndLadders[49] = { direction = "down", to = 35, message = "Ahh man! You we're close, but 49 is a snake to 35" }
end

local function rollTheDice(player)
    print("Ok then " .. player.name .. " - " .. player.icon .. ", it's your turn and you're on square " .. player.boardPosition)
    print("Press enter to roll the dice")
    io.read()
    local diceValue = math.random(6)
    print("You rolled a " .. diceValue)
    player.boardPosition = player.boardPosition + diceValue
    print("Your new square is " .. tostring(player.boardPosition))
    if snakesAndLadders[player.boardPosition] ~= nil then
        print(snakesAndLadders[player.boardPosition].message)
        player.boardPosition = snakesAndLadders[player.boardPosition].to
    end
    drawBoard()
end

local function someoneHasWon()
    for k,v in ipairs(playerData) do
        if v.boardPosition >= 64 then
            return true
        end
    end
    return false -- we managed to look at everyone and we never returned, so nobody could have won so far
end

local function getTheWinner()
    for k,v in ipairs(playerData) do
        if v.boardPosition >= 64 then
            return v
        end
    end
    return nil -- something has gone wrong, nobody has won, return nil
end

local function runGame()
    repeat
        for k,v in ipairs(playerData) do
            rollTheDice(v)
        end
    until someoneHasWon()

    local winner = getTheWinner()

    for i = 1, 20 do
        io.write(winner.icon)
    end
    print("\n\n")
    print("Congratulations " .. winner.name .. " you won!!")
end

printWelcomeMessage()
collectPlayerData()
setupSnakesAndLadders()

runGame()