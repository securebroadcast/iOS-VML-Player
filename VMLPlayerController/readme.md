
### To Start, run the following commands

setup .npmrc to get access to @securebroadcast packages on github. 
Add the following line to the .npmrc file in the project root directory, if you dont already have a token setup in your user .npmrc file :
``` 
//npm.pkg.github.com/:_authToken=[YOUR AUTH TOKEN HERE]
```

You'll need to replace the [YOUR AUTH TOKEN HERE] above with a [Personal Access Token from Github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

Then run the following commands:

```
npm install
npm run build
```

The bundle file will be saved in bundle.js

## Updating the Web Player 

* Update the player dependency in package.json
* run browserify -t browserify-css babelify PlayerSetup.js | uglifyjs -cm > bundle.js
