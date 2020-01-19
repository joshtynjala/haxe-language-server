package haxeLanguageServer.helper;

private typedef Version = {
	final major:Int;
	final minor:Int;
	final patch:Int;
	final ?pre:String;
	final ?build:String;
}

abstract SemVer(Version) from Version {
	static final reVersion = ~/^(\d+)\.(\d+)\.(\d+)(?:[-]([a-z0-9.-]+))?(?:[+]([a-z0-9.-]+))?/i;

	public var major(get, never):Int;

	inline function get_major()
		return this.major;

	public var minor(get, never):Int;

	inline function get_minor()
		return this.minor;

	public var patch(get, never):Int;

	inline function get_patch()
		return this.patch;

	/** note: not considered in comparisons or `toString()` **/
	public var pre(get, never):String;

	inline function get_pre()
		return this.pre;

	public var build(get, never):String;

	inline function get_build()
		return this.build;

	public static function parse(s:String):Null<SemVer> {
		if (!reVersion.match(s)) {
			return null;
		}
		var major = Std.parseInt(reVersion.matched(1));
		var minor = Std.parseInt(reVersion.matched(2));
		var patch = Std.parseInt(reVersion.matched(3));
		var pre = reVersion.matched(4);
		var build = reVersion.matched(5);
		return new SemVer(major, minor, patch, pre, build);
	}

	inline public function new(major, minor, patch, ?pre, ?build) {
		this = {
			major: major,
			minor: minor,
			patch: patch,
			pre: pre,
			build: build
		};
	}

	@:op(a >= b) function isEqualOrGreaterThan(other:SemVer):Bool {
		return isEqual(other) || isGreaterThan(other);
	}

	@:op(a > b) function isGreaterThan(other:SemVer):Bool {
		return (major > other.major)
			|| (major == other.major && minor > other.minor)
			|| (major == other.major && minor == other.minor && patch > other.patch);
	}

	@:op(a == b) function isEqual(other:SemVer):Bool {
		return major == other.major && minor == other.minor && patch == other.patch;
	}

	public function toString() {
		return '$major.$minor.$patch';
	}
}
