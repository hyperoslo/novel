![Novel](https://github.com/hyperoslo/Novel/blob/master/Art/Cover.png)

# Novel CMS
[![CI Status](http://img.shields.io/travis/hyperoslo/Novel.svg?style=flat)](https://travis-ci.org/hyperoslo/Novel)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Mac OS X](https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat)
![Swift](https://img.shields.io/badge/%20in-swift%203.0.1-orange.svg)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

**Novel** is a content management system (CMS) built on top of
[Vapor](https://github.com/vapor/vapor) Swift web framework.

Try our demo project running on Heroku:
* Admin panel: https://novel-demo.herokuapp.com/admin (admin/password)
* Front page: https://novel-demo.herokuapp.com
* API: https://novel-demo.herokuapp.com/api/entries/post

## Features

* 5 minutes setup.
* Intuitive admin panel.
* Developer friendly.
* Powerful data model structure based on entry types and custom fields.
* All the functionality provided by [Vapor](https://github.com/vapor/vapor)
foundation.
* More features are coming...

**Please note** that this is a work in progress, **Novel** is under continuous
development and **is not ready** for production usage.

## Requirements

* Swift 3.0.1 or later.
* PostgreSQL >= 9.4.5.

## Usage

Setting up a new project based on **Novel** requires a few additional steps,
such as copying assets, database configuration, etc. The simplest way to create
a new project is to use our [Novel CLI](https://github.com/vadymmarkov/novel-cli)
tool, which does all the necessary tasks under the hood.

## Development

Setup database:

```sh
createdb test
cd path/to/novel/Config
cp postgresql-sample.json ./secrets/postgresql.json
```

Compile assets

```sh
cd path/to/novel/Resources/Web
npm install
bower install
gulp
```

Generate XCode project:

```sh
cd path/to/novel
swift package generate-xcodeproj
open Novel.xcodeproj
```

Run demo:

```sh
./.build/debug/Demo
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## Credits

**Novel** is built with [Vapor](https://github.com/qutheory/vapor), the most
used web framework for Swift.

## Contributing

We would love you to contribute to **Novel**, check the [CONTRIBUTING](https://github.com/hyperoslo/Novel/blob/master/CONTRIBUTING.md)
file for more info.

## License

**Novel** is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Novel/blob/master/LICENSE.md) file for more info.
