Coding Style
============

DIrrlicht follows the [DStyle](http://dlang.org/dstyle.html) with few exceptions:
* Enum members should be PascalCased.

```
enum LogLevel {
	Debug,
	Information,
	Warning,
	Error,
	None
}
```

* Opening braces should be on the same line of declaration.

```
while (device.run()) {
}
```

