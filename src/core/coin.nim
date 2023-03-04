import nimraylib_now

type
    Coin* = object
        position* : Vector2
        speed* : float
        texture* : Texture2D
        anim_timer : float
        anim_delay : float
        current_frame* : int
        size : float
        src_rect : Rectangle
        dest_rect : Rectangle
        bounds* : Rectangle
        alive* : bool

proc newCoin*() : Coin =
    var coin = Coin()
    coin.alive = true
    coin.texture = loadTexture("res/coin.png")
    coin.position = Vector2()
    coin.position.x = 0
    coin.position.y = 0
    coin.speed = 100
    coin.current_frame = 0
    coin.anim_delay = 0.25
    coin.anim_timer = 0
    coin.size = 14
    coin.src_rect = Rectangle()
    coin.src_rect.x = 0f
    coin.src_rect.y = 0f
    coin.src_rect.width = coin.size
    coin.src_rect.height = coin.size
    coin.dest_rect = Rectangle()
    coin.dest_rect.x = coin.position.x
    coin.dest_rect.y = coin.position.y
    coin.dest_rect.width = coin.size
    coin.dest_rect.height = coin.size
    coin.bounds = Rectangle()
    coin.bounds.width = coin.size
    coin.bounds.height = coin.size

    result = coin

proc update*(self : var Coin, delta : float) =
    self.anim_timer += delta
    if self.anim_timer >= self.anim_delay:
        self.anim_timer = 0f
        self.current_frame += 1
        if self.current_frame > 1:
            self.current_frame = 0

    self.src_rect.x = cfloat(self.current_frame * int(self.size))

    self.position.y += 1 * self.speed * delta

    self.dest_rect.x = self.position.x
    self.dest_rect.y = self.position.y

    self.bounds.x = self.position.x
    self.bounds.y = self.position.y

proc draw*(self : Coin) =
    if self.alive:
        drawTexturePro(self.texture, self.src_rect, self.dest_rect, Vector2(x:0, y:0), 0f, Raywhite)
