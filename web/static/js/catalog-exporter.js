import followExportProgress from "web/static/js/catalog-export-progress";

function updateProgress(progressInfoEl, structPercentage, imgPercentage) {
    document.getElementById("structure-percentage").innerHTML =
        structPercentage + "%";
    document.getElementById("images-percentage").innerHTML =
        imgPercentage + "%";
}

function updateFinished(progressInfoEl, structureFinished, imagesFinished) {
    if (structureFinished && imagesFinished) {
        progressInfoEl.firstChild.className = "finished";
        const finalText = document.createTextNode("Catalog exported.");
        progressInfoEl.appendChild(finalText);
    }
}

function catalogExporter(catalogId, progressInfoEl) {
    const intermediateProgressEl = document.createElement("div"),
          structureProgressEl = document.createElement("div"),
          imageProgressEl = document.createElement("div");
    structureProgressEl.id = "structure-progress";
    structureProgressEl.innerHTML =
        "Exporting structure: <span id='structure-percentage'></span>";
    imageProgressEl.id = "images-progress";
    imageProgressEl.innerHTML =
        "Exporting images: <span id='images-percentage'></span>";
    intermediateProgressEl.appendChild(document.createTextNode("Exporting catalog…"));
    intermediateProgressEl.appendChild(structureProgressEl);
    intermediateProgressEl.appendChild(imageProgressEl);
    progressInfoEl.appendChild(intermediateProgressEl);

    let structurePercentage = 0,
        imagesPercentage = 0,
        structureFinished = false,
        imagesFinished = false;

    updateProgress(progressInfoEl, structurePercentage, imagesPercentage);

    followExportProgress(catalogId, function(nProcessed, total, done) {
        structurePercentage = Math.round((nProcessed / total) * 100);
        if (done) {
            structurePercentage = 100;
            structureFinished = true;
            updateFinished(progressInfoEl, structureFinished, imagesFinished);
        }
        updateProgress(progressInfoEl, structurePercentage, imagesPercentage);
    }, function(nProcessed, total, done) {
        imagesPercentage = Math.round((nProcessed / total) * 100);
        if (done) {
            imagesPercentage = 100;
            imagesFinished = true;
            updateFinished(progressInfoEl, structureFinished, imagesFinished);
        }
        updateProgress(progressInfoEl, structurePercentage, imagesPercentage);
    });
}

export default catalogExporter;
