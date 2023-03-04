import nimraylib_now
import std/random
import player as Player
import coin as Coin

proc initialize_game*() =
    randomize()
    initWindow(cint(1366), cint(768), "NimRay Coin")
    setTargetFPS(60)

proc run_engine*() =
    var game_finished = false
    var game_timer = 0f
    var game_time = 30.0f

    var coin_spawn_delay = 0.35f
    var coin_spawn_timer = 0f

    var player = newPlayer()

    var camera: Camera2D = Camera2D()
    camera.zoom = 3.0f;
    camera.target = player.position
    camera.offset = Vector2(x:getScreenWidth() / 2, y: cfloat(getScreenHeight() - (68 + 48)) )

    var tile_tex = loadTexture("res/tiles.png")
    var tile_x = player.position.x - (50 * 5)

    var coin = newCoin()
    coin.position.x = tile_x + 24
    coin.position.y = (player.position.y - 24) - ((getScreenWidth() / 3) / 2) + 24

    var coins = @[coin]
    var coins_collected = 0

    #main loop
    while not windowShouldClose():
        #logic
        #----
        #get delta
        var delta = getFrameTime()

        game_timer += delta
        if game_timer >= game_time:
            game_finished = true
            game_timer = 0

        if not game_finished:
            coin_spawn_timer += delta
            if coin_spawn_timer > coin_spawn_delay:
                coin_spawn_timer = 0f
                var coin = newCoin()
                var tx = tile_x + 24
                var sw : float32 = tx + getScreenWidth() / 3
                coin.position.x = rand(tx..sw)
                coin.position.y = (player.position.y - 24) - ((getScreenWidth() / 3) / 2) + 24
                coins.add(coin)

            player.update(delta)

            var new_coin_list: seq[Coin]

            for c in coins.mitems:
                c.update(delta)
                if not checkCollisionRecs(c.bounds, player.bounds):
                    if not(c.position.y > (player.position.y + 24)):
                        new_coin_list.add(c)
                else:
                    coins_collected += 1

            coins = new_coin_list
        #drawing
        #-----
        beginDrawing()

        clearBackground(Black)

        beginMode2D(camera)

        for i in countup(0, 10):
            drawTexture(tile_tex, cint(tile_x + float(i * 50)), cint(player.position.y + 24), White)

        player.draw()

        for c in coins:
            c.draw()

        endMode2D()
        if not game_finished:
            drawText(cstring("Coins: " & $coins_collected), 10, 10, 35, Raywhite)
            drawText(cstring("Time: " & $int(game_timer)), getScreenWidth() - 320, 10, 35, Raywhite)
        else:
            drawText(cstring("Game Over, You Collected " & $coins_collected & " Coins!"), 10, 10, 35, Raywhite)
        endDrawing()
