getPhenotypes <- function(config) {

    ## get phenotypes
    annot <- getobj(config["phenotype_file"])

    ## get PCs
    n_pcs <- as.integer(config["n_pcs"])
    if (n_pcs > 0) {
        pca <- getobj(config["pca_file"])
        pcs <- pca$vectors[,1:n_pcs,drop=FALSE]
        pccols <- paste0("PC", 1:n_pcs)
        colnames(pcs) <- pccols
        pcs <- data.frame(sample.id=rownames(pcs), pcs, stringsAsFactors=FALSE)
        pData(annot) <- left_join(pData(annot), pcs, by="sample.id")
    } else {
        pccols <- NULL
    }

    ## outcome and covariates
    outcome <- config["outcome"]
    if (!is.na(config["covars"])) {
        covars <- strsplit(config["covars"], " ", fixed=TRUE)[[1]]
    } else {
        covars <- NULL
    }
    covars <- c(covars, pccols)

    annot <- annot[,c("sample.id", outcome, covars)]

    ## select samples
    if (!is.na(config["sample_include_file"])) {
        sample.id <- getobj(config["sample_include_file"])
    } else {
        sample.id <- annot$sample.id
    }

    cc <- annot$sample.id[complete.cases(pData(annot))]
    sample.id <- intersect(sample.id, cc)

    list(annot=annot, outcome=outcome, covars=covars, sample.id=sample.id)
    
}


addInvNorm <- function(annot, nullmod, outcome, covars) {
    resid.str <- if (is(nullmod, "GENESIS.nullMixedModel")) "resid.marginal" else "resid.response"
    resid.norm <- rankNorm(nullmod[[resid.str]])
    annot$resid.norm <- resid.norm[match(annot$sample.id, nullmod$scanID)]
    
    if (is(nullmod, "GENESIS.nullMixedModel")) {
        message(paste0("resid.norm = rankNorm(resid.marginal(", outcome, " ~ ", paste(c(covars, "(1|kinship)"), collapse=" + "), "))"))
        message("Model: resid.norm ~ (1|kinship)")
    } else {
        message(paste0("resid.norm = rankNorm(resid.response(", outcome, " ~ ", paste(covars, collapse=" + "), "))"))
    }
    
    annot
}