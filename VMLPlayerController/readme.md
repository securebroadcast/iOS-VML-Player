
### To Start, run the following commands

setup .npmrc to get access to @securebroadcast packages on github. Install the .npmrc file in the project root directory with the following code:
``` 
//npm.pkg.github.com/:_authToken=[YOUR AUTH TOKEN HERE]
@securebroadcast:registry=https://npm.pkg.github.com/
```

You'll need to replace the [YOUR AUTH TOKEN HERE] above with a [Personal Access Token from Github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

Then run the following commands:

```
npm install --save-dev browserify
npm install --save-dev browserify-css
npm install

browserify -t browserify-css PlayerSetup.js > bundle.js
```

## Updating the Web Player 

* Update the player dependency in package.json
* run browserify -t browserify-css babelify PlayerSetup.js | uglifyjs -cm > bundle.js
