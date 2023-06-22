package main

// -----------------------------------------------------------------------------
// Entitys
// -----------------------------------------------------------------------------
init_bullets :: proc() {
  for i in 0..<MAX_BULLETS {
    bullets[i] = {
      size = {8, 8}
      speed = 300
    }
  }
}

find_inactive_bullet :: proc() -> ^Entity {
  for i in 0..<MAX_BULLETS {
    if !bullets[i].active {
      return &bullets[i]
    }
  }

  return nil
}

spawn_bullet :: proc() {
  b := find_inactive_bullet()

  if b != nil {
    b.active = true
    b.pos = {
      player.pos.x + SIZE / 2 - b.size.x / 2,
      player.pos.y
    }
  }
}
