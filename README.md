## Develop

```
npm run dev
```

Then point your browser at http://localhost:3000/

To run tests
```
cd tests
elm-reactor -p 8001
```

Then, point your browser at http://localhost:8001/Runner.elm

## Deploy to production

```
npm run build
git commit -a
git push
```

This will build the new stuff into the docs directory. When this is committed
and pushed back to Github, Github pages will automatically pick up the new
version.
