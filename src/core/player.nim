import nimraylib_now

type
    Player* = object
        position* : Vector2
        speed : float
        texture* : Texture2D
        anim_timer : float
        anim_delay : float
        current_frame* : int
        size : int
        src_rect : Rectangle
        dest_rect : Rectangle
        bounds* : Rectangle

proc newPlayer*() : Player =
    var player = Player()
    player.texture = loadTexture("res/sprite.png")
    player.position = Vector2()
    player.speed = 200f
    player.position.x = cfloat(getScreenWidth())
    player.position.y = cfloat(getScreenHeight())
    player.anim_timer = 0f
    player.anim_delay = 0.25f
    player.current_frame = 0
    player.size = 24

    player.src_rect = Rectangle()
    player.src_rect.x = cfloat(player.current_frame * player.size)
    player.src_rect.y = 0f
    player.src_rect.width = cfloat(player.size)
    player.src_rect.height = cfloat(player.size)

    player.dest_rect = Rectangle()
    player.dest_rect.x = player.position.x
    player.dest_rect.y = player.position.y
    player.dest_rect.width = cfloat(player.size)
    player.dest_rect.height = cfloat(player.size)

    player.bounds = Rectangle()
    player.bounds.width = cfloat(player.size)
    player.bounds.height = cfloat(player.size)

    result = player

proc update*(self : var Player, delta : float) =
    self.anim_timer += delta
    if self.anim_timer >= self.anim_delay:
        self.anim_timer = 0f
        self.current_frame += 1
        if self.current_frame > 1:
            self.current_frame = 0

    self.src_rect.x = cfloat(self.current_frame * self.size)

    if isKeyDown(KeyboardKey.A):
        self.position.x -= 1 * self.speed * delta

    if isKeyDown(KeyboardKey.D):
        self.position.x += 1 * self.speed * delta

    self.dest_rect.x = self.position.x
    self.bounds.x = self.position.x
    self.bounds.y = self.position.y

proc draw*(self : Player) =
    drawTexturePro(self.texture, self.src_rect, self.dest_rect, Vector2(x:0, y:0), 0f, Raywhite)
