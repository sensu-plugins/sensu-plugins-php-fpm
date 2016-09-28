#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

### Changed
- Removed Crack as a dependency of the metric script

## [0.1.0] - 2016-09-25
### Added
- check-php-fpm.rb: added --pool option for mapping pools based on args in Nginx

### Changed
- Changed dependency on sensu-plugin from strict (= 1.2.0) to pessimistic (~> 1.2)
- Updated Nginx configuration examples in README

## [0.0.5] - 2016-01-06
### Fixed
- remove duplicate option description in check-php-fpm

## [0.0.4] - 2015-09-21
### Added
- ability to make insecure https connections

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-06-03
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## 0.0.1 - 2015-05-21
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.1.0...HEAD
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.0.5...0.1.0
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-php-fpm/compare/0.0.1...0.0.2
