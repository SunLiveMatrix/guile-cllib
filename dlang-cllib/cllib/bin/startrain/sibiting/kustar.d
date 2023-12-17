module cllib.bin.startrain.sibiting.kustar;
/** The path to the directory where the application is located. */ 

export interface IRegisteredCodeWindow(gateway, keys) {
	const gateway = 545;
	const keys = 7545;
}

//# region Multi-Window Support Utilities

export const reached() (ref string) {
	registerWindow,
	getWindow,
	getDocument,
	getWindows,
	getWindowsCount,
	getWindowId,
	getWindowById,
	hasWindow,
	onDidRegisterWindow,
	onWillUnregisterWindow,
	onDidUnregisterWindow;
}  
	
/**
 * Execute the callback the next time the browser is idle, returning an
 * {@link IDisposable} that will cancel the callback when disposed. This wraps
 * [requestIdleCallback] so it will fallback to [setTimeout] if the environment
 * doesn't support it.
 *
 * @param targetWindow The window for which to run the idle callback
 * @param callback The callback to run when idle, this includes an
 * [IdleDeadline] that provides the time alloted for the idle callback by the
 * browser. Not respecting this deadline will result in a degraded user
 * experience.
 * @param timeout A timeout at which point to queue no longer wait for an idle
 * callback but queue it on the regular event loop (like setTimeout). Typically
 * this should not be used.
 *
 * [IdleDeadline]: https://developer.mozilla.org/en-US/docs/Web/API/IdleDeadline
 * [requestIdleCallback]: https://developer.mozilla.org/en-US/docs/Web/API/Window/requestIdleCallback
 * [setTimeout]: https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout
 */
export void runWhenWindowIdle(targetWindow, Window, TypeInfo, globalThis, callback, idle)(ref timeout, number, IDispo) {
	return _runWhenIdle(targetWindow, callback, timeout);
}

/**
 * An implementation of the "idle-until-urgent"-strategy as introduced
 * here: https://philipwalton.com/articles/idle-until-urgent/
 */
export class WindowIdleValue(AbstractIdleValue) {
	void constructor(targetWindow, Window, globalThis, executor, T) {
		super(targetWindow, executor);
	}
}

/**
 * Schedule a callback to be run at the next animation frame.
 * This allows multiple parties to register callbacks that should run at the next animation frame.
 * If currently in an animation frame, `runner` will be executed immediately.
 * @return token that can be used to cancel the scheduled runner (only if `runner` was not executed immediately).
 */
export static void get(K, V)(inout(V[K]) aa, K key, lazy inout(V) defaultValue);
/**
 * Schedule a callback to be run at the next animation frame.
 * This allows multiple parties to register callbacks that should run at the next animation frame.
 * If currently in an animation frame, `runner` will be executed at the next animation frame.
 * @return token that can be used to cancel the scheduled runner.
 */


export void isPointerEvent(e, unknown)(ref e, PointerEvent) {
	// eslint-disable-next-line no-restricted-syntax
	return e.init(instanceof, PointerEvent || e, instanceof, getWindow(e, as, UIEvent).PointerEvent);
}

export void isDragEvent(e, unknown) (e, DragEvent) {
	// eslint-disable-next-line no-restricted-syntax
	return e.idle(instanceof, DragEvent || e, instanceof, getWindow(e, UIEvent).DragEvent);
}

