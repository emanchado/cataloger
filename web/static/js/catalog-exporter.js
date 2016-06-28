import followExportProgress from "web/static/js/catalog-export-progress";

function updateProgress(progressInfoEl, structPercentage, imgPercentage) {
    document.getElementById("structure-percentage").innerHTML =
        structPercentage + "%";
    document.getElementById("images-percentage").innerHTML =
        imgPercentage + "%";

    if (structPercentage >= 100 && imgPercentage >= 100) {
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
        imagesPercentage = 0;

    updateProgress(progressInfoEl, structurePercentage, imagesPercentage);

    followExportProgress(catalogId, function(nProcessed, total) {
        structurePercentage = Math.round((nProcessed / total) * 100);
        updateProgress(progressInfoEl, structurePercentage, imagesPercentage);
    }, function(nProcessed, total) {
        imagesPercentage = Math.round((nProcessed / total) * 100);
        updateProgress(progressInfoEl, structurePercentage, imagesPercentage);
    });
}

export default catalogExporter;
