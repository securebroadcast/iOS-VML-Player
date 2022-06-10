require('./main.css');

const createWebPlayer = require('@securebroadcast/sbtwebplayer');
const SESSION_KEY='SESSION_ID';
var currentTimeInVideo = 0;
var urlParameters = "";
var localData = "";
var playerOptions = {};
var projectDuration;
var isFirstPLay = false;
var playFunction;
var pauseFunction;

//const baseUrl = "http://localhost:3000/dev/";
const baseUrl =  "https://1y0yuxp5wc.execute-api.eu-west-1.amazonaws.com/prod/";
// const baseUrl = "https://api.vml.technology/uat/";

//MARK: Networking
const callService = async (url, options, method, body) => {

    headers = {};
    headers['Authorization'] = getVariableFromLocalStorage(SESSION_KEY);
    headers['X-Host-Domain'] = (window.location != window.parent.location) ? document.referrer : document.location.href;
    headers['X-Segments'] = getArrayOfSegments();

    try {
        return await fetch(url, {
        method: method,
        options,
        body: body,
        headers
        });
    } catch (e) {
        rg4js('send', 'callService: ' + e);
    }
};

const parseJson = async response => {

    try {
        return response.json()
    } catch (e) {
        rg4js('send', 'parseJson: ' + e);
    }

    return {};
};

//MARK: API Requests

const getVML = async (url, options, body) => {
    const response = await callService(url, options, 'GET', body);
    const json = await parseJson(response);
    setVariableInLocalStorage(SESSION_KEY, json.session);
    projectDuration = json.duration;
    delete json.session;
    return json;
};


const logAnalytics = async(event, timeInVideo, metaData) => {

    var projectId = getProjectID()
    var url = baseUrl + "analytics/"

    var body = {
        projectId: projectId,
        event:event,
        player_time: timeInVideo,
        meta_data: metaData
    };

    webkit.messageHandlers.appCallback.postMessage(JSON.stringify(body));
    const response = await callService(url, null, 'POST', JSON.stringify(body));
    const json = await parseJson(response);
    setVariableInLocalStorage(SESSION_KEY, json.session);
};

//MARK: URL Helpers

function getProjectID() {
    var vars = {};

    // local data parameter takes precidence
    if (this.localData.vml_id != undefined) {
        return this.localData.vml_id;
    }

    // Host window parameter used as a backup if not passed in with local data
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    if (vars.id != undefined) {
        return vars.id;
    }

    return vars.id;
}

function getParametersFromUrl() {
    var url;
    if (window.location.href.includes('?')) {
        url = window.location.href + "&" + this.urlParameters;
    } else {
        url = window.location.href + "?" + this.urlParameters;
    }

    // There are no URL parameters
    if (!url.includes("?")) {
        return "";
    }

    var urlParameters = url.substring(url.indexOf("?"));
    return urlParameters;
}

function getArrayOfSegments() {
    if (this.localData.vml_segments != undefined) {
        return this.localData.vml_segments;
    }
    return undefined;
}

//MARK: Session helpers

function getVariableFromLocalStorage(key) {
   return window.localStorage.getItem(key);
}

function setVariableInLocalStorage(key, value) {
    window.localStorage.setItem(key, value);
}

//MARK: Player callback functions

function onPlay(currentTime) {
    currentTimeInVideo = currentTime;
    if (!isFirstPLay) {
        logAnalytics("PLAY_CLICK", currentTime, null);
        isFirstPLay = true;
    }
}

function onPause(currentTime) {
    currentTimeInVideo = currentTime;
    logAnalytics("PAUSE_CLICK", currentTime, null);
}

function onProgress(currentTime) {
    currentTimeInVideo = currentTime;
    var currentPercent = (currentTimeInVideo / projectDuration) * 100;
    logAnalytics("PLAYING", currentPercent, null);
}

function onFullScreenToggle(isFullScreen) {
    if (isFullScreen) {
        logAnalytics("FULL_SCREEN_ON", currentTimeInVideo, null);
    } else {
        logAnalytics("FULL_SCREEN_OFF", currentTimeInVideo, null);
    }
}

function onVideoEnd() {
    logAnalytics("COMPLETE", currentTimeInVideo, null);
}

window.playVideo = function() {
    playFunction()
}

window.pauseVideo = function() {
    pauseFunction()
}

function onReady({totalDuration, actions}) {
    logAnalytics("READY", 0.0, null);
    
    playFunction = actions.play;
    pauseFunction = actions.pause;

    console.log(this.playerOptions)

    if (this.playerOptions.autoplay == true) {

    console.log("Auto playing")
        actions.play();
    }
}

function onElementClicked(id, clickTime) {
    logAnalytics("ELEMENT_CLICKED", clickTime, id);
}

// The ID sent to the VML service can come from the host window or the parent window (if embedded in iFrame)
// The host window takes precidence over the parent window. If there is no ID in the host, we look at the parent
// All of the parents URL paramenters are sent to the VML service (not host as this is built to be embedded in sites as an iframe)
// The main usecase for this service to look at the parent window for the ID and not the iFrame is so we can dynamically set the video to be displayed
// The most common use case is for the host (iFrame) to contain the ID and have its data personalised from the host url parameters


const getService = async ({ url, options }) => getVML(baseUrl + "vml/" + getProjectID() + getParametersFromUrl(), { options, method: 'GET' });

window.initPlayer = function(initData, playerOptions) {
    
    this.urlParameters = initData.urlParameters;
    this.localData = initData.localData;
    this.playerOptions = playerOptions;
    var displayControls = playerOptions.showPlayerControls == true ?  ['time', 'progress', 'play'] : [];
    var aspectRatio = playerOptions.videoFormat;

    createWebPlayer({
        attachTo: "video",
        service: getService,
        projectId: 1,
        onPlay: onPlay,
        onPause: onPause,
        onFullScreenToggle: onFullScreenToggle,
        autoLoop: playerOptions.autoloop,
        onVideoEnd: onVideoEnd,
        progressInterval: 3,
        onReady: onReady,
        onProgress: onProgress,
        onElementClicked: onElementClicked,
        data: initData.localData,
        useOverlayControls: playerOptions.showPlayerControls,
        allowedControls: displayControls,
        aspectRatio: aspectRatio
    })
};