require('./main.css');

const createWebPlayer = require('@securebroadcast/sbtwebplayer');
const SESSION_KEY='SESSION_ID';
let currentTimeInVideo = 0;
let projectDuration;
let isFirstPlay = false;
let playFunction;
let pauseFunction;

//const baseUrl = "http://localhost:3000/dev/";
// const baseUrl =  "https://1y0yuxp5wc.execute-api.eu-west-1.amazonaws.com/prod/";
// const baseUrl = "https://api.vml.technology/uat/";
const baseUrl = "https://ttkxgledqi.execute-api.eu-west-1.amazonaws.com/uat/";

//MARK: Networking
const callService = async (url, options, method, body) => {

    const headers = {};
    headers['Authorization'] = getVariableFromLocalStorage(SESSION_KEY);
    headers['X-Host-Domain'] = (window.location !== window.parent.location) ? document.referrer : document.location.href;
    // headers['X-Segments'] = getArrayOfSegments();

    try {
        return await fetch(url, {
        method: method,
        options,
        body: body,
        headers
        });
    } catch (e) {
        console.log('send', 'callService: ' + e);
    }
};

const parseJson = async response => {

    try {
        return response.json()
    } catch (e) {
        console.log('send', 'parseJson: ' + e);
    }

    return {};
};

//MARK: API Requests

const getVML = async (url, options, body) => {
    const response = await callService(url, options, options.method, body);
    const json = await parseJson(response);
    setVariableInLocalStorage(SESSION_KEY, json.session);
    projectDuration = json.duration;
    delete json.session;
    return json;
};


const logAnalytics = async(event, timeInVideo, metaData) => {

    const projectId = getProjectID()
    const url = baseUrl + "analytics/"

    const body = {
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
    if (this.localData.vml_id !== undefined) {
        return this.localData.vml_id;
    }

    // Host window parameter used as a backup if not passed in with local data
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });

    if (vars.id !== undefined) {
        return vars.id;
    }

    return vars.id;
}

function getParametersFromUrl(urlParameters) {
    let url;
    if (window.location.href.includes('?')) {
        url = window.location.href + "&" + urlParameters;
    } else {
        url = window.location.href + "?" + urlParameters;
    }

    // There are no URL parameters
    if (!url.includes("?")) {
        return "";
    }

    return url.substring(url.indexOf("?"));
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
    if (!isFirstPlay) {
        logAnalytics("PLAY_CLICK", currentTime, null);
        isFirstPlay = true;
    }
}

function onPause(currentTime) {
    currentTimeInVideo = currentTime;
    logAnalytics("PAUSE_CLICK", currentTime, null);
}

function onProgress(currentTime) {
    currentTimeInVideo = currentTime;
    const currentPercent = (currentTimeInVideo / projectDuration) * 100;
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

    if (this.playerOptions.autoplay === true) {

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


window.initPlayer = function(initData, playerOptions) {
    const displayControls = playerOptions.showPlayerControls === true ?  ['time', 'progress', 'play'] : [];
    const aspectRatio = playerOptions.videoFormat;
    const getPreviewService = async ({ options }) => getVML(baseUrl + "preview", { options, method: 'POST' }, initData.localData);
    const getProjectService = async ({ options }) => getVML(baseUrl + "vml/" + getProjectID() + getParametersFromUrl(initData.urlParameters), { options, method: 'GET' });

    createWebPlayer({
        attachTo: "video",
        service: getPreviewService,
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