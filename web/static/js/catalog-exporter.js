import followExportProgress from "web/static/js/catalog-export-progress";

function updateProgress(progressInfoEl, structPercentage, imgPercentage) {
    console.log("structPercentage =", structPercentage);
    console.log("imgPercentage =", imgPercentage);
    if (structPercentage >= 100 && imgPercentage >= 100) {
        progressInfoEl.innerHTML = "Catalog exported.";
        return;
    }

    document.getElementById("structure-percentage").innerHTML =
        structPercentage + "%";
    document.getElementById("images-percentage").innerHTML =
        imgPercentage + "%";
}

function catalogExporter(catalogId, progressInfoEl) {
    const structureProgressEl = document.createElement("div"),
          imageProgressEl = document.createElement("div");
    structureProgressEl.id = "structure-progress";
    structureProgressEl.innerHTML =
        "Exporting structure: <span id='structure-percentage'></span>";
    imageProgressEl.id = "images-progress";
    imageProgressEl.innerHTML =
        "Exporting images: <span id='images-percentage'></span>";
    progressInfoEl.appendChild(structureProgressEl);
    progressInfoEl.appendChild(imageProgressEl);

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
