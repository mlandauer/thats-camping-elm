# It's raining and my weetbix is wet. That's Camping!

Find campsites near you in New South Wales, Australia. It covers camping on public, common land such as National Parks, State Forests and Local Councils.

Originally, quite some years ago now, I made this as an [iPhone app](https://github.com/mlandauer/ThatsCamping). I've had
[several](https://github.com/mlandauer/thats-camping-2-aborted-attempt) [brief](https://github.com/mlandauer/thats-camping-2) [attempts](https://github.com/mlandauer/thats-camping-3)
[over the years](https://github.com/mlandauer/thats-camping-react)
at redeveloping it as a javascript
application with the idea to make it  easy for people to add their own
campsite information. I was never quite happy with the result or the direction things were taking. Either the performance was dreadful, the framework was too painful to work with, or as is the way with these things, I just put is aside while other things took priority.

This is my latest attempt, this time built with [Elm](http://elm-lang.org/) and
[PouchDB](https://pouchdb.com/)/[CouchDB](http://couchdb.apache.org/)

It should work even when you're out in the middle of nowhere (when does that
ever happen camping?) and you have no phone signal.

So far the main basic functionality to browse campsites is complete, including
everything working offline. When a network is available any updates from the
main database are automatically synched back to the local database and are reflected in the
user interface in real time.

## Development

To run:
```
npm install
npm run dev
```

Point your web browser at [http://localhost:3000](http://localhost:3000)

And for testing goodness:
```
cd tests
elm-reactor
```

Then, point your browser at http://localhost:8000/Main.elm

Or, alternatively you can run the tests on the command line with
```
elm-test
```

## Production

It's currently hosted on [GitHub pages](https://pages.github.com/).

To deploy a new version to production:
```
npm run build
git commit -am "New release"
git push
```

This will build the new stuff into the docs directory. When this is committed
and pushed back to Github, Github pages will automatically pick up the new
version.

## Copyright & License

Copyright Matthew Landauer. Licensed under the GPL v3. See LICENSE.md for more details.
