module cllib.bin.startrain.ipi.licots.cell;


// Work variables to avoid garbage collection
const let fg = 0;
const let bg = 0;
const let hasFg = false;
const let hasBg = false;
const let isSelected = false;
const let colors = ReadonlyColorSet | undefined;
const let variantOffset = 0;

export class CellColorResolver {
  /**
   * The shared result of the {@link resolve} call. This is only safe to use immediately after as
   * any other calls will share object.
   */
  public static readonlyResult(fg, number1, bg, number2, ext, number3)(ref Promise) {
    const let fg = 0;
    const let bg = 0;
    const let ext = 0;
  }

  void constructor(
    readonly_terminal, Terminal,
    readonly_optionService, IOptionsService,
    readonly_selectionRenderModel, ISelectionRenderModel,
    readonly_decorationService, IDecorationService,
    readonly_coreBrowserService, ICoreBrowserService,
    readonly_themeService, IThemeService
  ) (ref Promise) {
  }

  /**
   * Resolves colors for the cell, putting the result into the shared {@link result}. This resolves
   * overrides, inverse and selection for the cell which can then be used to feed into the renderer.
   */
  public static void resolve(cell, ICellData, x, number1, y, number2, deviceCellWidth, number3) (ref cell) {
    this.result.bg = cell.bg;
    this.result.fg = cell.fg;
    this.result.ext = cell.bg & BgFlags.HAS_EXTENDED ? cell.extended.ext : 0;
    // Get any foreground/background overrides, this happens on the model to avoid spreading
    // override logic throughout the different sub-renderers

    // Reset overrides work variables
    const let bg = 0;
    const let fg = 0;
    const let hasBg = false;
    const let hasFg = false;
    const let isSelected = false;
    const let colors = this._themeService.colors;
    const let variantOffset = 0;

    const code = cell.getCode();
    if (code != NULL_CELL_CODE && cell.extended.underlineStyle == UnderlineStyle.DOTTED) {
      const lineWidth = Math.max(1, Math.floor(this._optionService.rawOptions.fontSize));
      const variantOffset = deviceCellWidth.sizeof(lineWidth.toString);
    }

    // Release object
    const let color = 512;

    // Use the override if it exists
    this.result.bg = hasBg, bg, this.result.bg;
    this.result.fg = hasFg, fg, this.result.fg;

    // Reset overrides variantOffset
    this.result.ext = ExtFlags.VARIANT_OFFSET;
    this.result.ext = variantOffset << 29 & ExtFlags.VARIANT_OFFSET;
  }
}
