[![Stories in Ready](https://badge.waffle.io/mlandauer/thats-camping-elm.png?label=ready&title=Ready)](https://waffle.io/mlandauer/thats-camping-elm)
[![Build Status](https://travis-ci.org/mlandauer/thats-camping-elm.svg?branch=master)](https://travis-ci.org/mlandauer/thats-camping-elm)

# It's raining and my weetbix is wet. That's Camping!

Find campsites near you in New South Wales, Australia. It covers camping on
public, common land such as National Parks, State Forests and Local Councils.

It is a client-side Javascript app written using [Elm](http://elm-lang.org/).
If you haven't come across Elm before, it's a pure functional language that
compiles to Javascript and is easy to learn and use and has been generally a
pleasure to work with.

The app also uses [PouchDB](https://pouchdb.com/)/[CouchDB](http://couchdb.apache.org/)
to work offline.

When a network is available any updates from the main database are automatically
synched back to the local database and are reflected in the user interface in
real time.

The next step is to add the ability for the user to edit and add new campsites!
This will again even work when offline.

## Development

To run:
```
npm install
npm run dev
```

Point your web browser at [http://localhost:3000](http://localhost:3000)

And for testing goodness:
```
elm-test --watch
```

There's currently a bug in elm-test that means that it doesn't watch all
directories for changes. It's been [fixed but not yet released](https://github.com/rtfeldman/node-test-runner/pull/101/commits/39e96f67b5b5fb637cd377a095c31c29e9b10403). In the meantime just re-run the tests when you need to.

## Production

The site is hosted on S3 with Cloudfront acting as the CDN. We're also using
a free SSL certificate provided by the AWS Certificate Manager.

We're using a tool called [s3_website](https://github.com/laurilehmijoki/s3_website) to make things easier.

To deploy a new version to production:
```
npm run build
s3_website push
```

## Thank you

[<img src="https://bstacksupport.zendesk.com/attachments/token/iz2OKPJFTXNSgJX2Qz6yNvYBj/?name=Logo-01.svg" height="40px" alt="BrowserStack Logo">](https://www.browserstack.com)

[BrowserStack](https://www.browserstack.com) for supporting open-source projects, including That's Camping, with free access to their wonderful browser testing tools.

The "That's Camping!" icon design by Gabriel Clark.

## Copyright & License

Copyright Matthew Landauer. Licensed under the GPL v3. See LICENSE.md for more details.
