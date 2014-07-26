# Contributing

## Coding Style

DIrrlicht follows the [DStyle](http://dlang.org/dstyle.html) with few exceptions:

* Enum members should be PascalCased.

```D
enum LogLevel {
	Debug,
	Information,
	Warning,
	Error,
	None
}
```

* Opening braces should be on the same line of declaration.

```D
while (device.run()) {
}
```

### DIrrlicht specific

* Setter/Getter functions should be properties such as ```setScale```, ```setPosition```, ```setRotation``` etc.
