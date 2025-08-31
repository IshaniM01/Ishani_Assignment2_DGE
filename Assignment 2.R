file_path <- "Raw_Data/DEGs_Data_1.csv"
data <- read.csv(file_path, header = TRUE)
head(data)
str(data)
data$Gene_Id    # Extract Gene_Id column
data$logFC      # Extract logFC column
data$padj       # Extract padj column

file_path <- "Raw_Data/DEGs_Data_2.csv"
data <- read.csv(file_path, header = TRUE)
head(data)
str(data)
data$Gene_Id    # Extract Gene_Id column
data$logFC      # Extract logFC column
data$padj       # Extract padj column

classify_gene <- function(logFC, padj) {
  if (is.na(padj)) {
    padj <- 1
  }
  if (logFC > 1 & padj < 0.05) {
    return("Upregulated")
  } else if (logFC < -1 & padj < 0.05) {
    return("Downregulated")
  } else {
    return("Not_Significant")
  }
}

files_to_process <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv")
result_list <- list()

files_to_process <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv")
result_list <- list()

for (file_name in files_to_process) {
  input_file_path <- file.path("Raw_Data", file_name)
  data <- read.csv(input_file_path, header = TRUE)
  
  data$padj[is.na(data$padj)] <- 1
  data$status <- mapply(classify_gene, data$logFC, data$padj)
  
  result_list[[file_name]] <- data
  
  output_file_path <- file.path("Results", paste0("Processed_", file_name))
  write.csv(data, output_file_path, row.names = FALSE)
  
  print(table(data$status))
}

results_1 <- result_list[["DEGs_Data_1.csv"]]
results_2 <- result_list[["DEGs_Data_2.csv"]]

View(results_1)
View(results_2)

if (!dir.exists("Results")) {
  dir.create("Results")
}

write.csv(results_1, "Results/Processed_DEGs_Data_1.csv", row.names = FALSE)
write.csv(results_2, "Results/Processed_DEGs_Data_2.csv", row.names = FALSE)

ls()

save.image("Ishani_Class_2_Assignment.RData")



