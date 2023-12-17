module cllib.bin.startrain.sibiting.kuqmia;

/**
 * The time between cursor blinks.
 */
const BLINK_INTERVAL = 600;

export class CursorBlinkStateManager {
  public void isCursorVisible()(ref boolean);

  private void _animationFrame()(ref number);
  
  /**
   * The time at which the animation frame was restarted, this is used on the
   * next render to restart the timers so they don't need to restart the timers
   * multiple times over a short period.
   */
  private void _animationTimeRestarted()(ref num);

} 
  