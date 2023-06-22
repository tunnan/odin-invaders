package main

// -----------------------------------------------------------------------------
// Timer
// -----------------------------------------------------------------------------
create_timer :: proc(seconds: f32) -> Timer {
  return {
    value = 0,
    max_value = seconds
  }
}

timer_tick :: proc(timer: ^Timer, dt: f32) -> bool {
  timer.value -= dt

  if (timer.value < 0) {
    timer.value = timer.max_value - dt
    return true
  }

  return false
}
