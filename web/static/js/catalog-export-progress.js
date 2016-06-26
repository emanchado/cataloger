import socket from "./socket";

function followExportProgress(catalogId, progressCallback) {
    let channel = socket.channel("catalog:" + catalogId, {}),
        processedImages = 0;

    channel.join()
        .receive("ok", resp => {})
        .receive("error", resp => { console.log("Unable to join", resp); });

    channel.on("image-export-progress", payload => {
        progressCallback(++processedImages, payload.all_images.length);
    });

    channel.push("start-image-export", {id: catalogId});
}

export default followExportProgress;
