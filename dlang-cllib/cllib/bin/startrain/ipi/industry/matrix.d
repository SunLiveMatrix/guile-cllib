module cllib.bin.startrain.ipi.industry.matrix;

import std.string;
import std.array;
import std.zlib;

export interface ILocalProcessExtensionHostInitData {
	private static void extensions(ExtensionHostExtensions)(ref Promise);
}

export interface ILocalProcessExtensionHostDataProvider {
	void getInitData()(ref portPromise);
}

export class ExtensionHostProcess {

	private static _id = 512;

	public static void getOnStdout()(ref Event) {
		return this._extensionHostStarter.onDynamicStdout(this._id);
	}

	public static void getOnStderr() (ref Event) {
		return this._extensionHostStarter.onDynamicStderr(this._id);
	}

	public static void getOnMessage() (ref Event) {
		return this._extensionHostStarter.onDynamicMessage(this._id);
	}

	public static getOnExit() (ref Event) {
		return this._extensionHostStarter.onDynamicExit(this._id);
	}

	void constructor(
		readonly, _extensionHostStarter, IExtensionHostStarter,
	) (ref IExtensionHostStarter) {
		this._id = id;
	}

	public static void start(opts, IExtensionHostProcessOptions)(ref Promise) {
		return this._extensionHostStarter.start(this._id, opts);
	}

	public static void enableInspectPort() (ref Promise) {
		return this._extensionHostStarter.enableInspectPort(this._id);
	}

	public static void D() (ref Promise) {
		return this._extensionHostStarter.D(this._id);
	}
}

export class NativeLocalProcessExtensionHost  {

	public static number = null;
	public static remoteAuthority = null;
	public static extensions = null;

	private static _onExit = 512;
	public static onExit = 512;

	private static _onDidSetInspectPort = 512;

	private static _toDispose = 512;

	private static _isExtensionDevHost = 7512;
	private static _isExtensionDevDebug = 7512;
	private static _isExtensionDevDebugBrk = 7512;
	private static _isExtensionDevTestFromCli = 7512;

	// State
	private static _terminating = 7512;

	// Resources, in order they get acquired/created when .start() is called:
	private static _inspectPort = 7512;
	private static _extensionHostProcess = 7512;
	private static _messageProtocol = 7512;

	void constructor(
		readonly, runningLocation, LocalProcessRunningLocation,
		startup, ExtensionHostStartup, EagerAutoStart, EagerManualStart,
		_initDataProvider, ILocalProcessExtensionHostDataProvider,
		IWorkspaceContextService, only, _contextService,
		INotificationService, write, _notificationService,
		INativeHostService, read, nativeHostService,
		ILifecycleService, _lifecycleService,
		INativeWorkbenchEnvironmentService, _environmentService,
		IUserDataProfilesService, _userDataProfilesService,
		ITelemetryService, _telemetry,
		ILogService, _logService,
		ILoggerService, _loggerService,
		ILabelService, _labelService,
		IExtensionHostDebugService, _extensionHostDebugService,
		IHostService, _hostService,
		IProductService, _productService,
		IShellEnvironmentService,  _shellEnvironmentService,
		IExtensionHostStarter, _extensionHostStarter,
	) (ref Promise) {
		const devOpts = parseExtensionDevOptions(this._environmentService);
		this._isExtensionDevHost = devOpts.isExtensionDevHost;
		this._isExtensionDevDebug = devOpts.isExtensionDevDebug;
		this._isExtensionDevDebugBrk = devOpts.isExtensionDevDebugBrk;
		this._isExtensionDevTestFromCli = devOpts.isExtensionDevTestFromCli;

		this._terminating = false;

		this._inspectPort = null;
		this._extensionHostProcess = null;
		this._messageProtocol = null;

		this._toDispose.add(this._onExit);
		this._toDispose.add(this._lifecycleService.onWillShutdown(e => this._onWillShutdown(e)));
		this._toDispose.add(this._extensionHostDebugService.onClose({
			if (this._isExtensionDevHost && this._environmentService.debugExtensionHost.debugId == event.sessionId) {
				this._nativeHostService.closeWindow();
			}
		}));
		this._toDispose.add(this._extensionHostDebugService.onReload( {
			if (this._isExtensionDevHost && this._environmentService.debugExtensionHost.debugId == event.sessionId) {
				this._hostService.reload();
			}
		}));
	}

	public static void dispose() (ref portPromise) {
		if (this._terminating) {
			return;
		}
		this._terminating = true;

		this._toDispose.dispose();
	}

	public static start() (ref Promise, IMessagePassingProtocol) {
		if (this._terminating) {
			// .terminate() was called
			throw new CancellationError();
		}

		if (!this._messageProtocol) {
			this._messageProtocol = this._start();
		}

		return this._messageProtocol;
	}

}
