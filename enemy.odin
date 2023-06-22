package main

import "core:math/rand"

// -----------------------------------------------------------------------------
// Enemies
// -----------------------------------------------------------------------------
init_enemies :: proc() {
  for i in 0..<MAX_ENEMIES {
    enemies[i] = {
      size = {SIZE, SIZE},
      speed = 50
    }
  }
}

find_inactive_enemy :: proc() -> ^Entity {
  for i in 0..<MAX_ENEMIES {
    if !enemies[i].active {
      return &enemies[i]
    }
  }

  return nil
}

spawn_enemy :: proc() {
  e := find_inactive_enemy()

  if e != nil {
    e.active = true
    e.pos = {
      rand.float32_range(0, WIDTH - SIZE),
      -SIZE
    }
  }
}
