package main

import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
SIZE :: 32

MAX_BULLETS :: 100
MAX_ENEMIES :: 100

Player :: struct {
  pos: rl.Vector2,
  size: rl.Vector2,
  speed: f32,
}

Entity :: struct {
  pos: rl.Vector2,
  size: rl.Vector2,
  speed: f32,
  active: bool,
}

Timer :: struct {
  value: f32,
  max_value: f32,
}

player := Player{
  {(WIDTH / 2) - (SIZE / 2), HEIGHT - (SIZE * 2)},
  {SIZE, SIZE},
  300
}

bullets: [MAX_BULLETS]Entity
enemies: [MAX_ENEMIES]Entity

enemy_spawn_timer := create_timer(1)

score := 0
game_over := false

main :: proc() {
  rl.SetTraceLogLevel(rl.TraceLogLevel.ERROR)
  rl.InitWindow(WIDTH, HEIGHT, "raylib - basic window")

  init_bullets()
  init_enemies()

  for !rl.WindowShouldClose() {
    update(rl.GetFrameTime())
    rl.BeginDrawing()
    draw()
    rl.EndDrawing()
  }

  rl.CloseWindow()
}

update :: proc(dt: f32) {
  if !game_over {
    player_move(dt)

    if timer_tick(&enemy_spawn_timer, dt) {
      spawn_enemy()
    }

    // Shooting
    if rl.IsKeyPressed(rl.KeyboardKey.SPACE) || rl.IsKeyPressed(rl.KeyboardKey.PERIOD) {
      spawn_bullet()
    }

    // Update bullets
    for _, i in bullets {
      b := &bullets[i]

      if b.active {
        b.pos.y -= b.speed * dt

        // Deactivate if outside of the screen
        if b.pos.y < 0 {
          b.active = false
          continue
        }

        // Check collision with enemies
        for _, i in enemies {
          e := &enemies[i]

          if !e.active {
            continue
          }

          if rl.CheckCollisionRecs(entity_to_rec(b), entity_to_rec(e)) {
            b.active = false
            e.active = false
            score += 1
          }
        }
      }
    }

    // Update enemies
    for _, i in enemies {
      e := &enemies[i]

      if e.active {
        e.pos.y += e.speed * dt

        if e.pos.y > HEIGHT - SIZE {
          game_over = true
        }
      }
    }
  }
}

draw :: proc() {
  rl.ClearBackground(rl.RED)
  rl.DrawRectangleV(player.pos, player.size, rl.WHITE)

  for b in bullets {
    if b.active {
      rl.DrawRectangleV(b.pos, b.size, rl.WHITE)
    }
  }

  for e in enemies {
    if e.active {
      rl.DrawRectangleV(e.pos, e.size, rl.WHITE)
    }
  }

  rl.DrawText(rl.TextFormat("%d", score), 10, 10, 20, rl.WHITE)

  if game_over {
    w: f32 = 500
    h: f32 = 150
    x: f32 = (WIDTH / 2) - (w / 2)
    y: f32 = (HEIGHT / 2) - (x / 2)

    rl.DrawRectangleV({x, y}, {w, h}, rl.WHITE)
    rl.DrawText("Game Over", 320, 290, 30, rl.RED)
  }
}

entity_to_rec :: proc(e: ^Entity) -> rl.Rectangle {
  return rl.Rectangle{e.pos.x, e.pos.y, e.size.x, e.size.y} 
}
