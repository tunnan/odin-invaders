package main

import rl "vendor:raylib"

// -----------------------------------------------------------------------------
// Player
// -----------------------------------------------------------------------------
player_move :: proc(dt: f32) {
  dir := cast(int)rl.IsKeyDown(rl.KeyboardKey.D) - cast(int)rl.IsKeyDown(rl.KeyboardKey.A)

  player.pos.x += (cast(f32)dir * player.speed) * dt
  player.pos.x = clamp(player.pos.x, 0, WIDTH - SIZE)
}
